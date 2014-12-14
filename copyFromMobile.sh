#!/bin/bash

# Set internal field separator to NewLine
IFS='
'

# Variabli globali
PATHTELEFONO=""
PATHPC=""
FORMATOFOTO=("jpg" "png") #Aggiungere aventuali altri formati all'array
FORMATOVIDEO=("mp4" "avi") #Aggiungere aventuali altri formati all'array

funct_nrFilePresenti()
{
    NRFOTO=0
    NRVIDEO=0

    # Conteggio foto presenti nella cartella sorgente
    for i in "${FORMATOFOTO[@]}"
    do
       NRFOTO=$(($NRFOTO+$(ls -lt $PATHTELEFONO/*.$i 2>/dev/null | wc -l))) 
    done

    # Conteggio video presenti nella cartella sorgente
    for i in "${FORMATOVIDEO[@]}"
    do
       NRVIDEO=$(($NRVIDEO+$(ls -lt $PATHTELEFONO/*.$i 2>/dev/null | wc -l)))
    done

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
 
    # Ricava le estensioni dei file da estrarre
    declare -a extension=()
    funct_GetFormatoFile $1
 
    local nrFileCopiati=0

    # Conteggio video presenti nella cartella sorgente
    for i in "${extension[@]}"
    do 
        for item in $(ls $PATHTELEFONO/*.$i 2>/dev/null)
        do
            # Estraggo il nome del file
            NOMEFILE=${item#*$PATHTELEFONO/}
            FILEPRESENTI=$(ls "$PATHPC/$1/$NOMEFILE" 2>/dev/null | wc -l)
            if [ "$FILEPRESENTI" -eq 0 ]
            then
                cp $item $PATHPC/$1
                nrFileCopiati=$(($nrFileCopiati + 1)) 
            fi
        done
    done
    echo "Copiati $nrFileCopiati nuovi file $1"
}

funct_CancellaFiles()
{
    # Ricava la lista di estensioni dei file da estrarre
    declare -a  extension=()
    funct_GetFormatoFile $2

    # cancella tutti i files della tipologia specificata nella path    
    for i in "${extension[@]}"
    do 
         rm -f $1/*.$i
    done
}

funct_GetFormatoFile()
{
    case $1 in
        "FOTO")  for i in $(seq 0 $((${#FORMATOFOTO[@]}-1)))
                 do
                     extension[$i]="${FORMATOFOTO[$i]}"
                 done;;
        "VIDEO") for i in $(seq 0 $((${#FORMATOVIDEO[@]}-1)))
                 do
                     extension[$i]="${FORMATOVIDEO[$i]}"
                 done;;
        *)       myRes="Error"
               	 echo "$myRes";;
    esac
}

funct_loadConfig()
{
    # Estraggo una riga per volta
    for item in $(cat config.cfg)
    do
        case $(echo $item | cut -d"=" -f1) in
            "PATHTELEFONO") PATHTELEFONO=$(echo $item | cut -d"=" -f2 | tr -d '"')
                            echo "path telefono --> $PATHTELEFONO";;
            "PATHPC")       PATHPC=$(echo $item | cut -d"=" -f2 | tr -d '"')
                            echo "path PC --> $PATHPC";;
        esac
    done
}

main()
{
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

        echo ""
        echo "Copia eseguita correttamente su PC. Vuoi cancellare le foto e i video dal telefono? [S/n]"
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
}

# Richiamo funzione per il caricamento dei parametri
funct_loadConfig

# Richiamo main
main

