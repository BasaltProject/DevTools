package org.basaltmc.devtools.intellij

import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.LocalFileSystem
import java.io.File

object ApiDefinitions {
    /** Puts the target's `---@meta` definitions in `.basalt/api`, where a Lua plugin for the IDE indexes them. */
    fun sync(project: Project) {
        val root = Kiln.pluginRoot(project) ?: return
        val target = BasaltSettings.get().target
        val source = ApiDefinitions::class.java.classLoader.getResourceAsStream("definitions/$target/basalt.lua") ?: return
        val destination = File(root, ".basalt/api/basalt.lua")
        destination.parentFile.mkdirs()
        source.use { input -> destination.outputStream().use { input.copyTo(it) } }
        LocalFileSystem.getInstance().refreshAndFindFileByIoFile(destination)
    }
}
