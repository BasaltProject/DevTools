package org.basaltmc.devtools.intellij

import com.intellij.openapi.project.Project
import com.intellij.openapi.startup.ProjectActivity

class StartupCheck : ProjectActivity {
    override suspend fun execute(project: Project) {
        if (Kiln.pluginRoot(project) == null) return
        Kiln.run(project, "check")
    }
}
