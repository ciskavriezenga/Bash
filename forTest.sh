#! /bin/bash

for file in ./*
do
  FILENAME=$file
	if [[ $FILENAME == *.wav ]]
	then
		BASENAME=`basename $FILENAME .wav`
		sox $FILENAME ${BASENAME}_trim.wav trim 0.0 1.0
		continue
	fi
done
