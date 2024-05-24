#!/bin/bash

plug=$RANDOM
caseTmp="/tmp/case_$plug.tmp"
aioTmp="/tmp/aio_$plug.tmp"
ramTmp="/tmp/ram_$plug.tmp"

mkdir ~/.config/rgbFanDriver/ 2> /dev/null
cd ~/.config/rgbFanDriver/
caseCfg="./case.cfg"
caseLedCfg="./caseLED.cfg"
aioCfg="./aio.cfg"
ramCfg="./ram.cfg"
ramLedCfg="./ramLED.cfg"

touch $caseCfg
touch $aioCfg
touch $ramCfg

userName=$(getent passwd "$USER" | cut -d ':' -f 5 | cut -d ',' -f 1)


setCBValue() {
    options="$1"
    if [[ $1 != "" ]] ; then
        selection="$2"
        selectionFixed="^$2"
        output="${options/${selection}/${selectionFixed}}"
        echo
    else
        output=$options
    fi
    echo $output
}

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

writeConfig() {

    # Case Key/Value
    cat $caseTmp | awk '{ print "caseCLRMode="$1 }' > $caseCfg
    cat $caseTmp | awk '{ print "caseCLRSpeed="$2 }' >> $caseCfg
    cat $caseTmp | awk '{ print "casePrimaryCLR="$3 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSecondaryCLR="$4 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseTertiaryCLR="$5 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseQuaternaryCLR="$6 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeedNotify="$7 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseTempProbe="$8 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed20="$9 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed30="$10 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed40="$11 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed50="$12 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed60="$13 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed70="$14 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed80="$15 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed90="$16 }'  >> $caseCfg

    # AIO Key/Value
    cat $aioTmp | awk '{ print "aioCLRMode="$1 }' > $aioCfg
    cat $aioTmp | awk '{ print "aioPrimaryCLR="$2 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSecondaryCLR="$3 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioPumpSpeed="$4 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioTempProbe="$5 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed24="$6 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed36="$7 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed48="$8 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed60="$9 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed72="$10 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed84="$11 }' >> $aioCfg

    # Ram Key/Value
    cat $ramTmp | awk '{ print "disableRamOnSleep="$1 }' > $ramCfg
    cat $ramTmp | awk '{ print "ramCLRMode="$2 }' >> $ramCfg
    cat $ramTmp | awk '{ print "ramLEDBrightness="$3 }' >> $ramCfg
    cat $ramTmp | awk '{ print "ramPrimaryCLR="$4 }' >> $ramCfg
    cat $ramTmp | awk '{ print "ramSecondaryCLR="$5 }' >> $ramCfg

}

readConfig

# Fix Case Var
caseCLRMode=$(setCBValue "fixed!spectrum-wave!alternating!pulse!breathing!candle!starry-night!wings!off" "$caseCLRMode")
caseCLRSpeed=$(setCBValue "slowest!slower!normal!faster!fastest" "$caseCLRSpeed")
caseTempProbe=$(setCBValue "CPU!GPU" "$caseTempProbe")

# Fix AIO Var
aioCLRMode=$(setCBValue "fixed!fading!blinking!blackout" "$aioCLRMode")
aioTempProbe=$(setCBValue "Coolant" "$aioTempProbe")

