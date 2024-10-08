import psutil
import subprocess
import json

class HardwareTemp:

    def __init__(self):
        if self.get_nvidia_gpu_temp():
            self.gpuModel = "Nvidia"
        elif self.get_amd_gpu_temp():
            self.gpuModel = "AMD"
        elif self.get_intel_gpu_temp():
            self.gpuModel = "Intel"
        else:
            self.gpuModel = None

    def get_nvidia_gpu_temp(self):
        try:
            result = subprocess.run(['nvidia-smi', '--query-gpu=temperature.gpu', '--format=csv,noheader,nounits'],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            temp = result.stdout.decode('utf-8').strip()
            return int(temp)
        except:
            return None

    def get_amd_gpu_temp(self):
        try:
            result = subprocess.run(['rocm-smi', '--showtemp'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            output = result.stdout.decode('utf-8')
            # Parse the output to find the temperature
            for line in output.splitlines():
                if "Temperature" in line:
                    # Example output line: "Temperature: 45 C"
                    temp = int(line.split(":")[1].strip().split(" ")[0])
                    return temp
        except:
            return None

    def get_intel_gpu_temp(self):
        try:
            result = subprocess.run(['intel_gpu_top', '-l', '1'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
            output = result.stdout.decode('utf-8')
            # Parse the output for temperature line
            for line in output.splitlines():
                if "temperature" in line:
                    # Example: temperature = 45 C
                    temp = int(line.split(":")[1].strip().split(" ")[0])
                    return temp
        except:
            return None

    def get_gpu_temp(self):
        match self.gpuModel:
            case "Nvidia":
                return self.get_nvidia_gpu_temp()
            case "AMD":
                return self.get_amd_gpu_temp()
            case "Intel":
                return self.get_intel_gpu_temp()
            case _:
                return None

    def get_cpu_usage(self):
        try:
            return int(psutil.cpu_percent(interval=1))
        except:
            return None

    def get_cpu_temp(self):
        try:
            temperatures = psutil.sensors_temperatures()
            return int(temperatures['coretemp'][0][1])
        except:
            return None
