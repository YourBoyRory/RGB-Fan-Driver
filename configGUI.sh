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
    casePrimaryCLR=$(grep -oP '^casePrimaryCLR=\K.*' $caseCfg | head -n1 )
    caseSecondaryCLR=$(grep -oP '^caseSecondaryCLR=\K.*' $caseCfg | head -n1 )
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
    aioCLR=$(grep -oP '^aioCLR=\K.*' $aioCfg | head -n1 )
    aioPumpSpeed=$(grep -oP '^aioPumpSpeed=\K.*' $aioCfg | head -n1 )
    aioTempProbe=$(grep -oP '^aioTempProbe=\K.*' $aioCfg | head -n1 )
    aioSpeed20=$(grep -oP '^aioSpeed20=\K.*' $aioCfg | head -n1 )
    aioSpeed30=$(grep -oP '^aioSpeed30=\K.*' $aioCfg | head -n1 )
    aioSpeed40=$(grep -oP '^aioSpeed40=\K.*' $aioCfg | head -n1 )
    aioSpeed50=$(grep -oP '^aioSpeed50=\K.*' $aioCfg | head -n1 )
    aioSpeed60=$(grep -oP '^aioSpeed60=\K.*' $aioCfg | head -n1 )
    aioSpeed70=$(grep -oP '^aioSpeed70=\K.*' $aioCfg | head -n1 )
    aioSpeed80=$(grep -oP '^aioSpeed80=\K.*' $aioCfg | head -n1 )
    aioSpeed90=$(grep -oP '^aioSpeed90=\K.*' $aioCfg | head -n1 )

    # Ram Var
    disableRamOnSleep=$(grep -oP '^disableRamOnSleep=\K.*' $ramCfg | head -n1 )
    ramCLRMode=$(grep -oP '^caseCLRMode=\K.*' $ramCfg | head -n1 )
    ramPrimaryCLR=$(grep -oP '^ramPrimaryCLR=\K.*' $ramCfg | head -n1 )
    ramSecondaryCLR=$(grep -oP '^ramSecondaryCLR=\K.*' $ramCfg | head -n1 )

}

writeConfig() {
    cat $caseTmp | awk '{ print "caseCLRMode="$1 }' > $caseCfg
    cat $caseTmp | awk '{ print "casePrimaryCLR="$2 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSecondaryCLR="$3 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseTempProbe="$4 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed20="$5 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed30="$6 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed40="$7 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed50="$8 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed60="$9 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed70="$10 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed80="$11 }' >> $caseCfg
    cat $caseTmp | awk '{ print "caseSpeed90="$12 }'  >> $caseCfg
    
    cat $aioTmp | awk '{ print "aioCLR="$1 }' > $aioCfg
    cat $aioTmp | awk '{ print "aioPumpSpeed="$2 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioTempProbe="$3 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed20="$4 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed30="$5 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed40="$6 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed50="$7 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed60="$8 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed70="$9 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed80="$10 }' >> $aioCfg
    cat $aioTmp | awk '{ print "aioSpeed90="$11 }' >> $aioCfg
    
    cat $ramTmp | awk '{ print "disableRamOnSleep="$1 }' > $ramCfg
    cat $ramTmp | awk '{ print "caseCLRMode="$2 }' >> $ramCfg
    cat $ramTmp | awk '{ print "ramPrimaryCLR="$3 }' >> $ramCfg
    cat $ramTmp | awk '{ print "ramSecondaryCLR="$4 }' >> $ramCfg
}

readConfig

# Fix Case Var
caseCLRMode=$(setCBValue "fixed!spectrum-wave" "$caseCLRMode")
caseTempProbe=$(setCBValue "CPU!GPU" "$caseTempProbe")

# Fix AIO Var
aioTempProbe=$(setCBValue "CPU!Coolant" "$aioTempProbe")

# Fix Ram Var
ramCLRMode=$(setCBValue "fixed!spectrum-wave" "$ramCLRMode")
    
    # Case
    (
        yad --form --separator=" " --plug=$plug --tabnum=1\
        --field="<b>LED Strip Options</b>":LBL ""\
        --field="LED Color Mode":CB $caseCLRMode\ \
        --field="LED Primary Color":CLR "$casePrimaryCLR"\
        --field="LED Secondary Color":CLR "$caseSecondaryCLR"\
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
        --field="LED Color":CLR "$aioCLR"\
        --field="<b>Pump Control</b>":LBL ""\
        --field="Pump Speed":SCL "$aioPumpSpeed"\
        --field="<b>Fan Curve</b>":LBL ""\
        --field="Tempature Probe":CB $aioTempProbe \
        --field="Speed at 20c":SCL "$aioSpeed20"\
        --field="Speed at 30c":SCL "$aioSpeed30"\
        --field="Speed at 40c":SCL "$aioSpeed40"\
        --field="Speed at 50c":SCL "$aioSpeed50"\
        --field="Speed at 60c":SCL "$aioSpeed60"\
        --field="Speed at 70c":SCL "$aioSpeed70"\
        --field="Speed at 80c":SCL "$aioSpeed80"\
        --field="Speed at 90c":SCL "$aioSpeed90"\
        >$aioTmp
    )&\
    # RAM
    (
        yad --form --separator=" " --plug=$plug --tabnum=3\
        --field="<b>LED Options</b>":LBL ""\
        --field="Disable on Sleep"!"Disables RAM LED when computer is sleeping":SW "$disableRamOnSleep"\
        --field="LED Color Mode":CB $ramCLRMode\
        --field="LED Primary Color":CLR "$ramPrimaryCLR"\
        --field="LED Secondary Color":CLR "$ramSecondaryCLR"\
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
