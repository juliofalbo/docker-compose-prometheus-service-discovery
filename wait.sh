#!/usr/bin/env bash

TIMEOUT=$1;
FILENAME=$2;
TEXT=$3;

counter=1
until (tail -n 100 "$FILENAME" &) | grep -q "$TEXT"; do
    if (("$counter" % 10 == 0)) && [[ "$FILENAME" ]]; then
        echo "The text $TEXT was found in $FILENAME!"
    fi
    printf '.'
    sleep "$TIMEOUT"
    counter=$((counter+1))
done
echo;