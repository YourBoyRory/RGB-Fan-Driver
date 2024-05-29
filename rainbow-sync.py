import random
import time
import os.path
import sys
from threading import Thread
from openrgb import OpenRGBClient
from openrgb.utils import RGBColor, DeviceType

clients = OpenRGBClient()
RAM = clients.get_devices_by_type(DeviceType.DRAM)
AIO = clients.get_devices_by_type(DeviceType.COOLER)

for module in RAM:
    module.set_mode("direct")

step=8
speed=.1
jumpStep=4
brightness=80
desaturation=0

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

def setRamColor(dev, dispColors):
    RAM[dev].colors = dispColors
    RAM[dev].show(True);

def setAIOColor(dev, dispColors):
    AIO[dev].set_color(dispColors[4], True)

def spawnWorkers(colors):
    workers = [
        Thread(target=setAIOColor, args=(0, colors)),
        Thread(target=setRamColor, args=(0, colors)),
        Thread(target=setRamColor, args=(1, colors)),
        Thread(target=setRamColor, args=(2, colors)),
        Thread(target=setRamColor, args=(3, colors)),
    ]
    for w in workers:
        w.start()
    time.sleep(speed)
    for w in workers:
        w.join()

def generateColor(lookAhead, red, green, blue):
    count=(jumpStep*lookAhead)
    while count > -1:
        if green >= brightness and blue < brightness:
            if red > desaturation:
                red=red-step
            else:
                blue=blue+step
        elif blue >= brightness and red < brightness:
            if green > desaturation:
                green=green-step
            else:
                red=red+step
        elif red >= brightness and green < brightness:
            if blue > desaturation:
                blue=blue-step
            else:
                green=green+step
        count=count-1
    #print("color", red,green,blue)
    return red,green,blue,RGBColor(limit(red),limit(green),limit(blue))

def rainbow(red, green, blue):
    colors = [0] * 10
    newRed,newGreen,newBlue,colors[0] = generateColor(0,red,green,blue)
    count = 1
    while count < 10:
        redDmp,greenDmp,bluedmp,colors[count] = generateColor(count,red,green,blue)
        count=count+1
    spawnWorkers(colors)
    return newRed,newGreen,newBlue


def dark():
    for module in RAM:
        module.clear()

print(f"Brightness: \033[33m{brightness/255*100:.0f}%\033[0m")
print(f"Saturation: \033[33m{100-(desaturation/255*100):.0f}%\033[0m")
print(f"Step: \033[33m{step} ({((brightness-desaturation)/step)*3:.0f} total, ~{(((brightness-desaturation)/step)*3)*.6:.0f} seconds)\033[0m")
while True:
    if os.path.isfile("/tmp/ram_sleep"):
        dark()
    else:
        red,green,blue = rainbow(red,green,blue)
        print(f"\r\033[31mR:{limit(red):3d} \033[92mG:{limit(green):3d} \033[34mB:{limit(blue):3d} \033[36m(#{limit(red):02x}{limit(green):02x}{limit(blue):02x})\033[0m ", end='', flush=True)

