package org.basaltmc.devtools.intellij

import com.intellij.testFramework.fixtures.BasePlatformTestCase
import java.io.File

class KilnTest : BasePlatformTestCase() {
    fun testParsesWhatKilnReports() {
        val problems = Kiln.parse("src/main.lua:12: unknown function 'nope'\nplugin.toml: missing id\nnoise")
        assertEquals(
            listOf(Problem("src/main.lua", 12, "unknown function 'nope'"), Problem("plugin.toml", 1, "missing id")),
            problems
        )
    }

    fun testRunsKilnAndListsItsFindings() {
        val root = File(project.basePath!!).also { it.mkdirs() }
        File(root, "plugin.toml").writeText("id = \"demo\"\n")
        val fakeKiln = File(root, "kiln").apply {
            writeText("#!/bin/sh\necho 'main.lua:3: bad call' >&2\nexit 1\n")
            setExecutable(true)
        }
        BasaltSettings.get().kilnPath = fakeKiln.path
        Kiln.run(project, "check")
        val model = project.getService(ProblemsModel::class.java)
        val deadline = System.currentTimeMillis() + 20_000
        while (model.items.isEmpty && System.currentTimeMillis() < deadline) {
            com.intellij.testFramework.PlatformTestUtil.dispatchAllEventsInIdeEventQueue()
            Thread.sleep(50)
        }
        assertEquals(1, model.items.size())
        assertEquals(Problem("main.lua", 3, "bad call"), model.items[0])
    }

    fun testSyncsTheApiDefinitions() {
        val root = File(project.basePath!!).also { it.mkdirs() }
        File(root, "plugin.toml").writeText("id = \"demo\"\n")
        BasaltSettings.get().target = "server"
        ApiDefinitions.sync(project)
        assertTrue(File(root, ".basalt/api/basalt.lua").readText().contains("---@meta"))
    }
}
