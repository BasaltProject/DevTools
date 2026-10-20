package org.basaltmc.devtools.intellij

import com.intellij.openapi.options.BoundConfigurable
import com.intellij.openapi.ui.DialogPanel
import com.intellij.ui.dsl.builder.bindItem
import com.intellij.ui.dsl.builder.bindSelected
import com.intellij.ui.dsl.builder.bindText
import com.intellij.ui.dsl.builder.panel
import com.intellij.ui.dsl.builder.MutableProperty

class BasaltConfigurable : BoundConfigurable("Basalt") {
    override fun createPanel(): DialogPanel {
        val values = BasaltSettings.get()
        return panel {
            row("Target:") {
                comboBox(listOf("server", "proxy"))
                    .bindItem(MutableProperty({ values.target }, { values.target = it ?: "server" }))
                    .comment("The product the plugin is for. It picks the API the editor completes and the checks Kiln runs.")
            }
            row("Kiln executable:") {
                textField().bindText(values::kilnPath)
            }
            row {
                checkBox("Run Kiln when a Lua file or plugin.toml is saved").bindSelected(values::checkOnSave)
            }
        }
    }
}
