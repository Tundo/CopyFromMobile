#!/bin/bash

PATHTELEFONO="/media/pietrorotundo/6462-6232/DCIM/Camera"
PATHPC="/home/pietrorotundo/backupFotoCell"
FORMATOFOTO="jpg"
FORMATOVIDEO="mp4"

funct_nrFilePresenti()
{
    NRFOTO=$(ls -lt $PATHTELEFONO/*.$FORMATOFOTO 2>/dev/null | wc -l)
    NRVIDEO=$(ls -lt $PATHTELEFONO/*.$FORMATOVIDEO 2>/dev/null | wc -l)
    echo "Trovate $NRFOTO foto"
    echo "Trovati $NRVIDEO video"
}


if [ -d $PATHTELEFONO ]
then
    echo "Telefono collegato"
    # visualizza info sui file presenti nel telefono
    funct_nrFilePresenti

    echo "Copia dei dati in corso..."
    #cp -r --update $PATHTELEFONO $PATHPC # Copia intera cartella

    # Copia delle foto
    if [ ! -d "$PATHPC/FOTO" ]
    then
        echo "Cartella foto non presente... Creazione in corso..."
        mkdir $PATHPC"/FOTO"
    fi

    for item in $(ls $PATHTELEFONO/*.$FORMATOFOTO 2>/dev/null)
    do
        # Estraggo il nome del file
        NOMEFILE=${item#*$PATHTELEFONO/}
        FILEPRESENTI=$(ls "$PATHPC/FOTO/$NOMEFILE" 2>/dev/null | wc -l)
        ls "$PATHPC/FOTO/$NOMEFILE"
        echo "$FILEPRESENTI"
        if [ "$FILEPRESENTI" -eq 0 ]
        then
            echo "File non presente. Copia in corso"
            
            cp $item $PATHPC/"FOTO"
        else
            echo "file già esistente"
        fi
    done
else
    echo "Nessun dispositivo rilevato"
fi
