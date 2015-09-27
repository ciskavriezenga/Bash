#! /bin/bash

# allowed file types for script

TYPE=(wav, mp3, ogg, flac, aiff, raw, aac)

echo "*************************************************************************************"
echo "*This script was designed to edit all the files in a folder in four different ways.**"
echo "*An argument specifying which file types in the folder should be edited is optional.*"
echo "******If no arguments are given, all usable files in the folder will be edited.******"
echo "*******************Press enter to continue, CTRL+C to exit***************************"
read $answer

# check if an argument was given; set it to that file type if it was, set to ./* (all files) if it wasn't

if [ $# -ge 1 ]                # if the number of arguments is 1
then                           #
  arg="./*.${1//./}"           # then set it to that argument + ./*. prepended to it
else                           #
  arg=./*                      # otherwise set it to ./*
fi

# check if the given argument is an allowed file type

if ! [[ ./*.${TYPE[*]} =~ $arg ]]
then
  echo "The file type given as argument can't be used"
  exit

elif [[ ./*.${TYPE[*]} =~ $arg ]]
then

  echo "This script will create a new folder and edit every file (with specified file type, if given) in it in four different ways."
  echo "Are you sure you want to continue? [Y/N]:"
  read response

  if [[ "${response,,}" == "n" ]]
  then
    echo "Exiting..."
    exit

  elif [[ "${response,,}" == "y" ]]
  then

    # create a directory to save the edited files in
    `mkdir edited_files`

    for file in $arg
    do
      file=${file#./}
      basename=`basename $file .${file#*.}`

      # check if the incoming file type is allowed again, for when all files in a folder are to be edited.

      if ! [[ ${TYPE[*]} =~ ${file##*.} ]]
      then
        continue

      else
        echo "Normalizing and trimming ${basename}.${file#*.}"
        `sox $file ${basename}_norm.${file#*.} --norm`
        `sox ${basename}_norm.${file#*.} ${basename}_trim1.${file#*.} trim 0.0 5.0`
        `sox ${basename}_trim1.${file#*.} ${basename}_trim.${file#*.} fade 0.1 4.8 0.1`


        echo "Trimming and applying reverb to $basename"
        `sox ${basename}_norm.${file#*.} ${basename}_trim2.${file#*.} trim 5.0 4.0`
        `sox ${basename}_trim2.${file#*.} ${basename}_trim_verb.${file#*.} reverb`
        `sox ${basename}_trim_verb.${file#*.} ${basename}_verb.${file#*.} fade 0.1 3.8 0.1`


        echo "Trimming and applying overdrive to ${basename}.${file#*.}"
        `sox ${basename}_norm.${file#*.} ${basename}_trim3.${file#*.} trim 9.0 2.0`
        `sox ${basename}_trim3.${file#*.} ${basename}_trim_od.${file#*.} overdrive 100 100`
        `sox ${basename}_trim_od.${file#*.} ${basename}_odsoft.${file#*.} vol -20dB`
        `sox ${basename}_odsoft.${file#*.} ${basename}_od.${file#*.} fade 0.1 1.8 0.1`


        echo "Trimming and applying chorus to ${basename}.${file#*.}"
        `sox ${basename}_norm.${file#*.} ${basename}_trim4.${file#*.} trim 5.5 6`
        `sox ${basename}_trim4.${file#*.} ${basename}_trim_chor.${file#*.} chorus 1.0 0.0 25 0.5 1 5 -s`
        `sox ${basename}_trim_chor.${file#*.} ${basename}_chor.${file#*.} fade 0.1 5.8 0.1`


        echo "Moving edited files to new directory"
        `mv ./${basename}_trim.${file#*.} ./edited_files/`
        `mv ./${basename}_verb.${file#*.} ./edited_files/`
        `mv ./${basename}_od.${file#*.} ./edited_files/`
        `mv ./${basename}_chor.${file#*.} ./edited_files/`

        echo "Removing temporary files"
        `rm ${basename}_trim1.${file#*.}`
        `rm ${basename}_trim2.${file#*.}`
        `rm ${basename}_trim_verb.${file#*.}`
        `rm ${basename}_trim3.${file#*.}`
        `rm ${basename}_trim_od.${file#*.}`
        `rm ${basename}_odsoft.${file#*.}`
        `rm ${basename}_trim4.${file#*.}`
        `rm ${basename}_trim_chor.${file#*.}`
        `rm ${basename}_norm.${file#*.}`

      fi
    done
  fi
fi
