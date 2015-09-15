#! /bin/bash

# define what the separate arguments mean

FILEFROM=$1
FILETO=$2

# remove any periods from the file extensions

FILEFROM=${FILEFROM//./}
FILETO=${FILETO//./}

# start the loop for every file in the current directory

for file in ./*
do

  # create the basename of the file

  BASENAME=`basename $file .$FILEFROM`
  if [[ $file == *.$FILEFROM ]]
  then
    `sox $file ${BASENAME}.${FILETO}`
    echo "Processing ${file#./}..."
  fi
done
