#!/bin/bash

BACKUP_DIR="/backup"
LOG_FILE="${BACKUP_DIR}/s3.log"
AWS_URL="http://s3.amazonaws.com/net.drayah.poderoso/backups"

touch $LOG_FILE
echo "Start S3 Backup @ `date`" >> $LOG_FILE

#get latest backup
cd $BACKUP_DIR
backup=`ls -1t *.backup | head -1`

#do we have a backup file to upload?
if [ -n "$backup" ]; then
        echo "Found backup file, will upload [$backup] to AWS" >> $LOG_FILE

        localfile="$BACKUP_DIR/$backup"
        remotefile="$AWS_URL/$backup"
        /usr/local/bin/s3-curl/s3curl.pl --id drayah --put $localfile -- $remotefile

        echo "Upload to AWS finished: $remotefile" >> $LOG_FILE
fi

echo "Finish S3 Backup @ `date`" >> $LOG_FILE