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
    smartHub = None
    try:
        smartHub = SmartDevice.find_supported_devices()[0]
        smartHub.connect()
        smartHub.initialize()
    except:
        print("FANS GONE!")
    waterCooler = None
    try:
        waterCooler = Hydro690Lc.find_supported_devices()[0]
        waterCooler.connect()
        waterCooler.initialize()
    except:
        print("LOOP GONE!")

    lastProbe = None
    lastTemp = None
    gpuTemp = None
    cpuTemp = None

    def __init__(self, config):
        self.config = config
        if self.waterCooler:
            self.setAIOSettings()
        if self.smartHub:
            self.setCaseLights()
            self.initialize()

    def initialize(self):
        while True:
            time.sleep(5)
            realTemp, temp = self.getTemp()
            if realTemp != self.lastTemp:
                if temp == -256:
                    self.sendNotification("Failed to comunicate with tempature probe!", f"The {probe} driver may not be initialize.")
                    self.lastTemp = -256
                    temp = 90
                else:
                    self.lastTemp = realTemp
                smallest, biggest = self.find_neighbors(self.config['SmartHub']['Fan'][f'{self.lastProbe} Curve'], realTemp)
                print(biggest, smallest)
                speed = self.getSpeed(realTemp, biggest, smallest)
                print(f"{self.lastProbe} tempature changed to {realTemp}c, setting fan to {speed}%")
                self.setCaseFans(speed)
            #print(json.dumps(self.getData(), indent=2))

    def find_neighbors(self, data, target):
        int_keys = [int(key) for key in data.keys()]
        sorted_keys = sorted(int_keys)  # Sort dictionary keys
        small, big = 20, 90

        for key in sorted_keys:
            if key <= target:
                small = key
            elif key >= target:
                big = key
                break  # Stop once we find the next bigger number

        return data[str(small)], data[str(big)]

    def getSpeed(self, temp, biggest, smallest):
        mult = (temp%10)/10
        speed = int((mult*abs(biggest-smallest))+smallest)
        print(mult, speed)
        if speed > 100:
            speed = 100
        elif speed < 0:
            speed = 0
        elif speed > biggest:
            speed = biggest
        elif speed < smallest:
            speed = smallest
        return speed

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
        print(temp, self.normalizeTemp(temp))
        return temp, self.normalizeTemp(temp)

    def pollGPU(self):
        self.lastProbe = "GPU"
        self.gpuTemp = self.hardwareControl.get_gpu_temp()
        return self.gpuTemp

    def pollCPU(self):
        self.lastProbe = "CPU"
        self.cpuTemp = self.hardwareControl.get_cpu_temp()
        return self.cpuTemp

    def normalizeTemp(self, temp):
        if temp == None:
            return -256
        elif temp < 20:
            return 20
        elif temp > 94:
            return 90
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







