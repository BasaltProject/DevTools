package org.basaltmc.devtools.intellij

import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.components.PersistentStateComponent
import com.intellij.openapi.components.State
import com.intellij.openapi.components.Storage

@State(name = "BasaltSettings", storages = [Storage("basalt.xml")])
class BasaltSettings : PersistentStateComponent<BasaltSettings.Values> {
    class Values {
        var target: String = "server"
        var kilnPath: String = "kiln"
        var checkOnSave: Boolean = true
    }

    private var values = Values()

    override fun getState(): Values = values

    override fun loadState(state: Values) {
        values = state
    }

    companion object {
        fun get(): Values = ApplicationManager.getApplication().getService(BasaltSettings::class.java).state
    }
}
