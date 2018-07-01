#!/bin/bash

# set variable of current date to create new directory with unique name for this backup
DIR=$(date)

# execute rsync command
rsync -avzhe ssh --delete --dry-run <LOCAL DIR> <root@111.222.3.444:/REMOTEDIR/DIR Variable so it will create new directory>
# will script need password/permissions set up to ssh to remote dir? whisky

# confirm rsync was sucessful, if not send email alert, send success alert only for testing, then comment out

if [ "$?" -eq "0" ]
# if [ "$?" -ne "0" ]
# if [ "$?" !0 "0" ]
then
  echo "Filemaker database backup successful!" | mail -s Success! - jon.arouca@acordex.com
else
  rm -rf rm /home/pi/queue/*
  echo "Filemaker database backup failed." | mail -s Filemaker Backup failed - user@domain.com
fi

# delete old backups
`which find` <backupDIRname>* -mtime +DAYSTOKEEPBACKUP -exec rm {}
