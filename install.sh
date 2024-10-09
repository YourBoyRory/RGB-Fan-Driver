#!/bin/bash

# install Dependencies
sudo pacman -S --needed liquidctl python-notify2 python-psutil
yay -S --needed python-openrgb-git

# install Ram Sleeper
sudo cp ./rgbsleep /lib/systemd/system-sleep/
sudo chown root:root /lib/systemd/system-sleep/rgbsleep
sudo chmod 555  /lib/systemd/system-sleep/rgbsleep

# Install service
sudo mkdir /opt/FanService
sudo cp ./FanDriverService.py /opt/FanService/FanDriverService
sudo chown root:root /opt/FanService/FanDriverService
sudo chmod 755 /opt/FanService/FanDriverService
sudo cp ./FanDriverHardwareLib.py /opt/FanService/FanDriverHardwareLib.py
sudo cp ./FanDriverConfigLib.py /opt/FanService/FanDriverConfigLib.py
sudo chown root:root /opt/FanService/*.py
sudo chmod 644 /opt/FanService/*.py
