#!/bin/bash

plug=$RANDOM
caseCfg="./tmp/case.cfg"
aioCfg="./tmp/aio.cfg"
ramCfg="./tmp/ram.cfg"



readConfig() {
    # Case Var
    stripCLR=$(grep -oP '^ramCLR=\K.*' $caseCfg | head -n1 )

    # AIO Var
    aioCLR=$(grep -oP '^aioCLR=\K.*' $aioCfg | head -n1 )

    # Ram Var
    disableRamOnSleep=$(grep -oP '^disableRamOnSleep=\K.*' $ramCfg | head -n1 )
    ramPrimaryCLR=$(grep -oP '^ramPrimaryCLR=\K.*' $ramCfg | head -n1 )
    ramSecondaryCLR=$(grep -oP '^ramSecondaryCLR=\K.*' $ramCfg | head -n1 )

}

writeConfig() {
    cat $caseCfg
    cat $aioCfg
    cat $ramCfg
}

readConfig
    
    # Case
    (
        yad --form --plug=$plug --tabnum=1\
        --field="<b>LED Strip Options</b>":LBL ""\
        --field="LED Color Mode":CB "fixed!spectrum-wave" \
        --field="LED Primary Color":CLR "$ramPrimaryCLR"\
        --field="LED Secondary Color":CLR "$ramPrimaryCLR"\
        --field="<b>Fan Curve</b>":LBL ""\
        --field="Tempature Probe":CB "CPU!GPU" \
        --field="Speed at 30c":SCL ""\
        --field="Speed at 40c":SCL ""\
        --field="Speed at 50c":SCL ""\
        --field="Speed at 60c":SCL ""\
        --field="Speed at 70c":SCL ""\
        --field="Speed at 80c":SCL ""\
        --field="Speed at 90c":SCL ""\
        >$caseCfg
    )&\
    # AIO
    (
        yad --form --plug=$plug --tabnum=2\
        --field="<b>LOGO LED Options</b>":LBL ""\
        --field="LED Color":CLR ""\
        --field="<b>Pump Control</b>":LBL ""\
        --field="Pump Speed":SCL ""\
        --field="<b>Fan Curve</b>":LBL ""\
        --field="Tempature Probe":CB "CPU!Coolant" \
        --field="Speed at 30c":SCL ""\
        --field="Speed at 40c":SCL ""\
        --field="Speed at 50c":SCL ""\
        --field="Speed at 60c":SCL ""\
        --field="Speed at 70c":SCL ""\
        --field="Speed at 80c":SCL ""\
        --field="Speed at 90c":SCL ""\
        >$aioCfg
    )&\
    # RAM
    (
        yad --form --plug=$plug --tabnum=3\
        --field="<b>LED Options</b>":LBL ""\
        --field="Disable on Sleep"!"Disables RAM LED when computer is sleeping":SW "$disableRamOnSleep"\
        --field="LED Color Mode":CB "fixed!spectrum-wave" ""\
        --field="LED Primary Color":CLR ""\
        --field="LED Secondary Color":CLR ""\
        >$ramCfg
    )&\
    
    #draw UI
    (
        yad --notebook --key=$plug --width=500 --title="$(hostname) Config"\
        --tab="Case"\
        --tab="AIO"\
        --tab="RAM"\
        --button="Save":0\
        --button="Cancel":1\
    )

writeConfig
