#!/bin/bash

liquidctl --match "NZXT Smart Device" initialize
sleep 5

# Water Cooler
liquidctl --match "Corsair Hydro H100i" set led color fixed ffffff
liquidctl --match "Corsair Hydro H100i" set pump speed 50
liquidctl --match "Corsair Hydro H100i" set fan speed 30 0 50 100


# Case 
liquidctl --match "NZXT Smart Device" set led color spectrum-wave --speed slowest
liquidctl --match "NZXT Smart Device" set sync speed 20
echo "Low Power state: Fan Speed 20"
lowPower=1

# RAM
for i in {0..3}; do
	openrgb -d $i -m direct -c 000000 --noautoconnect &
	sleep .5
done

# Fan
while true; do

        if [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 70 ]; then
                if [ $lowPower -eq 0 ]; then
                        liquidctl --match "NZXT Smart Device" set sync speed 20
                        echo "Low Power state: Fan Speed 20"
                        lowPower=1
                fi
        else
                if [ $lowPower -eq 1 ]; then
                        liquidctl --match "NZXT Smart Device" set sync speed 100
                        echo "High Power State: Fan Speed 100"
                        lowPower=0
                fi
        fi
        sleep 5
done
