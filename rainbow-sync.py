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

# Wave and Color Settings
color_brightness=80 # 0-255
color_desaturation=0 # 0-255

# Preset Values, Change only if you want to change effect speed
effect_smoothness=int(abs(color_brightness-color_desaturation)/10) # 1 is perfectly smooth, higher is less smooth, brings down CPU usage
effect_slowness=effect_smoothness/color_brightness # calculates the delay between "frames"
wave_frequency=(abs(color_brightness-color_desaturation)/2)/effect_smoothness # changes the waves frequency higher means more colors visible at once

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
    workers = [None] * len(RAM)
    count=0
    for w in workers
        w = Thread(target=setRamColor, args=(count, colors)),
        count=count+1
    for w in workers:
        w.start()
    time.sleep(effect_slowness)
    for w in workers:
        w.join()

def generateColor(lookAhead,color):
    count=(wave_frequency*lookAhead)
    red=color.red
    green=color.green
    blue=color.blue
    while count > -1:
        if green >= color_brightness and blue < color_brightness:
            if red > color_desaturation:
                red=red-effect_smoothness
            else:
                blue=blue+effect_smoothness
        elif blue >= color_brightness and red < color_brightness:
            if green > color_desaturation:
                green=green-effect_smoothness
            else:
                red=red+effect_smoothness
        elif red >= color_brightness and green < color_brightness:
            if blue > color_desaturation:
                blue=blue-effect_smoothness
            else:
                green=green+effect_smoothness
        count=count-1
    return RGBColor(limit(red),limit(green),limit(blue))

def rainbow(colors):
    oldColor=colors[0]
    for led in colors:
        led = generateColor(count,oldColor)
    spawnWorkers(colors)
    return colors


def dark():
    for module in RAM:
        module.clear()

# Starting Values
currentColors = [None] * len(RAM[0].leds)
currentColors[0] = RGBColor(limit(color_brightness),limit(color_desaturation),limit(color_desaturation))

for module in RAM:
    module.set_mode("direct")

print(f"Brightness: \033[33m{color_brightness/255*100:.0f}%\033[0m")
print(f"Saturation: \033[33m{100-(color_desaturation/255*100):.0f}%\033[0m")
print(f"Smoothness: \033[33m{effect_smoothness} Steps ({wave_frequency:.0f}Hz, {effect_slowness*1000:.0f} milliseconds)\033[0m")

while True:
    if os.path.isfile("/tmp/ram_sleep"):
        dark()
    else:
        currentColors = rainbow(currentColors)
        #print(f"\rTest\033[0m ", end='', flush=True)
        print(f"\r\033[31mR:{currentColors[0].red:3d} \033[92mG:{currentColors[0].green:3d} \033[34mB:{currentColors[0].blue:3d} \033[36m(#{currentColors[0].red:02x}{currentColors[0].green:02x}{currentColors[0].blue:02x})\033[0m ", end='', flush=True)

