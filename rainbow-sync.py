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
    print(f"\r\033[31mR:{limit(red):3d} \033[92mG:{limit(green):3d} \033[34mB:{limit(blue):3d} \033[36m(#{limit(red):02x}{limit(green):02x}{limit(blue):02x})\033[0m ", end='', flush=True)
    time.sleep(.08)
    for w in workers:
        w.join()

def rainbow(red, green, blue):
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
    spawnWorkers(red, green, blue)
    return red,green,blue

def dark():
    spawnWorkers(0, 0, 0)
    time.sleep(1)


print(f"Brightness: \033[33m{brightness/255*100:.0f}%\033[0m")
print(f"Saturation: \033[33m{100-(desaturation/255*100):.0f}%\033[0m")
print(f"Step: \033[33m{step} ({((brightness-desaturation)/step)*3:.0f} total, ~{(((brightness-desaturation)/step)*3)*.6:.0f} seconds)\033[0m")
while True:
    if os.path.isfile("/tmp/ram_sleep"):
        dark()
    else:
        red,green,blue = rainbow(red, green, blue)


