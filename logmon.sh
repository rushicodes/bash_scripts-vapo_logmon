#!/bin/bash

SRC="/opt/Script/AO_Monitoring/LogMonitoring"
cd $SRC;
HostName=`hostname`
HostIP=`hostname -i`
MAIL_FILE=$SRC/mail_file.txt
echo ' ' > $SRC/result.txt
Log_dir=$SRC/logs
dt=$(date +"%F_"%H:%M"")
TEMP=$(date +"%Y%m%d.0.log")

#IFS file is $SRC/logmon2

while IFS='#' read -r f1 f2 f3 f4
do
         Path=$f1
         Error=$f2
         TTHRESHOLD=$f3

    NewPath=$Path$TEMP
    if [ -f $NewPath ]; then
      COUNT=`grep -i "$Error" $NewPath | grep -cv -e "ORA-00001" -e "ORA-12899" -e "ORA-02291"`
      if [ "$COUNT" -gt "$TTHRESHOLD" ]; then
        echo "$Error"
        echo -e  " `date` Unwanted Pattern "$Error" Found on $HostName at $NewPath and its Count is $COUNT \n" | tee -a $Log_dir/logmon_$dt.log
        echo -e  "Unwanted Pattern - "$Error" - is Found at $NewPath and its Count is $COUNT \n" >> $SRC/result.txt
      fi
    fi
done < $SRC/logmon2


COUNT2=`grep -ci -e "ERROR" -e "EXCEPTION" -e "ORA-" $SRC/result.txt`
echo "COUNT2 is "$COUNT2""
if [ "$COUNT2" -gt 0 ]; then
                        MAIL="cloudops.applicationoperation@tcs.com"
                          rm -f $MAIL_FILE
                        echo "From: AO-Alert@postnord.com" > $MAIL_FILE
                        #echo "To: vapo_ad_am@postnord.onmicrosoft.com" >> $MAIL_FILE
                        #echo "Cc: $MAIL" >> $MAIL_FILE
                        echo "To: rushikesh.marathe@postnord.com" >> $MAIL_FILE
                        echo "Subject: Vapo Log monitoring alert for server "$HostName" at $dt"  >> $MAIL_FILE
                        echo -e "Unwanted patterns found in some files at /vapo/logs/* directory on "$HostIP"" >> $MAIL_FILE
                        echo -e "`date`\n"  >> $MAIL_FILE
                        echo -e "`cat $SRC/result.txt`\n" >> $MAIL_FILE
                        cat $MAIL_FILE | /usr/sbin/sendmail -t -f ServerAler@postnord.com
fi