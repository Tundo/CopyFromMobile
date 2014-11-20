#!/bin/bash

# Set internal field separator to NewLine
IFS='
'

PATHTELEFONO="/media/pietrorotundo/SD_GALAXYS/DCIM/Camera/test"
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

funct_VerificaCreaCartella()
{
    if [ ! -d $1 ]
    then
        echo "Cartella $1 non presente... Creazione in corso..."
        mkdir $1
    fi
}

funct_CopiaFiles()
{
    # Verifico/creo la cartella per il tipo di files richiesto dalla funzione (es. foto, video,etc)
    funct_VerificaCreaCartella $PATHPC"/"$1

    # Ricava il l'estensione dei file da estrarre
    local extension=$(funct_GetFormatoFile $1)

    for item in $(ls $PATHTELEFONO/*.$extension 2>/dev/null)
    do
        # Estraggo il nome del file
        NOMEFILE=${item#*$PATHTELEFONO/}
        FILEPRESENTI=$(ls "$PATHPC/$1/$NOMEFILE" 2>/dev/null | wc -l)
        if [ "$FILEPRESENTI" -eq 0 ]
        then
            echo "File non presente. Copia in corso"
            cp $item $PATHPC/$1
        fi
    done
}

funct_CancellaFiles()
{   
    # Ricava il l'estensione dei file da estrarre
    local extension=$(funct_GetFormatoFile $2)
    
    # cancella tutti i files della tipologia specificata nella path
    rm $1/*.$extension
}

funct_GetFormatoFile()
{
    local myRes
    case $1 in
        "FOTO")  myRes=$FORMATOFOTO
                 echo "$myRes";;
        "VIDEO") myRes=$FORMATOVIDEO
                 echo "$myRes";;
        *)       myRes="Error"
               	 echo "$myRes";;
    esac
}

if [ -d $PATHTELEFONO ]
then
    echo "Telefono collegato"

    # verifico/creo cartella backupTelefono
    funct_VerificaCreaCartella $PATHPC

    # visualizza info sui file presenti nel telefono
    funct_nrFilePresenti

    # Copia delle foto
    echo "Copia delle foto in corso..."
    funct_CopiaFiles "FOTO"

    # Copia dei video
    echo "Copia dei video in corso..."
    funct_CopiaFiles "VIDEO"

    echo "Copia eseguita correttamente su PC. Vuoi cancellare le fotoe i video dal telefono? [S/n]"
    read res
    if [ "$res" == "S" ]
    then
        echo "Cancellazione da telefono in corso..."
        funct_CancellaFiles $PATHTELEFONO "FOTO"
        funct_CancellaFiles $PATHTELEFONO "VIDEO"
    fi

else
    echo "Nessun dispositivo rilevato"
fi
