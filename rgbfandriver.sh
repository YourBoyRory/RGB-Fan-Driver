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
    caseSpeedNotify=$(grep -oP '^caseSpeedNotify=\K.*' $caseCfg | head -n1 )
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
    aioSpeed24=$(grep -oP '^aioSpeed24=\K.*' $aioCfg | head -n1 )
    aioSpeed36=$(grep -oP '^aioSpeed36=\K.*' $aioCfg | head -n1 )
    aioSpeed48=$(grep -oP '^aioSpeed48=\K.*' $aioCfg | head -n1 )
    aioSpeed60=$(grep -oP '^aioSpeed60=\K.*' $aioCfg | head -n1 )
    aioSpeed72=$(grep -oP '^aioSpeed72=\K.*' $aioCfg | head -n1 )
    aioSpeed84=$(grep -oP '^aioSpeed84=\K.*' $aioCfg | head -n1 )

    # Ram Var
    disableRamOnSleep=$(grep -oP '^disableRamOnSleep=\K.*' $ramCfg | head -n1 )
    ramCLRMode=$(grep -oP '^ramCLRMode=\K.*' $ramCfg | head -n1 )
    ramPrimaryCLR=$(grep -oP '^ramPrimaryCLR=\K.*' $ramCfg | head -n1 )
    ramSecondaryCLR=$(grep -oP '^ramSecondaryCLR=\K.*' $ramCfg | head -n1 )
    ramLEDBrightness=$(grep -oP '^ramLEDBrightness=\K.*' $ramCfg | head -n1 )
}

getCaseTemp() {
    if [[ "$caseTempProbe" == "GPU" ]] ;then
        echo $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    else
        echo $(($(cat /sys/class/thermal/thermal_zone2/temp)/1000))
    fi
}

readConfig

if [[ $1 == "-h" ]]; then
    echo "  "
    echo "-q    Starts the program without Initializing hardware, use this when restarting the script."
    echo "  "
fi

if [[ $1 != "-q" ]]; then
    echo "[INFO] Initializing hardware..."
    liquidctl --match "NZXT Smart Device" initialize
    sleep 5
fi

# Water Cooler
liquidctl --match "Corsair Hydro H100i" set led color $aioCLRMode "$aioPrimaryCLR" "$caseSecondaryCLR"
liquidctl --match "Corsair Hydro H100i" set pump speed $aioPumpSpeed
if liquidctl --match "Corsair Hydro H100i" set fan speed 24 $aioSpeed24 36 $aioSpeed36 48 $aioSpeed48 60 $aioSpeed60 72 $aioSpeed72 84 $aioSpeed84 ; then
    echo " "
    echo "=============================="  
    echo "Temp Probe Set To: $aioTempProbe" 
    echo "=============================="
    echo "Set AIO fan speed table"
    echo "24c | $aioSpeed24% RPM"
    echo "36c | $aioSpeed36% RPM"
    echo "48c | $aioSpeed48% RPM"
    echo "60c | $aioSpeed60% RPM"
    echo "72c | $aioSpeed72% RPM"
    echo "84c | $aioSpeed84% RPM"
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
	openrgb -d $i -m $ramCLRMode -c ${ramPrimaryCLR:1} -b $ramLEDBrightness --noautoconnect &
done

# Fan
notifyID=0
lastPowerState=0
icon20="power-profile-power-saver-symbolic"
icon30="power-profile-power-saver-symbolic"
icon40="power-profile-power-saver-symbolic"
icon50="power-profile-balanced-symbolic"
icon60="power-profile-balanced-symbolic"
icon70="power-profile-performance-symbolic"
icon80="power-profile-performance-symbolic"
icon90="power-profile-performance-symbolic"
while true; do
    currTemp=$(getCaseTemp)

    if [[ $currTemp -lt 30 ]]; then
        if [[ $lastPowerState -ne 20 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed20
            echo "[INFO] $caseTempProbe Temp 20c: Fan Speed $caseSpeed20"
            lastPowerState=20
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon20" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 20c" "Fan Speed $caseSpeed20")
            fi
        fi
    elif [[ $currTemp -lt 40 ]]; then
        if [[ $lastPowerState -ne 30 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed30
            echo "[INFO] $caseTempProbe Temp 30c: Fan Speed $caseSpeed30"
            lastPowerState=30
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon30" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 30c" "Fan Speed $caseSpeed30")
            fi
        fi
    elif [[ $currTemp -lt 50 ]]; then
        if [[ $lastPowerState -ne 40 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed40
            echo "[INFO] $caseTempProbe Temp 40c: Fan Speed $caseSpeed40"
            lastPowerState=40
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon40" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 40c" "Fan Speed $caseSpeed40")
            fi
        fi
    elif [[ $currTemp -lt 60 ]]; then
        if [[ $lastPowerState -ne 50 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed50
            echo "[INFO] $caseTempProbe Temp 50c: Fan Speed $caseSpeed50"
            lastPowerState=50
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon50" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 50c" "Fan Speed $caseSpeed50")
            fi
        fi
    elif [[ $currTemp -lt 70 ]]; then
        if [[ $lastPowerState -ne 60 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed60
            echo "[INFO] $caseTempProbe Temp 60c: Fan Speed $caseSpeed60"
            lastPowerState=60
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon60" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 60c" "Fan Speed $caseSpeed60")
            fi
        fi
    elif [[ $currTemp -lt 80 ]]; then
        if [[ $lastPowerState -ne 70 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed70
            echo "[INFO] $caseTempProbe Temp 70c: Fan Speed $caseSpeed70"
            lastPowerState=70
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon70" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 70c" "Fan Speed $caseSpeed70")
            fi
        fi
    elif [[ $currTemp -lt 90 ]]; then
        if [[ $lastPowerState -ne 80 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed80
            echo "[INFO] $caseTempProbe Temp 80c: Fan Speed $caseSpeed80"
            lastPowerState=80
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon80" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 80c" "Fan Speed $caseSpeed80")
            fi
        fi
    elif [[ $currTemp -gt 89 ]]; then
        if [[ $lastPowerState -ne 90 ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed90
            echo "[INFO] $caseTempProbe Temp 90c: Fan Speed 100"
            lastPowerState=90
            if [[ $caseSpeedNotify == "TRUE" ]]; then
                notifyID=$(notify-send -p --icon="$icon90" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp 90c" "Fan Speed $caseSpeed90")
            fi
        fi
    else
        if [[ "$lastPowerState" != "nan" ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed90
            echo "[WARN] Cannot communicate with nvidia driver, defaulting to high power state"
            notify-send -p --urgency=critical  --app-name= "Fan controller defaulting to highest fan speed" "Script cannot communicate with $caseTempProbe driver"
            lastPowerState="nan"
        fi
    fi
    sleep 5
done

