package org.basaltmc.devtools.intellij

import com.intellij.execution.configurations.GeneralCommandLine
import com.intellij.execution.process.CapturingProcessHandler
import com.intellij.notification.NotificationGroupManager
import com.intellij.notification.NotificationType
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.progress.ProgressIndicator
import com.intellij.openapi.progress.ProgressManager
import com.intellij.openapi.progress.Task
import com.intellij.openapi.project.Project
import java.io.File

/** One line of a Kiln report: the file, the 1-based line (1 when Kiln gave none) and what is wrong. */
data class Problem(val path: String, val line: Int, val message: String)

object Kiln {
    private val reportLine = Regex("^(.+?)(?::(\\d+))?: (.+)$")

    fun parse(report: String): List<Problem> = report.lineSequence().mapNotNull { raw ->
        reportLine.matchEntire(raw.trim())?.let { found ->
            Problem(found.groupValues[1], found.groupValues[2].toIntOrNull() ?: 1, found.groupValues[3])
        }
    }.toList()

    fun pluginRoot(project: Project): File? =
        project.basePath?.let(::File)?.takeIf { File(it, "plugin.toml").isFile }

    fun run(project: Project, verb: String) {
        val root = pluginRoot(project) ?: return
        val settings = BasaltSettings.get()
        ProgressManager.getInstance().run(object : Task.Backgroundable(project, "Kiln $verb", false) {
            override fun run(indicator: ProgressIndicator) {
                val command = GeneralCommandLine(settings.kilnPath, verb, root.path, "--target", settings.target)
                    .withWorkDirectory(root)
                val outcome = try {
                    val result = CapturingProcessHandler(command).runProcess(60_000)
                    Outcome(result.exitCode == 0, result.stderr, null)
                } catch (error: com.intellij.execution.ExecutionException) {
                    Outcome(false, "", "Kiln was not found. Set its location in Settings | Tools | Basalt.")
                }
                val problems = parse(outcome.report)
                ApplicationManager.getApplication().invokeLater {
                    project.getService(ProblemsModel::class.java).replace(problems)
                    if (outcome.failure != null) {
                        notify(project, outcome.failure, NotificationType.ERROR)
                    } else if (verb == "compile" && outcome.success) {
                        notify(project, "The plugin was compiled.", NotificationType.INFORMATION)
                    }
                }
            }
        })
    }

    private class Outcome(val success: Boolean, val report: String, val failure: String?)

    private fun notify(project: Project, text: String, type: NotificationType) {
        NotificationGroupManager.getInstance().getNotificationGroup("Basalt")
            .createNotification("Basalt", text, type).notify(project)
    }
}
