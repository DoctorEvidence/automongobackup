#!/bin/sh
######################################################################
##
##   MongoDB Database Backup Script
##   Written By: Eugen Stan
##   Requires mongodump tool available on path
######################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%Y%m%d"`

MONGO_URL="${MONGO_URL}"
DB_BACKUP_PATH="${DB_BACKUP_PATH:-/var/lib/automongobackup}"

## Number of days to keep local backup copy
BACKUP_RETAIN_DAYS=${BACKUP_RETAIN_DAYS:-14}
## Keep day of the month
BACKUP_DAY_TO_KEEP="${BACKUP_DAY_TO_KEEP:-01}"

if [ -z ${MONGO_URL} ]; then
  echo "MONGO_URL not specified"
  exit 1
fi


OUT_DIR="${DB_BACKUP_PATH}/${TODAY}/"
mkdir -p ${OUT_DIR}

echo "Backup all databases to $OUT_DIR"
mongodump --uri=$MONGO_URL --out ${OUT_DIR}

######## Remove backups older than {BACKUP_RETAIN_DAYS} days  ########

DBDELDATE=`date +"%Y%m%d" --date="${BACKUP_RETAIN_DAYS} days ago"`
DAY_OF_MONTH=`date +"%d" --date="${BACKUP_RETAIN_DAYS} days ago"`

if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
	  # Check if $DBDELDATE has a value and
	  # If that value is an existing directory
	  # Also check if date is not BACKUP_DAY_TO_KEEP
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
	  	echo "Check for removal ${DB_BACKUP_PATH}/${DBDELDATE} - keep day ${BACKUP_DAY_TO_KEEP}"
		if [ ! "${DAY_OF_MONTH}" = "${BACKUP_DAY_TO_KEEP}" ]; then
			echo "Remove backup ${DB_BACKUP_PATH}/${DBDELDATE}"
			# We remove backup that is not BACKUP_DAY_TO_KEEP and > BACKUP_RETAIN_DAYS
			rm -rf ${DBDELDATE}
		else
			echo "Will keep backup ${DB_BACKUP_PATH}/${DBDELDATE}"
		fi
	  else
		echo "No previous backup for ${DB_BACKUP_PATH}/${DBDELDATE}"
      fi
fi

######################### End of script ##############################
