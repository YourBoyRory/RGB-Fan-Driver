#!/bin/bash

mkdir ~/.config/rgbFanDriver/ 2> /dev/null
cd ~/.config/rgbFanDriver/
aioCfg="./aio.cfg"

readConfig() {

    # AIO Var
    aioCLRMode=$(grep -oP '^aioCLRMode=\K.*' $aioCfg | head -n1 )
    aioPrimaryCLR=$(grep -oP '^aioPrimaryCLR=\K.*' $aioCfg | head -n1 )
    aioSecondaryCLR=$(grep -oP '^aioSecondaryCLR=\K.*' $aioCfg | head -n1 )
    aioPumpSpeed=$(grep -oP '^aioPumpSpeed=\K.*' $aioCfg | head -n1 )
    aioTempProbe=$(grep -oP '^aioTempProbe=\K.*' $aioCfg | head -n1 )
    aioSpeed24=$(grep -oP '^aioSpeed24=\K.*' $aioCfg | head -n1 )
    aioSpeed36=$(grep -oP '^aioSpeed36=\K.*' $aioCfg | head -n1 )
    aioSpeed48=$(grep -oP '^aioSpeed48=\K.*' $aioCfg | head -n1 )
    aioSpeed60=$(grep -oP '^aioSpeed60=\K.*' $aioCfg | head -n1 )
    aioSpeed72=$(grep -oP '^aioSpeed72=\K.*' $aioCfg | head -n1 )
    aioSpeed84=$(grep -oP '^aioSpeed84=\K.*' $aioCfg | head -n1 )

}

readConfig

# Jet Engine
sudo  nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=100"
liquidctl --match "NZXT Smart Device" set sync speed 100
liquidctl --match "Corsair Hydro H100i" set fan speed 100

read -n 1 -s -r -p "Press any key to stop..."

# Reset
sudo  nvidia-settings -a "[gpu:0]/GPUFanControlState=0"
liquidctl --match "NZXT Smart Device" set sync speed 20
liquidctl --match "Corsair Hydro H100i" set fan speed 24 $aioSpeed24 36 $aioSpeed36 48 $aioSpeed48 60 $aioSpeed60 72 $aioSpeed72 84 $aioSpeed84
