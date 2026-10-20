package org.basaltmc.devtools.intellij

import com.intellij.openapi.fileEditor.OpenFileDescriptor
import com.intellij.openapi.project.DumbAware
import com.intellij.openapi.project.Project
import com.intellij.openapi.wm.ToolWindow
import com.intellij.openapi.wm.ToolWindowFactory
import com.intellij.openapi.vfs.LocalFileSystem
import com.intellij.ui.ColoredListCellRenderer
import com.intellij.ui.SimpleTextAttributes
import com.intellij.ui.components.JBList
import com.intellij.ui.components.JBScrollPane
import com.intellij.ui.content.ContentFactory
import java.awt.event.MouseAdapter
import java.awt.event.MouseEvent
import java.io.File
import javax.swing.JList

class ProblemsToolWindowFactory : ToolWindowFactory, DumbAware {
    override fun createToolWindowContent(project: Project, toolWindow: ToolWindow) {
        val list = JBList(project.getService(ProblemsModel::class.java).items)
        list.emptyText.text = "Kiln found nothing, or has not run yet"
        list.cellRenderer = object : ColoredListCellRenderer<Problem>() {
            override fun customizeCellRenderer(
                list: JList<out Problem>, value: Problem?, index: Int, selected: Boolean, focused: Boolean
            ) {
                value ?: return
                append("${value.path}:${value.line}  ", SimpleTextAttributes.GRAYED_ATTRIBUTES)
                append(value.message)
            }
        }
        list.addMouseListener(object : MouseAdapter() {
            override fun mouseClicked(event: MouseEvent) {
                if (event.clickCount < 2) return
                val problem = list.selectedValue ?: return
                val file = project.basePath?.let { LocalFileSystem.getInstance().findFileByIoFile(File(it, problem.path)) }
                    ?: return
                OpenFileDescriptor(project, file, problem.line - 1, 0).navigate(true)
            }
        })
        val content = ContentFactory.getInstance().createContent(JBScrollPane(list), "Problems", false)
        toolWindow.contentManager.addContent(content)
    }
}
