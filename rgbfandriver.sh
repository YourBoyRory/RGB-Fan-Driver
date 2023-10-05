#!/bin/bash

mkdir ~/.config/rgbFanDriver/ 2> /dev/null
cd ~/.config/rgbFanDriver/
caseCfg="./case.cfg"
aioCfg="./aio.cfg"
ramCfg="./ram.cfg"

readConfig() {
    
    # Case Var
    caseCLRMode=$(grep -oP '^caseCLRMode=\K.*' $caseCfg | head -n1 )
    caseCLRSpeed=$(grep -oP '^caseCLRSpeed=\K.*' $caseCfg | head -n1 )
    casePrimaryCLR=$(grep -oP '^casePrimaryCLR=\K.*' $caseCfg | head -n1 )
    caseSecondaryCLR=$(grep -oP '^caseSecondaryCLR=\K.*' $caseCfg | head -n1 )
    caseTertiaryCLR=$(grep -oP '^caseTertiaryCLR=\K.*' $caseCfg | head -n1 )
    caseQuaternaryCLR=$(grep -oP '^caseQuaternaryCLR=\K.*' $caseCfg | head -n1 )
    caseTempProbe=$(grep -oP '^caseTempProbe=\K.*' $caseCfg | head -n1 )
    caseSpeed20=$(grep -oP '^caseSpeed20=\K.*' $caseCfg | head -n1 )
    caseSpeed30=$(grep -oP '^caseSpeed30=\K.*' $caseCfg | head -n1 )
    caseSpeed40=$(grep -oP '^caseSpeed40=\K.*' $caseCfg | head -n1 )
    caseSpeed50=$(grep -oP '^caseSpeed50=\K.*' $caseCfg | head -n1 )
    caseSpeed60=$(grep -oP '^caseSpeed60=\K.*' $caseCfg | head -n1 )
    caseSpeed70=$(grep -oP '^caseSpeed70=\K.*' $caseCfg | head -n1 )
    caseSpeed80=$(grep -oP '^caseSpeed80=\K.*' $caseCfg | head -n1 )
    caseSpeed90=$(grep -oP '^caseSpeed90=\K.*' $caseCfg | head -n1 )
    
    # AIO Var
    aioCLRMode=$(grep -oP '^aioCLRMode=\K.*' $aioCfg | head -n1 )
    aioPrimaryCLR=$(grep -oP '^aioPrimaryCLR=\K.*' $aioCfg | head -n1 )
    aioSecondaryCLR=$(grep -oP '^aioSecondaryCLR=\K.*' $aioCfg | head -n1 )
    aioPumpSpeed=$(grep -oP '^aioPumpSpeed=\K.*' $aioCfg | head -n1 )
    aioTempProbe=$(grep -oP '^aioTempProbe=\K.*' $aioCfg | head -n1 )
    aioSpeed25=$(grep -oP '^aioSpeed25=\K.*' $aioCfg | head -n1 )
    aioSpeed35=$(grep -oP '^aioSpeed35=\K.*' $aioCfg | head -n1 )
    aioSpeed50=$(grep -oP '^aioSpeed50=\K.*' $aioCfg | head -n1 )
    aioSpeed65=$(grep -oP '^aioSpeed65=\K.*' $aioCfg | head -n1 )
    aioSpeed75=$(grep -oP '^aioSpeed75=\K.*' $aioCfg | head -n1 )
    aioSpeed90=$(grep -oP '^aioSpeed90=\K.*' $aioCfg | head -n1 )

    # Ram Var
    disableRamOnSleep=$(grep -oP '^disableRamOnSleep=\K.*' $ramCfg | head -n1 )
    ramCLRMode=$(grep -oP '^ramCLRMode=\K.*' $ramCfg | head -n1 )
    ramPrimaryCLR=$(grep -oP '^ramPrimaryCLR=\K.*' $ramCfg | head -n1 )
    ramSecondaryCLR=$(grep -oP '^ramSecondaryCLR=\K.*' $ramCfg | head -n1 )
    ramLEDBrightness=$(grep -oP '^ramLEDBrightness=\K.*' $ramCfg | head -n1 )

}

readConfig

if [[ $1 == "-n" ]]; then
    notify="true"
else
    notify="false"
fi

if [[ $1 == "-h" ]]; then
    echo "-n    makes a notification happen when fan changes power state"
fi

echo "[INFO] Initializing hardware..."
liquidctl --match "NZXT Smart Device" initialize
sleep 5

