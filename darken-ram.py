import random
import time
import os.path
from threading import Thread
from openrgb import OpenRGBClient
from openrgb.utils import RGBColor, DeviceType

client = OpenRGBClient()
RAM = client.get_devices_by_type(DeviceType.DRAM)

step=4
brightness=50
desaturation=0

for module in RAM:
    module.set_mode("direct")

red=brightness
green=desaturation
blue=desaturation

def limit(value):
    if value > 255:
        return 255
    elif value < 0:
        return 0
    else:
        return value

def setRamColor(dev, red, green, blue):
    RAM[dev].set_color(RGBColor(limit(red), limit(green), limit(blue)))

def spawnWorkers(red, green, blue):
    workers = [
        Thread(target=setRamColor, args=(0, red, green, blue)),
        Thread(target=setRamColor, args=(1, red, green, blue)),
        Thread(target=setRamColor, args=(2, red, green, blue)),
        Thread(target=setRamColor, args=(3, red, green, blue)),
    ]
    for w in workers:
        w.start()
    time.sleep(.08)
    for w in workers:
        w.join()

def dark():
    spawnWorkers(0, 0, 0)
    time.sleep(1)

dark()


