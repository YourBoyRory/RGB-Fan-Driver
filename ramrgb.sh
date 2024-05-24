#!/bin/sh
case $1/$2 in
  pre/*)
    echo "Going to $2..."
    touch /tmp/ram_sleep
    sleep 1
    ;;
  post/*)
    echo "Waking up from $2..."
    rm /tmp/ram_sleep
    ;;
esac
