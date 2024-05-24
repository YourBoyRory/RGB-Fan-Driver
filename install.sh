#!/bin/bash

#!/bin/bash

sudo mkdir /opt/rgbfandriver
sudo cp ./rainbow-sync.py /opt/rgbfandriver/
sudo cp ./darken-ram.py /opt/rgbfandriver/
sudo cp ./ramrgb.sh /lib/systemd/system-sleep/
sudo chmod 755  /lib/systemd/system-sleep/ramrgb.sh
sudo cp ./rgbfandriver.sh /usr/local/bin/rgbfandriver
sudo cp ./configGUI.sh /usr/local/bin/rgbfandriver-config
sudo chmod 755 /usr/local/bin/rgbfandriver
sudo chmod 755 /usr/local/bin/rgbfandriver-config
