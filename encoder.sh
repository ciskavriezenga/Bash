#! /bin/bash

# define a list of uncompressed and compressed file types that are valid in sox

UNCOMP=(wav, aiff, raw)
COMP=(mp3, ogg, flac)

# define what the separate arguments mean

FILEFROM=$1
FILETO=$2

# remove any periods from the file extensions

FILEFROM=${FILEFROM//./}
FILETO=${FILETO//./}

# check if the file extension is valid and if the proper number of arguments was given

if [[ $# -ne 2 ]]
then
  echo "2 arguments required, you supplied $#. Please supply the original and desired file types"
  exit

elif ! [[ $UNCOMP =~ $FILEFROM ]]
then
  echo "${FILEFROM} is not a supported file type, only ${UNCOMP[*]} are supported"
  exit

elif ! [[ $COMP =~ $FILETO ]]
then
  echo "${FILETO} is not a supported file type, only ${COMP[*]} are supported"
  exit

# start the loop for every file in the current directory if the user agrees

else

  echo "This operation will create a new folder and new files equal to the amount of files of file type $FILEFROM in this folder. Continue? [Y/N]:"
  read response

  if [[ "${response,,}" == "n" ]]
  then
    echo "Exiting..."
    exit

  elif [[ "${response,,}" == "y" ]]
  then
    `mkdir converted_files`
    for file in ./*
    do

      # create the basename of the file and then tell sox to convert from the original file to the basename + new extension

      BASENAME=`basename $file .$FILEFROM`
      if [[ $file == *.$FILEFROM ]]
      then
        echo "Processing ${file#./}..."
        `sox $file ${BASENAME}.${FILETO}`
        `mv ./${BASENAME}.${FILETO} ./converted_files/`
      fi
    done
  fi
fi
