#!/usr/bin/python

# Install
from liquidctl.driver.smart_device import SmartDevice
from liquidctl.driver.asetek import Hydro690Lc
import notify2

# Provided
from FanDriverHardwareLib import HardwareLib
from FanDriverConfigLib import ConfigLib

import time
import json

class FanDriverService:

    hardwareControl = HardwareLib()
    smartHub = SmartDevice.find_supported_devices()[0]
    smartHub.connect()
    smartHub.initialize()
    waterCooler = Hydro690Lc.find_supported_devices()[0]
    waterCooler.connect()
    waterCooler.initialize()

    lastProbe = None
    lastTemp = None
    gpuTemp = None
    cpuTemp = None

    def __init__(self, config):
        self.config = config
        self.setCaseLights()
        self.setAIOSettings()
        self.initialize()

    def initialize(self):
        while True:
            time.sleep(5)
            temp = self.getTemp()
            if temp != self.lastTemp:
                if temp == -256:
                    self.sendNotification("Failed to comunicate with tempature probe!", f"The {probe} driver may not be initialize.")
                    self.lastTemp = -256
                    temp = 90
                else:
                    self.lastTemp = temp
                speed = self.config['SmartHub']['Fan'][f'{self.lastProbe} Curve'][str(temp)]
                print(f"{self.lastProbe} tempature changed to ~{temp}c, setting fan to {speed}%")
                self.setCaseFans(speed)
            #print(json.dumps(self.getData(), indent=2))

    def getTemp(self):
        self.lastProbe = self.config['SmartHub']['Fan']['Probe']
        if self.lastProbe == "GPU":
            temp = self.pollGPU()
        elif self.lastProbe == "BOTH":
            gpu = self.pollGPU()
            cpu = self.pollCPU()
            if self.gpuTemp == None or self.cpuTemp == None:
                temp = None
            elif cpu > gpu:
                self.lastProbe = "CPU"
                temp = cpu
            else:
                self.lastProbe = "GPU"
                temp = gpu
        else:
            temp = self.pollCPU()
        return self.normalizeTemp(temp)

    def pollGPU(self):
        self.lastProbe = "GPU"
        self.gpuTemp = self.hardwareControl.get_gpu_temp()
        return self.normalizeTemp(self.gpuTemp)

    def pollCPU(self):
        self.lastProbe = "CPU"
        self.cpuTemp = self.hardwareControl.get_cpu_temp()
        return self.normalizeTemp(self.cpuTemp)

    def normalizeTemp(self, temp):
        if temp == None:
            return -256
        elif temp < 20:
            return 20
        elif temp > 94:
            return 90
        else:
            if self.lastProbe == "CPU":
                return round(temp, -1)
            else:
                return (temp // 10) * 10

    def getData(self):
        data = self.config
        data['CPU'] = {}
        data['GPU'] = {}
        try:
            data['Current Probe'] = self.lastProbe
            data['Last State'] = self.lastTemp
            data['Last Speed'] = self.config['SmartHub']['Fan']['Curve'][str(self.lastTemp)]
            data['CPU']['Model'] = self.hardwareControl.cpuModel
            data['CPU']['Temp'] = self.cpuTemp
            data['GPU']['Model'] = self.hardwareControl.gpuModel
            data['GPU']['Temp'] = self.gpuTemp
        except:
            pass
        return data

    def setCaseFans(self, speed):
        self.smartHub.set_fixed_speed("sync", speed)
        pass

    def setCaseLights(self):
        mode = self.config['SmartHub']['Light Strips']['ColorMode']
        colors = self.config['SmartHub']['Light Strips']['Colors']
        speed = self.config['SmartHub']['Light Strips']['Speed']
        self.smartHub.set_color("led", mode, colors, speed)

    def setAIOSettings(self):
        mode = self.config['AIO']['Light']['ColorMode']
        color = self.config['AIO']['Light']['Colors']
        self.waterCooler.set_color("led", mode, color)

    def sendNotification(self, title, message):
        notify2.init('Fan Driver')
        n = notify2.Notification(title, message, "notification-message-im")
        n.show()

configLib = ConfigLib()
FanDriverService(configLib.config)







