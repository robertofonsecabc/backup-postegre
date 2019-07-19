#!/bin/bash

BACKUP_DIR="/backup"
LOG_FILE="${BACKUP_DIR}/backup.log"
CURRENT_DATE_TIME=`date +%Y-%m-%dT%H_%M`
HOST="localhost"
DBASE="poderoso"
USER="giovanni"

touch $LOG_FILE
echo "Start database backup at `date` for [${DBASE}]" >> $LOG_FILE

#make sure root has a .pgpass for $USER to avoid psql password prompt
pg_dump -h $HOST -U $USER -f "$BACKUP_DIR/$CURRENT_DATE_TIME-$DBASE.backup" -F c $DBASE

echo "Finish database backup at `date`" >> $LOG_FILE