import sys
import time
import subprocess
from FanDriverHardwareLib import HardwareLib
from FanDriverConfigLib import ConfigLib
from liquidctl.driver.smart_device import SmartDevice

class HardwareStatus():

    def __init__(self, probe):
        self.hardwareControl = HardwareLib()
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

class AIOController():

    def __init__(self, config):
        self.waterCooler = Hydro690Lc.find_supported_devices()[0]
        self.waterCooler.connect()
        self.waterCooler.initialize()
        mode = config['AIO']['Light']['ColorMode']
        color = config['AIO']['Light']['Colors']
        self.waterCooler.set_color("led", mode, color)

class CaseFanControler():

    def __init__(self, curve, config, currTemp=0):
        self.currentSpeed = 0
        self.smartHub = SmartDevice.find_supported_devices()[0]
        self.smartHub.connect()
        self.smartHub.initialize()

        mode = config['SmartHub']['Light Strips']['ColorMode']
        colors = config['SmartHub']['Light Strips']['Colors']
        speed = config['SmartHub']['Light Strips']['Speed']
        self.smartHub.set_color("led", mode, colors, speed)

        speed = self.getSpeed(currTemp, curve)
        self.setSpeed(speed)

    def find_neighbors(self, temp, curve):
        int_keys = [int(key) for key in curve.keys()]
        sorted_keys = sorted(int_keys)  # Sort dictionary keys
        small, big = next(iter(int_keys)), next(reversed(int_keys))

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
        if not temp:
            return None
        smallest, biggest, mult = self.find_neighbors(temp, curve)
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
            print(f"    Setting fan to {speed}%")
            self.currentSpeed = speed

def sendNotification(title, message, switches=[]):
    return subprocess.run(['notify-send'] + switches + ['-a', 'FanDriver', f"{title}", f"{message}"], capture_output=True)


if __name__ == "__main__":

    configLib = ConfigLib()
    hardware = None
    waterCooler = None
    case = None

    # Init Water Cooler
    try:
        waterCooler = AIOController(configLib.config)
    except Exception as e:
        print(f"\n\033[91mWater Cooler Driver failed to init\033[0m:\n    {e}\n")
        sendNotification("Water Cooler Driver failed to init", e, ['-e'])

    try:
        # Init Hardware Prober
        prober = configLib.config['SmartHub']['Fan']['Probe']
        hardware = HardwareStatus(prober)
        temp, probe = hardware.getTemp()
        print(f"\n{probe} @ {temp}C")
        # Init Case Controller
        curve = configLib.config['SmartHub']['Fan'][f'{probe} Curve']
        case = CaseFanControler(curve, configLib.config, temp)
    except Exception as e:
        print(f"\n\033[91mCase Driver failed to init\033[0m:\n    {e}\n")
        sendNotification("Case Driver failed to init", e, ['-e'])

    if case:
        lastTemp = temp
        while True:
            time.sleep(5)
            try:
                if temp != lastTemp:
                    print(f"\n{probe} @ {temp}C")
                    curve = configLib.config['SmartHub']['Fan'][f'{probe} Curve']
                    speed = case.getSpeed(temp, curve)
                    case.setSpeed(speed)
                    lastTemp = temp
                temp, probe = hardware.getTemp()
            except Exception as e:
                print(f"\n\033[91mComunication with the Hardware Driver has failed!\nAttempting to set fans to 100% and re-establish connection. Please Reboot.\033[0m\n    {e}\n")
                case.setSpeed(100)
                result = sendNotification("Comunication with the Hardware Driver has failed", "Attempting to set fans to 100%. Please Reboot.", ['-u', 'critical', '--action=Retry', '--action=Exit'])
                if result.stdout == b'1\n' or  result.stdout == b'':
                    raise Exception(e)

