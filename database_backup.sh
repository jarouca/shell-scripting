#!/bin/bash

# This is a generic shell script to backup a database to a remote machine. Cron can be scheduled to execute this script as frequently as desired. The first backup of every month will be saved to a permanentStorage directory. Daily backups are saved to a rollingStorage directory and kept for 62 days.

# assign variables
filename=$( echo $(date "+%D") | tr -d '/' )
month=$( echo $(date) | cut -c '5-7' )
year=$( echo $(date) | rev | cut -c '1-4' | rev )

# if permanentStorage directory does not have a directory for the current year, make one
$( ssh -p 1234 11.111.1.111 "[ -d /remote/machine/backup/directory/permanentStorage/$year ] || mkdir /remote/machine/backup/directory/permanentStorage/$year" )

# if permanent storage directory does not have a backup for this month, sync one to it,
# otherwise add any newly created files without updating any already existing
rsync -avzh -e "ssh -p 1234" --ignore-existing /local/database/directory 11.111.1.111:/remote/machine/backup/directory/permanentStorage/$year/$month

# if rsync was not successful, send email alert
if [ "$?" != "0" ]
then
  echo "Remote permanent storage database backup failed." | mail -s Remote permanent storage backup failed - admin@db.com
fi

# sync a new daily backup to the rolling storage
rsync -avzh -e "ssh -p 1234" /local/database/directory 11.111.1.111:/remote/machine/backup/directory/rollingStorage/$filename/

# if rsync was not successful, send email alert
if [ "$?" != "0" ]
then
  echo "Remote rolling storage database backup failed." | mail -s Remote rolling storage backup failed - admin@db.com
fi

# delete rollingStorage backups older than 62 days
$( ssh -p 1234 11.111.1.111 "find /remote/machine/backup/directory/rollingStorage/* -prune -mtime +62 -exec rm -rf {} \;" )
