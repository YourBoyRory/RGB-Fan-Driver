import json
import os
from pathlib import Path
import traceback

class ConfigLib:

    config_path = os.path.join(Path.home(), '.fan_config.json')
    config = {
        'SmartHub': {
            'Light Strips': {
                'ColorMode': 'spectrum-wave',
                'Colors': [[0, 0, 0]],
                'Speed': 'slowest'
            },
            'Fan': {
                'Probe': 'BOTH',
                'CPU Curve': {
                    '20': 20,
                    '30': 20,
                    '40': 20,
                    '50': 20,
                    '60': 20,
                    '70': 100,
                    '80': 100,
                    '90': 100
                },
                'GPU Curve': {
                    '20': 20,
                    '30': 20,
                    '40': 20,
                    '50': 20,
                    '60': 100,
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

    def __init__(self):
        self.load_config()

    def load_config(self):
        try:
            with open(self.config_path) as f:
                self.config = json.load(f)
        except:
            print("Could not load existing config")
            self.save_config()

    def save_config(self):
        try:
            with open(self.config_path, 'w') as f:
                json.dump(self.config, f, indent=2)
        except:
            print("Could not save config The file is not Writable.")
            print(traceback.format_exc())

    def verify_files(self):
        modLoaderCore = os.path.join(self.config["bepinex_directory"], "core")
        modLoaderWinhtpp = os.path.join(self.config["game_directory"], "winhttp.dll")
        gameDirectory = os.path.join(self.config["game_directory"], "Lethal Company.exe")
        self.config["gameFound"] = False
        self.config["modloaderFound"] = False
        if os.path.isfile(gameDirectory):
            print("[INFO] Game is found.")
            self.config["gameFound"] = True
        if os.path.isdir(modLoaderCore) and os.path.isfile(modLoaderWinhtpp):
            print("[INFO] BepInEx is found.")
            self.config["modloaderFound"] = True
        return self.config["gameFound"], self.config["modloaderFound"]
