package org.basaltmc.devtools.intellij

import com.intellij.openapi.components.Service
import javax.swing.DefaultListModel

@Service(Service.Level.PROJECT)
class ProblemsModel {
    val items = DefaultListModel<Problem>()

    fun replace(problems: List<Problem>) {
        items.clear()
        problems.forEach(items::addElement)
    }
}
