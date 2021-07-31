#!/bin/bash

HostName=`hostname`
HostIP=`hostname -i`
dt=$(date +"%F_"%H:%M"")
TEMP=$(date +"%Y%m%d.0.log")

SRC="/home/ruma0000/test/logmon_new"
cd $SRC;
path_file=$SRC/path_file.txt
MAIL_FILE=$SRC/mail_file.txt
echo ' ' > $SRC/result.txt
Log_dir=$SRC/logs
err_pattern="Error"

for Path in `cat $path_file`
do  
    #NewPath=$Path$TEMP
    NewPath=$Path
    if [ -f $NewPath ]; then
      COUNT=`grep -c "$err_pattern" $NewPath`
      if [ "$COUNT" -gt 0 ]; then
        tr -s '[:blank:]' '[\n*]' < $NewPath|
            while IFS= read -r word; do
            if [[ "$word" == *"$err_pattern"* ]]; then
                echo "$word"
                $msg=$()
            fi 
            done
        echo "$err_pattern"
      fi
    fi
done 

#if [[ "$output" == *"$out"* ]]
#for i in `cat test1.txt`; do if [[ "$i" == *"$err_pattern"* ]]; then echo $i; fi; done;