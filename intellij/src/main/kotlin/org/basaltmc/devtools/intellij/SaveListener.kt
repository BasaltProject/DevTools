package org.basaltmc.devtools.intellij

import com.intellij.openapi.project.ProjectManager
import com.intellij.openapi.vfs.newvfs.BulkFileListener
import com.intellij.openapi.vfs.newvfs.events.VFileContentChangeEvent
import com.intellij.openapi.vfs.newvfs.events.VFileEvent

class SaveListener : BulkFileListener {
    override fun after(events: List<VFileEvent>) {
        if (!BasaltSettings.get().checkOnSave) return
        val saved = events.filterIsInstance<VFileContentChangeEvent>().map { it.file }
            .filter { it.name == "plugin.toml" || it.extension == "lua" }
        if (saved.isEmpty()) return
        for (project in ProjectManager.getInstance().openProjects) {
            val base = project.basePath ?: continue
            if (Kiln.pluginRoot(project) != null && saved.any { it.path.startsWith(base) }) {
                Kiln.run(project, "check")
            }
        }
    }
}