# Fix Ram Var
ramCLRMode=$(setCBValue "direct!static!rainbow!rainbow-synced!visor!rain!marquee!sequential!rainbow-wave!color-shift!color-pulse!" "$ramCLRMode")

    # Case
    (
        yad --form --separator=" " --plug=$plug --tabnum=1\
        --field="<b>LED Strip Options</b>":LBL ""\
        --field="LED Color Mode":CB $caseCLRMode\ \
        --field="LED Color Speed":CB $caseCLRSpeed\ \
        --field="LED Primary Color":CLR "$casePrimaryCLR"\
        --field="LED Secondary Color":CLR "$caseSecondaryCLR"\
        --field="LED Tertiary Color":CLR "$caseTertiaryCLR"\
        --field="LED Quaternary Color":CLR "$caseQuaternaryCLR"\
        --field="Address LEDs"!"color-management"!"":BTN "bash -c 'cat caseAddrRGB.cfg | \
            yad --form --window-icon=color-management --title=\"Adress LED\" --columns=4 --button=Clear:1 --button=Save:0 --separator=\"\n\" \
            --field=Enable:SW \
            --field=LED_1:CLR --field=LED_2:CLR --field=LED_3:CLR --field=LED_4:CLR \
            --field=LED_5:CLR --field=LED_6:CLR --field=LED_7:CLR --field=LED_8:CLR \
            --field=LED_9:CLR --field=LED_10:CLR --field=\" \":LBL --field=\" \":LBL --field=LED_11:CLR --field=LED_12:CLR \
            --field=LED_13:CLR --field=LED_14:CLR --field=LED_15:CLR --field=LED_16:CLR \
            --field=LED_17:CLR --field=LED_18:CLR --field=LED_19:CLR --field=LED_20:CLR  --field=\" \":LBL --field=\" \":LBL \
            --field=LED_21:CLR --field=LED_22:CLR --field=LED_23:CLR --field=LED_24:CLR \
            --field=LED_25:CLR --field=LED_26:CLR --field=LED_27:CLR --field=LED_28:CLR \
            --field=LED_29:CLR --field=LED_30:CLR --field=\" \":LBL --field=\" \":LBL --field=LED_31:CLR --field=LED_32:CLR \
            --field=LED_33:CLR --field=LED_34:CLR --field=LED_35:CLR --field=LED_36:CLR \
            --field=LED_37:CLR --field=LED_38:CLR --field=LED_39:CLR --field=LED_40:CLR \
            | tee caseAddrRGB.cfg'" \
        --field="<b>Fan Curve</b>":LBL ""\
        --field="Notify on change":SW "$caseSpeedNotify"\
        --field="Tempature Probe":CB $caseTempProbe \
        --field="Speed at 20c":SCL "$caseSpeed20"\
        --field="Speed at 30c":SCL "$caseSpeed30"\
        --field="Speed at 40c":SCL "$caseSpeed40"\
        --field="Speed at 50c":SCL "$caseSpeed50"\
        --field="Speed at 60c":SCL "$caseSpeed60"\
        --field="Speed at 70c":SCL "$caseSpeed70"\
        --field="Speed at 80c":SCL "$caseSpeed80"\
        --field="Speed at 90c":SCL "$caseSpeed90"\
        >$caseTmp
    )&\
    # AIO
    (
        yad --form --separator=" " --plug=$plug --tabnum=2\
        --field="<b>LOGO LED Options</b>":LBL ""\
        --field="LED Color Mode":CB $aioCLRMode \
        --field="LED Primary Color":CLR "$aioPrimaryCLR"\
        --field="LED Secondary Color":CLR "$aioSecondaryCLR"\
        --field="<b>Pump Control</b>":LBL ""\
        --field="Pump Speed":SCL "$aioPumpSpeed"\
        --field="<b>Fan Curve</b>":LBL ""\
        --field="Tempature Probe":CB $aioTempProbe \
        --field="Speed at 24c":SCL "$aioSpeed24"\
        --field="Speed at 36c":SCL "$aioSpeed36"\
        --field="Speed at 48c":SCL "$aioSpeed48"\
        --field="Speed at 60c":SCL "$aioSpeed60"\
        --field="Speed at 72c":SCL "$aioSpeed72"\
        --field="Speed at 84c":SCL "$aioSpeed84"\
        >$aioTmp
    )&\
    # RAM
    (
        yad --form --separator=" " --plug=$plug --tabnum=3\
        --field="<b>LED Options</b>":LBL ""\
        --field="Disable on Sleep"!"Disables RAM LED when computer is sleeping":SW "$disableRamOnSleep"\
        --field="LED Color Mode":CB $ramCLRMode\
        --field="LED Brightness":SCL "$ramLEDBrightness"\
        --field="LED Primary Color":CLR "$ramPrimaryCLR"\
        --field="LED Secondary Color":CLR "$ramSecondaryCLR"\
        --field="Address LEDs"!"color-management"!"":BTN "bash -c 'cat rgbAddrRGB.cfg | \
            yad --form --window-icon=color-management --title=\"Adress LED\" --button=Clear:1 --button=Save:0 --separator=\"\n\" \
            --field=Enable:SW \
            --field=LED_1:CLR \
            --field=LED_2:CLR \
            --field=LED_3:CLR \
            --field=LED_4:CLR \
            --field=LED_5:CLR \
            --field=LED_6:CLR \
            --field=LED_7:CLR \
            --field=LED_8:CLR \
            --field=LED_9:CLR \
            | tee rgbAddrRGB.cfg'" \
        >$ramTmp
    )&\

    #draw UI
    (
        yad --notebook --window-icon=color-management --key=$plug --width=600 --title="$userName: $(hostname) Config"\
        --tab="Case"\
        --tab="AIO"\
        --tab="RAM"\
        --button="Apply"!!"Restarts the services to apply the changes now.":2\
        --button="Save"!!"Saves the config and exits but doesn't restart the services.":0\
        --button="Cancel"!!"Doesn't Save anything and exit.":1\
    )
    exitCode=$?

if [[ $exitCode -eq 0 ]] ; then
    writeConfig
elif [[ $exitCode -eq 2 ]] ; then
    killall -9 rgbfandriver
    kill $(ps aux | grep "rainbow-sync.py" | grep -v 'grep' | awk '{print $2}')
    writeConfig
    (
        rgbfandriver -q
    )&
    (
        rgbfandriver-config
    )&
fi

rm $caseTmp
rm $aioTmp
rm $ramTmp
