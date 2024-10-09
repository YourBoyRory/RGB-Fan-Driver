import sys
import numpy as np
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout
import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backend_bases import PickEvent

class FanCurveGraph(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Interactive Fan Curve')

        # Set the fixed size for the window
        self.setFixedSize(800, 600)

        # Create layout
        layout = QVBoxLayout()

        # Create matplotlib figure and canvas
        self.fig, self.ax = plt.subplots(figsize=(8, 6))  # Set figure size (static)
        self.canvas = FigureCanvas(self.fig)
        layout.addWidget(self.canvas)

        # Set initial points for the fan curve (example data)
        self.points = [(20, 20), (30, 20), (40, 20), (50, 20), (60, 20), (70, 100), (80, 100), (90, 100)]

        # Plot initial data
        self.plot_curve()

        # Make points interactive
        self.selected_point = None

        # Set the layout for the QWidget
        self.setLayout(layout)

        # Connect the canvas to events
        self.canvas.mpl_connect('button_press_event', self.on_click)
        self.canvas.mpl_connect('motion_notify_event', self.on_move)

    def plot_curve(self):
        """ Plot the fan curve from the current points. """
        self.ax.clear()

        # Set x and y limits
        self.ax.set_xlim(20, 90)
        self.ax.set_ylim(0, 100)

        # Set x and y ticks with intervals
        self.ax.set_xticks(np.arange(20, 91, 10))  # X axis from 20 to 90 with interval of 10
        self.ax.set_yticks(np.arange(0, 101, 10))  # Y axis from 0 to 100 with interval of 10

        # Plot the points and curve
        x, y = zip(*self.points)
        self.ax.plot(x, y, marker='o', linestyle='-', color='b')
        self.ax.set_xlabel('Temperature')
        self.ax.set_ylabel('Fan Speed')
        self.canvas.draw()

    def on_click(self, event: PickEvent):
        """ Handle click events to select and move points. """
        if event.inaxes != self.ax:
            return

        # Check if we clicked on a point (find closest point)
        closest_point = None
        min_dist = float('inf')
        for i, (px, py) in enumerate(self.points):
            dist = np.sqrt((event.xdata - px) ** 2 + (event.ydata - py) ** 2)
            if dist < min_dist and dist < 0.1:  # Threshold for selecting a point
                min_dist = dist
                closest_point = i

        if closest_point is not None:
            self.selected_point = closest_point
            self.plot_curve()

    def on_move(self, event):
        """ Handle mouse drag event to move points. """
        if self.selected_point is None or event.inaxes != self.ax:
            return

        # Update the selected point position based on mouse movement
        self.points[self.selected_point] = (event.xdata, event.ydata)
        self.plot_curve()

    def set_curve(self, new_points):
        """ Set new points for the fan curve and update the plot. """
        self.points = new_points
        self.plot_curve()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = FanCurveGraph()
    window.show()
    sys.exit(app.exec_())



