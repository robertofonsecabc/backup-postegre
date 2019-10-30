#!/bin/bash

#Setting up connectino
USER_BECOME=postgres;
DB_PARAM='-c --column-inserts';
DB_NAME=poderoso;
BUCKET_NAME=backup-soset;


#Setting up variables
FILENAME=$(date '+%Y%m%d%H%M%S').sql;

PGDUMP=/usr/bin/pg_dump;
BACKUP_DIR=/home/soset/backup/postgres;
POSTGRE_DIR=/var/lib/postgresql/dumps;
GSUTIL=/usr/bin/gsutil;

LOG_FILE="${BACKUP_DIR}/run.log"

touch $LOG_FILE

#Create dump directory if not exists
if [ ! -e "$POSTGRE_DIR" ]; then
  #echo "Create dump directory";
  sudo su --command " mkdir -p $POSTGRE_DIR; " $USER_BECOME;
fi

#Create backup directory if not exists
if [ ! -e "$BACKUP_DIR" ]; then
  #echo "Create backup directory";
  mkdir -p $BACKUP_DIR;
fi

#Start backup to directory
echo " Starting backup $FILENAME" >>  $LOG_FILE;
sudo su --command " $PGDUMP $DB_PARAM $DB_NAME > $POSTGRE_DIR/$FILENAME; " $USER_BECOME;
echo " Backup done " >>  $LOG_FILE;

mv $POSTGRE_DIR/$FILENAME $BACKUP_DIR/$FILENAME;

#Create zip file
echo " Create zip $FILENAME.zip" >>  $LOG_FILE;;
zip $BACKUP_DIR/$FILENAME.zip $BACKUP_DIR/$FILENAME;

#Remove file
#echo " Delete zip ";
rm $BACKUP_DIR/$FILENAME;

# Upload to google cloud
echo " Upload to bucket" >>  $LOG_FILE;;
$GSUTIL cp $BACKUP_DIR/$FILENAME.zip gs://$BUCKET_NAME/$(date '+%Y')/$(date '+%m')/;

echo " Finished script " >>  $LOG_FILE;;
