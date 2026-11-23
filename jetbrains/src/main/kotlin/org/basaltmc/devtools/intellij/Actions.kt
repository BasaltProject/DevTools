package org.basaltmc.devtools.intellij

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.project.DumbAware
import com.intellij.openapi.ui.Messages

abstract class KilnAction(private val verb: String) : AnAction(), DumbAware {
    override fun actionPerformed(event: AnActionEvent) {
        event.project?.let { Kiln.run(it, verb) }
    }

    override fun update(event: AnActionEvent) {
        event.presentation.isEnabledAndVisible = event.project?.let { Kiln.pluginRoot(it) } != null
    }
}

class BuildAction : KilnAction("build")

class CheckAction : KilnAction("check")

class PackAction : KilnAction("pack")

class NewPluginAction : AnAction(), DumbAware {
    override fun actionPerformed(event: AnActionEvent) {
        val project = event.project ?: return
        val id = Messages.showInputDialog(
            project, "Plugin id (lowercase letters, digits and _):", "New Basalt Plugin", null, "my_plugin",
            null
        ) ?: return
        val language = choose(project, "Language", Kiln.languages) ?: return
        val target = choose(project, "Target product", listOf("server", "proxy")) ?: return
        Kiln.create(project, id, language, target)
    }

    private fun choose(project: com.intellij.openapi.project.Project, title: String, options: List<String>): String? {
        val picked = Messages.showChooseDialog(project, title, "New Basalt Plugin", null, options.toTypedArray(), options[0])
        return if (picked < 0) null else options[picked]
    }
}
