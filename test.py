import sys
from PyQt5.QtWidgets import QApplication, QSystemTrayIcon, QMenu, QAction
from PyQt5.QtGui import QIcon, QPixmap
from PyQt5.QtCore import QCoreApplication

class TrayApp:
    def __init__(self):
        self.app = QApplication(sys.argv)

        # Create the system tray icon
        self.tray_icon = QSystemTrayIcon(QIcon(QPixmap(16, 16)), self.app)

        # Create a context menu
        menu = QMenu()

        # Add actions to the menu
        show_action = QAction("Show Notification")
        show_action.triggered.connect(self.show_notification)
        menu.addAction(show_action)

        exit_action = QAction("Exit")
        exit_action.triggered.connect(QCoreApplication.quit)
        menu.addAction(exit_action)

        # Set the context menu to the tray icon
        self.tray_icon.setContextMenu(menu)

        # Show the tray icon
        self.tray_icon.show()
        self.show_notification()

    def show_notification(self):
        self.tray_icon.showMessage(
            "Notification Title", 
            "This is a desktop notification message!",
            QIcon(QPixmap(16, 16)),
            2000  # Duration in milliseconds
        )

if __name__ == "__main__":
    app = TrayApp()
    sys.exit(app.app.exec_())