# Water Cooler
liquidctl --match "Corsair Hydro H100i" set led color $aioCLRMode "$aioPrimaryCLR" "$caseSecondaryCLR"
liquidctl --match "Corsair Hydro H100i" set pump speed $aioPumpSpeed
if liquidctl --match "Corsair Hydro H100i" set fan speed 25 $aioSpeed25 35 $aioSpeed35 50 $aioSpeed50 65 $aioSpeed65 75 $aioSpeed75 90 $aioSpeed90 ; then
    echo " "
    echo "=============================="  
    echo "Temp Probe Set To: $aioTempProbe" 
    echo "=============================="
    echo "Set AIO fan speed table"
    echo "25c | $aioSpeed25% RPM"
    echo "35c | $aioSpeed35% RPM"
    echo "50c | $aioSpeed50% RPM"
    echo "65c | $aioSpeed65% RPM"
    echo "75c | $aioSpeed75% RPM"
    echo "90c | $aioSpeed90% RPM"
    echo "=============================="
    echo "Pump Speed | $aioPumpSpeed% RPM"
    echo "=============================="
    echo " "
else
    echo "[WARN] Cannot communicate with AIO. Fan curve not set! This could be dangerous!"
    notify-send --urgency=critical  --app-name= "Script cannot communicate with AIO" "unexpected OS error: USBError(16, 'Resource busy')"
fi

# Case 
liquidctl --match "NZXT Smart Device" set led color $caseCLRMode "$casePrimaryCLR" "$caseSecondaryCLR" "$caseTertiaryCLR" "$caseQuaternaryCLR" --speed $caseCLRSpeed
lastPowerState=0

    echo " "
    echo "=============================="  
    echo "Temp Probe Set To: $caseTempProbe" 
    echo "=============================="
    echo "Set Case fan speed table"
    echo "20c | $caseSpeed20% RPM"
    echo "30c | $caseSpeed30% RPM"
    echo "40c | $caseSpeed40% RPM"
    echo "50c | $caseSpeed50% RPM"
    echo "60c | $caseSpeed60% RPM"
    echo "70c | $caseSpeed70% RPM"
    echo "80c | $caseSpeed80% RPM"
    echo "90c | $caseSpeed90% RPM"
    echo "=============================="
    echo " "

# RAM
echo "[INFO] Spinning off RAM RGB workers..."
for i in {0..3}; do
	openrgb -d $i -m $ramCLRMode -c ${ramPrimaryCLR:1} -c ${ramSecondaryCLR:1} -b $ramLEDBrightness --noautoconnect &
done

# Fan
if [ $notify = "true" ] ; then
    notifyID=$(notify-send -p --urgency=low  --app-name= "Fan controller Low Power" "Fan Speed 20")
fi

while true; do
    if [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 30 ]; then
        if [ $lastPowerState -ne 20 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed20
            echo "[INFO] GPU Temp 20c: Fan Speed $caseSpeed20"
            lastPowerState=20
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 20c" "Fan Speed $caseSpeed20")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 40 ]; then
        if [ $lastPowerState -ne 30 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed30
            echo "[INFO] GPU Temp 30c: Fan Speed $caseSpeed30"
            lastPowerState=30
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 30c" "Fan Speed $caseSpeed30")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 50 ]; then
        if [ $lastPowerState -ne 40 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed40
            echo "[INFO] GPU Temp 40c: Fan Speed $caseSpeed40"
            lastPowerState=40
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 40c" "Fan Speed $caseSpeed40")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 60 ]; then
        if [ $lastPowerState -ne 50 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed50
            echo "[INFO] GPU Temp 50c: Fan Speed $caseSpeed50"
            lastPowerState=50
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 50c" "Fan Speed $caseSpeed50")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 70 ]; then
        if [ $lastPowerState -ne 60 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed60
            echo "[INFO] GPU Temp 60c: Fan Speed $caseSpeed60"
            lastPowerState=60
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 60c" "Fan Speed $caseSpeed60")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 80 ]; then
        if [ $lastPowerState -ne 70 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed70
            echo "[INFO] GPU Temp 70c: Fan Speed $caseSpeed70"
            lastPowerState=70
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 70c" "Fan Speed $caseSpeed70")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -lt 90 ]; then
        if [ $lastPowerState -ne 80 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed80
            echo "[INFO] GPU Temp 80c: Fan Speed $caseSpeed80"
            lastPowerState=80
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 80c" "Fan Speed $caseSpeed80")
            fi
        fi
    elif [ $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader) -gt 89 ]; then
        if [ $lastPowerState -ne 90 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed90
            echo "[INFO] GPU High Power state: Fan Speed 100"
            lastPowerState=90
            if [ $notify = "true" ]; then
                notifyID=$(notify-send -p --replace-id=$notifyID --urgency=low  --app-name= "GPU Temp 90c" "Fan Speed $caseSpeed90")
            fi
        fi
    else
        if [ $lastPowerState -ne 90 ]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed90
            echo "[WARN] Cannot communicate with nvidia driver, defaulting to high power state"
            notify-send -p --urgency=critical  --app-name= "Fan controller defaulting to highest fan speed" "Script cannot communicate with nvidia driver"
            lastPowerState=90
        fi
    fi
    sleep 5
done

