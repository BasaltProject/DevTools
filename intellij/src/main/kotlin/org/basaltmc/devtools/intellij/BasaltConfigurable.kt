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
            row("Target for new plugins:") {
                comboBox(listOf("server", "proxy"))
                    .bindItem(MutableProperty({ values.target }, { values.target = it ?: "server" }))
                    .comment("The product a new plugin is for.")
            }
            row("Kiln executable:") {
                textField().bindText(values::kilnPath).comment("Empty looks for kiln on the PATH.")
            }
            row {
                checkBox("Run Kiln check when plugin.toml is saved").bindSelected(values::checkOnSave)
            }
        }
    }
}
