#!/bin/bash

plug=$RANDOM
caseTmp="/tmp/case_$plug.tmp"
aioTmp="/tmp/aio_$plug.tmp"
ramTmp="/tmp/ram_$plug.tmp"

mkdir ~/.config/rgbFanDriver/ 2> /dev/null
cd ~/.config/rgbFanDriver/
caseCfg="./case.cfg"
aioCfg="./aio.cfg"
ramCfg="./ram.cfg"

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

writeConfig() {
    
    # Case Key/Value
    cat $caseTmp | awk '{ print "caseCLRMode="$1 }' > $caseCfg
    cat $caseTmp | awk '{ print "caseCLRSpeed="$2 }' >> $caseCfg
    cat $caseTmp | awk '{ print "casePrimaryCLR="$3 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSecondaryCLR="$4 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseTertiaryCLR="$5 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseQuaternaryCLR="$6 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseTempProbe="$7 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed20="$8 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed30="$9 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed40="$10 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed50="$11 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed60="$12 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed70="$13 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed80="$14 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed90="$15 }'  >> $caseCfg
    
    # AIO Key/Value
    cat $aioTmp | awk '{ print "aioCLRMode="$1 }' > $aioCfg
    cat $aioTmp | awk '{ print "aioPrimaryCLR="$2 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSecondaryCLR="$3 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioPumpSpeed="$4 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioTempProbe="$5 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed25="$6 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed35="$7 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed50="$8 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed65="$9 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed75="$10 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed90="$11 }' >> $aioCfg
    
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
caseTempProbe=$(setCBValue "cpu!gpu" "$caseTempProbe")

# Fix AIO Var
aioCLRMode=$(setCBValue "fixed!fading!blinking!blackout" "$aioCLRMode")
aioTempProbe=$(setCBValue "cpu!coolant" "$aioTempProbe")

# Fix Ram Var
ramCLRMode=$(setCBValue "direct!rainbow!visor!rain!marquee!sequential!rainbow-wave!color-shift!color-pulse!" "$ramCLRMode")
    
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
        --field="Address LEDs":BTN "" \
        --field="<b>Fan Curve</b>":LBL ""\
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
        --field="Speed at 25c":SCL "$aioSpeed25"\
        --field="Speed at 35c":SCL "$aioSpeed35"\
        --field="Speed at 50c":SCL "$aioSpeed50"\
        --field="Speed at 65c":SCL "$aioSpeed65"\
        --field="Speed at 75c":SCL "$aioSpeed75"\
        --field="Speed at 90c":SCL "$aioSpeed90"\
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
        --field="Address LEDs":BTN "" \
        >$ramTmp
    )&\
    
    #draw UI
    (
        yad --notebook --key=$plug --width=500 --title="$userName: $(hostname) Config"\
        --tab="Case"\
        --tab="AIO"\
        --tab="RAM"\
        --button="Save":0\
        --button="Cancel":1\
    )
    
if [[ $? -eq 0 ]] ; then
    writeConfig
fi

rm $caseTmp
rm $aioTmp
rm $ramTmp
