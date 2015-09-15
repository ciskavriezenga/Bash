#! /bin/bash

FILENAME=$1
BASENAME=`basename $1 .wav`

echo $BASENAME


# take a snippet from the years wav
sox $FILENAME ${BASENAME}_trim.wav trim 0.0 5.0

# reverse the taken snippet
sox ${BASENAME}_trim.wav ${BASENAME}_rev.wav reverse

# paste the trimmed and reversed wavs together
sox --combine concatenate ${BASENAME}_trim.wav ${BASENAME}_rev.wav ${BASENAME}_mashup.wav



# naam van script: #0
# eerste argument: $1
# tweede argument: $2
# etc
# aantal argumenten: $#
# echo voor je commando's werkt goed om te kijken wat je script doet, zodat je 
# niet nare shit doet per ongeluk