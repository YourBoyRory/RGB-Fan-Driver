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
if [[ "$ramCLRMode" == "rainbow-synced" ]]; then
    python /opt/rgbfandriver/rainbow-sync.py &
else
    echo "[INFO] Spinning off RAM RGB workers..."
    for i in {0..3}; do
        openrgb -d $i -m $ramCLRMode -c ${ramPrimaryCLR:1} -b $ramLEDBrightness --noautoconnect &
    done
fi

# Fan
notifyID=0
lastPowerState=0

getSpeed() {
    case $1 in
        20)
            echo $caseSpeed20;;
        30)
            echo $caseSpeed30;;
        40)
            echo $caseSpeed40;;
        50)
            echo $caseSpeed50;;
        60)
            echo $caseSpeed60;;
        70)
            echo $caseSpeed70;;
        80)
            echo $caseSpeed80;;
        90)
            echo $caseSpeed90;;
    esac
}

getIcon() {
    case $1 in
        20)
            echo "power-profile-power-saver-symbolic";;
        30)
            echo "power-profile-power-saver-symbolic";;
        40)
            echo "power-profile-power-saver-symbolic";;
        50)
            echo "power-profile-balanced-symbolic";;
        60)
            echo "power-profile-balanced-symbolic";;
        70)
            echo "power-profile-performance-symbolic";;
        80)
            echo "power-profile-performance-symbolic";;
        90)
            echo "power-profile-performance-symbolic";;
    esac
}

normalizeTemp() {
    if [[ $currTemp -lt 30 ]]; then
        echo "20"
    elif [[ $currTemp -lt 40 ]]; then
        echo "30"
    elif [[ $currTemp -lt 50 ]]; then
        echo "40"
    elif [[ $currTemp -lt 60 ]]; then
        echo "50"
    elif [[ $currTemp -lt 70 ]]; then
        echo "60"
    elif [[ $currTemp -lt 80 ]]; then
        echo "70"
    elif [[ $currTemp -lt 90 ]]; then
        echo "80"
    elif [[ $currTemp -gt 89 ]]; then
        echo "90"
    else
        echo "nan"
    fi
}

setTemp() {
    if [[ $lastPowerState -ne $1 ]]; then
        liquidctl --match "NZXT Smart Device" set sync speed $(getSpeed $1)
        echo "[INFO] $caseTempProbe Temp $1c: Fan Speed $(getSpeed $1)"
        lastPowerState=$1
        if [[ $caseSpeedNotify == "TRUE" ]]; then
            notifyID=$(notify-send -p --icon="$(getIcon $1)" --replace-id=$notifyID --urgency=low  --app-name= "$caseTempProbe Temp $1c" "Fan Speed $(getSpeed $1)")
        fi
    fi
}

while true; do
    currTemp=$(normalizeTemp $(getCaseTemp))

    if [[ "$currTemp" == "nan" ]]; then
        if [[ "$lastPowerState" != "nan" ]]; then
            liquidctl --match "NZXT Smart Device" set sync speed $caseSpeed90
            echo "[WARN] Cannot communicate with nvidia driver, defaulting to high power state"
            notify-send -p --urgency=critical  --app-name= "Fan controller defaulting to highest fan speed" "Script cannot communicate with $caseTempProbe driver"
            lastPowerState="nan"
        fi
    else
        setTemp $currTemp
    fi
    sleep 5
done

