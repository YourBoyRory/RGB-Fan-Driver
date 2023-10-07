#!/bin/bash 
case $1/$2 in
  pre/*)
    echo "" > /tmp/test.txt
    for i in {0..3}; do
        echo "Going to $2... $i" >> /tmp/test.txt
        sleep .1
        openrgb -d $i -m direct -c 000000 --noautoconnect & 
    done
    ;;
  post/*)
    for i in {0..3}; do
        echo "Waking up from $2... $i" >> /tmp/test.txt
        sleep .1
        openrgb -d $i -m direct -c FFFFFF --noautoconnect &
    done
    ;;
esac
