#!/bin/bash

# Get the bucket name from an argument passed to the script
NOW=$(date +%Y%m%d%H%M%S)
BUCKET_NAME=TEST-BUCKET
TARGET_DIR=<TARGET_ABSOLUTE_DIR>
BACKUP_DIR=<BACKUP_ABSOLUTE_DIR>
BACKUP_FILE=${NOW}_backup_data.tar.gz

# COPY Target File With preserving permissions and excluding files
rsync -av -p -g -o -t --progress $TARGET_DIR $BACKUP_DIR --exclude <EXCLUDE_FILE_NAME_1> --exclude <EXCLUDE_FILE_NAME_2>

# Compress target copied folder to .tar.gz file
tar -zcvf /home/ubuntu/backups/$BACKUP_FILE $BACKUP_DIR

# Remove backup files that are a month old
rm -f $BACKUP_DIR/$(date +%Y%m%d* --date='1 month ago').gz

# Remove copied folder
rm -rf $BACKUP_DIR/*

# Copy files to S3 if bucket given
if [ ! -z "$BUCKET_NAME" ]
then
    aws s3 cp /home/ubuntu/backups/$BACKUP_FILE s3://$BUCKET_NAME/ --quiet --storage-class STANDARD_IA
fi