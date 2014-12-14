CopyFromPhone
=============

This Bash script is usefull to transfer photo and video from your mobile to your PC

Questo script e' stato creato con lo scopo di automatizzare il trasferimento delle foto e dei video dal telefono a PC.

### Istruzioni:
- il file ```config.cfg``` deve essere completato con le path della sorgente (nel telefono) e della destinazione (il PC)
  es: 
    ```bash
    PATHTELEFONO="/media/<user>/<telefono>/DCIM/Camera"
    PATHPC="/home/<user>/backupFotoCell"
    ```

- rendere eseguibile lo script "copyFromMobile.sh" con il comando: ```$chmod u+x copyFromMobile.py```

- eseguire lo script con il comando ```$./copyFromMobile.sh```

- seguite le istruzioni a video

### TODO

- file di configurazione dove leggere le path del telefono e della destinazione dei contenuti :white_check_mark:
- lettura di foto e video anche in altri formati (ora solo .jpg e .mp4) :white_check_mark:
- riconoscimento del telefono collegato in base alla PATHTELEFONO trovata tra quelle presenti nel file di configurazione :x:
- unmount del telefono una volta terminato il programma :x:
