#!/bin/bash

BACKUP_DIR="/backup"
LOG_FILE="${BACKUP_DIR}/cleanup.log"
MAX_DAYS=180 #keep backups for 6 months

touch $LOG_FILE
echo "Start cleanup @ `date`" >> $LOG_FILE

#get oldest backup
cd $BACKUP_DIR
backup=`ls -1t *.backup | tail -1`

#do we have a backup file?
if [ -n "$backup" ]; then
        echo "Found backup $backup, check date for deletion" >> $LOG_FILE

        year_now=`date +%Y`
        month_now=`date +%m`
        day_now=`date +%d`
        date_now="$year_now,$(expr $month_now + 0),$(expr $day_now + 0)"

        year_file=`echo $backup | sed 's/\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\).*/\1/'`
        month_file=`echo $backup | sed 's/\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\).*/\2/'`
        day_file=`echo $backup | sed 's/\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\).*/\3/'`
        date_file="$year_file,$(expr $month_file + 0),$(expr $day_file + 0)"

        datediff=`python -c "from datetime import date; print (date($date_now)-date($date_file)).days"`

        echo "File backup performed on: $date_file" >> $LOG_FILE
        echo "Current date: $date_now" >> $LOG_FILE
        echo "Backup is $datediff days old" >> $LOG_FILE
        
        if [ $datediff -gt $MAX_DAYS ]; then
                #should remove the backup since it's older than MAX_DAYS
                echo "Remove backup since it's older than $MAX_DAYS days" >> $LOG_FILE

                rm $backup
        fi
fi

echo "______________________________________________________________________" >> $LOG_FILE