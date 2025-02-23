import sys
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel, QSlider
from PyQt6.QtCore import Qt, QTimer
from FanDriverHardwareLib import HardwareLib
from FanDriverConfigLib import ConfigLib
from liquidctl.driver.smart_device import SmartDevice

class HardwareStatus():
    hardwareControl = HardwareLib()

    def __init__(self, probe):
        self.probe = probe

    def pollGPU(self):
        return self.hardwareControl.get_gpu_temp()

    def pollCPU(self):
        return self.hardwareControl.get_cpu_temp()

    def getTemp(self):
        currProbe = self.probe
        if self.probe == "BOTH":
            gpu = self.pollGPU()
            cpu = self.pollCPU()
            if gpu == None or cpu == None:
                temp = None
            elif cpu > gpu:
                currProbe = "CPU"
                temp = cpu
            else:
                currProbe = "GPU"
                temp = gpu
        else:
            if self.probe == "GPU":
                temp = self.pollGPU()
            else:
                temp = self.pollCPU()
        return temp, currProbe

class CaseFanControler():

    currentSpeed = 0
    smartHub = SmartDevice.find_supported_devices()[0]

    def __init__(self, curve, currTemp=0):
        self.smartHub.connect()
        self.smartHub.initialize()
        speed = self.getSpeed(currTemp, curve)
        self.setSpeed(speed)

    def find_neighbors(self, temp, curve):
        int_keys = [int(key) for key in curve.keys()]
        sorted_keys = sorted(int_keys)  # Sort dictionary keys
        small, big = next(iter(int_keys)), next(reversed(int_keys))
        print(small, big)

        for key in sorted_keys:
            if key <= temp:
                small = key
            elif key >= temp:
                big = key
                break  # Stop once we find the next bigger number
        mult = 1
        diff = abs(big-small)
        if diff != 0:
            mult = (temp%small)/diff
        return curve[str(small)], curve[str(big)], mult

    def getSpeed(self, temp, curve):
        smallest, biggest, mult = self.find_neighbors(temp, curve)
        print(mult, temp, smallest)
        speed = int((mult*abs(biggest-smallest))+smallest)
        #print(mult, diff, smallest, biggest, speed)
        if speed > 100:
            speed = 100
        elif speed < 0:
            speed = 0
        elif speed > biggest:
            speed = biggest
        elif speed < smallest:
            speed = smallest
        return speed

    def setSpeed(self, speed):
        if speed != self.currentSpeed:
            self.smartHub.set_fixed_speed("sync", speed)
            print(f"Setting fan to {speed}%")
            self.currentSpeed = speed

class SliderApp(QWidget):

    curve = {
        'CPU': {
            "60": 20,
            "70": 100
        },
        'GPU': {
            "50": 20,
            "55": 100
        }
    }

    def __init__(self):
        super().__init__()
        layout = QVBoxLayout()

        #self.speed = self.curve['20']
        self.label = QLabel(f"Value: 0C @ 0%\nQueued", self)
        self.lastTemp = 0
        self.label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(self.label)

        self.slider = QSlider(Qt.Orientation.Horizontal)
        self.slider.setRange(0, 100)
        self.slider.setValue(0)
        self.temp = self.slider.value()
        self.slider.valueChanged.connect(self.setTemp)
        layout.addWidget(self.slider)

        self.setLayout(layout)
        self.setWindowTitle("Slider Example")
        self.resize(300, 150)

        self.initDrivers()

    def initDrivers(self):
        self.hardware = HardwareStatus("BOTH")
        self.case = CaseFanControler(self.curve['GPU'], self.slider.value())
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.pushUpdate)
        self.timer.start(5000)

    def pushUpdate(self):
        temp, probe = self.hardware.getTemp()
        #temp = self.temp
        if temp != self.lastTemp:
            speed = self.case.getSpeed(temp, self.curve['GPU'])
            self.case.setSpeed(speed)
            self.label.setText(f"Value: {probe} {temp}C @ {speed}%\nSet")
            self.lastTemp = temp

    def setTemp(self, temp):
        self.temp = temp


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = SliderApp()
    window.show()
    sys.exit(app.exec())
