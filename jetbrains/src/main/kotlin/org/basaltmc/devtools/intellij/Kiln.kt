package org.basaltmc.devtools.intellij

import com.intellij.execution.ExecutionException
import com.intellij.execution.configurations.GeneralCommandLine
import com.intellij.execution.process.CapturingProcessHandler
import com.intellij.notification.NotificationGroupManager
import com.intellij.notification.NotificationType
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.progress.ProgressIndicator
import com.intellij.openapi.progress.ProgressManager
import com.intellij.openapi.progress.Task
import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.LocalFileSystem
import java.io.File

/** One line of a Kiln report: the file, the 1-based line (1 when Kiln gave none) and what is wrong. */
data class Problem(val path: String, val line: Int, val message: String)

object Kiln {
    val languages = listOf("cpp", "c", "zig", "rust", "assemblyscript", "go", "kotlin", "csharp", "java")

    private val compilerLine = Regex("^(?:kiln \\w+: )?(.+?):(\\d+):(?:\\d+:)? (?:error|warning|fatal error): (.+)$")
    private val kilnLine = Regex("^(?:kiln \\w+: )?([^\\s:][^:]*?[./][^:\\s]*?)(?::(\\d+))?: (.+)$")

    fun parse(report: String, root: File? = null): List<Problem> = report.lineSequence().mapNotNull { raw ->
        val text = raw.trim()
        val found = compilerLine.matchEntire(text)
        if (found != null) {
            Problem(relative(found.groupValues[1], root), found.groupValues[2].toInt(), found.groupValues[3])
        } else {
            kilnLine.matchEntire(text)?.let {
                Problem(relative(it.groupValues[1], root), it.groupValues[2].toIntOrNull() ?: 1, it.groupValues[3])
            }
        }
    }.toList()

    private fun relative(path: String, root: File?): String =
        if (root != null && File(path).isAbsolute) File(path).relativeToOrSelf(root).path else path

    fun pluginRoot(project: Project): File? =
        project.basePath?.let(::File)?.takeIf { File(it, "plugin.toml").isFile }

    fun executable(): String = BasaltSettings.get().kilnPath.ifBlank { "kiln" }

    fun run(project: Project, verb: String) {
        val root = pluginRoot(project) ?: return
        execute(project, "Kiln $verb", listOf(verb, root.path), root) { outcome ->
            val problems = parse(outcome.report, root)
            project.getService(ProblemsModel::class.java).replace(problems)
            if (outcome.failure == null && outcome.success && verb != "check") {
                notify(project, "Kiln $verb finished.", NotificationType.INFORMATION)
            }
        }
    }

    fun create(project: Project, id: String, language: String, target: String) {
        val parent = File(project.basePath ?: return)
        execute(project, "Kiln new", listOf("new", id, "--lang", language, "--target", target), parent) { outcome ->
            if (outcome.success) {
                LocalFileSystem.getInstance().refreshAndFindFileByIoFile(File(parent, id))
                notify(project, "Created $id in ${File(parent, id).path}.", NotificationType.INFORMATION)
            } else if (outcome.failure == null) {
                notify(project, outcome.report.trim().lines().lastOrNull().orEmpty(), NotificationType.ERROR)
            }
        }
    }

    private class Outcome(val success: Boolean, val report: String, val failure: String?)

    private fun execute(project: Project, title: String, args: List<String>, directory: File, done: (Outcome) -> Unit) {
        ProgressManager.getInstance().run(object : Task.Backgroundable(project, title, false) {
            override fun run(indicator: ProgressIndicator) {
                val outcome = try {
                    val result = CapturingProcessHandler(GeneralCommandLine(listOf(executable()) + args).withWorkDirectory(directory))
                        .runProcess(600_000)
                    Outcome(result.exitCode == 0, result.stdout + "\n" + result.stderr, null)
                } catch (error: ExecutionException) {
                    Outcome(
                        false, "",
                        "Kiln was not found. Put it on the PATH or set it in Settings | Tools | Basalt. " +
                            "Releases: https://github.com/BasaltProject/Kiln/releases"
                    )
                }
                ApplicationManager.getApplication().invokeLater {
                    done(outcome)
                    outcome.failure?.let { notify(project, it, NotificationType.ERROR) }
                }
            }
        })
    }

    private fun notify(project: Project, text: String, type: NotificationType) {
        NotificationGroupManager.getInstance().getNotificationGroup("Basalt")
            .createNotification("Basalt", text, type).notify(project)
    }
}
