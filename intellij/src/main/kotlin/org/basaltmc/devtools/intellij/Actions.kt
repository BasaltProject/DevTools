package org.basaltmc.devtools.intellij

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.project.DumbAware

abstract class KilnAction(private val verb: String) : AnAction(), DumbAware {
    override fun actionPerformed(event: AnActionEvent) {
        event.project?.let { Kiln.run(it, verb) }
    }

    override fun update(event: AnActionEvent) {
        event.presentation.isEnabledAndVisible = event.project?.let { Kiln.pluginRoot(it) } != null
    }
}

class CheckAction : KilnAction("check")

class CompileAction : KilnAction("compile")

class SyncApiAction : AnAction(), DumbAware {
    override fun actionPerformed(event: AnActionEvent) {
        event.project?.let(ApiDefinitions::sync)
    }

    override fun update(event: AnActionEvent) {
        event.presentation.isEnabledAndVisible = event.project?.let { Kiln.pluginRoot(it) } != null
    }
}
