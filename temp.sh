#!/bin/bash

IFS='
'

# Dichiaro array contenete parametri configurazione
declare -a CONFIGARRAY

# Estraggo una riga per volta
for item in $(cat config.cfg)
do
    case $(echo $item | cut -d"=" -f1) in
        "PATHTELEFONO") CONFIGARRAY[0]=$(echo $item | cut -d"=" -f2)
                        echo "pathtelefono letta è ${CONFIGARRAY[0]}";;
        "PATHPC")       CONFIGARRAY[1]=$(echo $item | cut -d"=" -f2)
                        echo "pathtelefono letta è ${CONFIGARRAY[1]}";;
    esac
done

