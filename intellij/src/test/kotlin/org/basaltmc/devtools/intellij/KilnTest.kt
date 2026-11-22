package org.basaltmc.devtools.intellij

import com.intellij.testFramework.fixtures.BasePlatformTestCase
import java.io.File

class KilnTest : BasePlatformTestCase() {
    fun testParsesWhatKilnReports() {
        val report = "plugin.toml: `abi` is 9\nbuild/plugin.wasm: import basalt.nope is not part of ABI 1\n" +
            "kiln build: /w/demo/src/main.c:1:9: error: expected expression\n2 problem(s)"
        assertEquals(
            listOf(
                Problem("plugin.toml", 1, "`abi` is 9"),
                Problem("build/plugin.wasm", 1, "import basalt.nope is not part of ABI 1"),
                Problem("src/main.c", 1, "expected expression")
            ),
            Kiln.parse(report, File("/w/demo"))
        )
    }

    fun testRunsKilnAndListsItsFindings() {
        val root = File(project.basePath!!).also { it.mkdirs() }
        File(root, "plugin.toml").writeText("id = \"demo\"\n")
        val fakeKiln = File(root, "kiln").apply {
            writeText("#!/bin/sh\necho 'plugin.toml:3: bad value'\nexit 1\n")
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
        assertEquals(Problem("plugin.toml", 3, "bad value"), model.items[0])
    }
}
