from liquidctl.driver.smart_device import SmartDevice
from liquidctl.driver.asetek import Hydro690Lc
from HardwareTemps import HardwareTemp
from desktop_notifier import DesktopNotifier
import asyncio
import time

class FanDriverService:

    notifier = DesktopNotifier()
    temps = HardwareTemp()
    smartHub = SmartDevice.find_supported_devices()[0]
    smartHub.connect()
    smartHub.initialize()
    waterCooler = Hydro690Lc.find_supported_devices()[0]
    waterCooler.connect()
    waterCooler.initialize()

    lastProbe = None
    lastTemp = None

    def __init__(self, config):
        self.config = config
        self.setCaseLights()
        self.setAIOSettings()
        self.initialize()

    def initialize(self):
        while True:
            time.sleep(5)
            temp, probe = self.getTemp()
            if temp != self.lastTemp:
                if temp == 255:
                    asyncio.run(self.sendNotification("Failed to comunicate with tempature probe!", f"The {probe} driver may not be initialize."))
                    self.lastTemp = 255
                    temp = 90
                else:
                    self.lastTemp = temp
                speed = self.config['SmartHub']['Fan']['Curve'][str(temp)]
                print(f"{probe} tempature changed to ~{temp}c, setting fan to {speed}%")
                self.setCaseFans(speed)

    def getTemp(self):
        probe = self.config['SmartHub']['Fan']['Probe']
        if probe == "GPU":
            return self.pollGPU(), probe
        if probe == "BOTH":
            gpuTemp = self.pollGPU()
            cpuTemp = self.pollCPU()
            if gpuTemp > cpuTemp:
                if self.lastProbe != "GPU":
                    self.lastProbe = "GPU"
                    print("GPU is hotter, using GPU probe")
                return gpuTemp, "GPU"
            else:
                if self.lastProbe != "CPU":
                    self.lastProbe = "CPU"
                    print("CPU is hotter, using CPU probe")
                return cpuTemp, "CPU"
        else:
            return self.pollCPU(), probe

    def pollGPU(self):
        return self.normalizeTemp(self.temps.get_gpu_temp())

    def pollCPU(self):
        #return self.normalizeTemp(self.temps.get_cpu_usage())
        return self.normalizeTemp(self.temps.get_cpu_temp())

    def normalizeTemp(self, temp):
        if temp == None:
            return 255
        elif temp < 20:
            return 20
        elif temp > 94:
            return 90
        else:
            return round(temp, -1)
            #return (temp // 10) * 10

    def setCaseFans(self, speed):
        self.smartHub.set_fixed_speed("sync", speed)

    def setCaseLights(self):
        mode = self.config['SmartHub']['Light Strips']['ColorMode']
        colors = self.config['SmartHub']['Light Strips']['Colors']
        speed = self.config['SmartHub']['Light Strips']['Speed']
        self.smartHub.set_color("led", mode, colors, speed)

    def setAIOSettings(self):
        mode = self.config['AIO']['Light']['ColorMode']
        color = self.config['AIO']['Light']['Colors']
        self.waterCooler.set_color("led", mode, color)

    async def sendNotification(self, title, message):
        await self.notifier.send(
            title=title,
            message=message)

config = {
    'SmartHub': {
        'Light Strips': {
            'ColorMode': 'spectrum-wave',
            'Colors': [[0, 0, 0]],
            'Speed': 'slowest'
        },
        'Fan': {
            'Probe': 'BOTH',
            'Curve': {
                '20': 20,
                '30': 20,
                '40': 20,
                '50': 20,
                '60': 20,
                '70': 100,
                '80': 100,
                '90': 100
            }
        }
    },
    'AIO': {
        'Light': {
            'ColorMode': 'fixed',
            'Colors': [[255, 255, 255]]
        },
        'Fan Curve': {
            '24': 20,
            '36': 20,
            '48': 33,
            '60': 50,
            '72': 70,
            '84': 100
        }
    },
}
FanDriverService(config)







