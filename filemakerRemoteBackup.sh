#!/bin/bash

# set variable of current date to create new directory with unique name for this backup
DIR=$(date)

# execute rsync command
rsync -avzhe ssh --delete --dry-run <LOCAL DIR> <root@111.222.3.444:/REMOTEDIR/DIR Variable so it will create new directory>

# confirm rsync was sucessful, if not send email alert, send success alert only for testing, then comment out

if [ "$?" -eq "0" ]
# if [ "$?" -ne "0" ]
# if [ "$?" !0 "0" ]
then
  echo "Backup successful!" | mail -s Success! - jon.arouca@somewhere.com
else
  rm -rf rm /home/pi/queue/*
  echo "Backup failed." | mail -s Backup failed - user@domain.com
fi

# delete old backups
`which find` <backupDIRname>* -mtime + DAYSTOKEEPBACKUP -exec rm {}
