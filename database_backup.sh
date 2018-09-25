#!/bin/bash

# This is a generic shell script to backup a database to a remote machine. Cron can be scheduled to execute this script as frequently as desired. The first backup of every month will be saved to a permanentStorage directory. Daily backups are saved to a rollingStorage directory and kept for 62 days.

# assign variables
filename=$( echo $(date "+%D") | tr -d '/' )
month=$( echo $(date) | cut -c '5-7' )
year=$( echo $(date) | rev | cut -c '1-4' | rev )

# if permanentStorage directory does not have a directory for the current year, make one
$( ssh -p 5951 69.166.8.159 "[ -d /home/acordex/fmBackup/permanentStorage/$year ] || mkdir /home/acordex/fmBackup/permanentStorage/$year" )

# if permanent storage directory does not have a backup for this month, sync one to it,
# otherwise add any newly created files without updating any already existing
rsync -avzh -e "ssh -p 5951" --exclude '*.fp7' --ignore-existing /Library/FileMaker\ Server/Data/Databases/AcordexDB 69.166.8.159:/home/acordex/fmBackup/permanentStorage/$year/$month/

# if rsync was not successful, send email alert
if [ "$?" != "0" ]
then
  echo "Remote Filemaker permanent storage database backup failed. A Cron job is scheduled to run the backup script Coral_FM/Coral\ HD/Users/acordex/Desktop/Scripts/fmRemoteBackup.sh daily." | mail -s Filemaker remote permanent storage backup failed - faxalert@acordex.com
fi

# sync a new daily backup to the rolling storage
rsync -avzh -e "ssh -p 5951" --exclude '*.fp7' /Library/FileMaker\ Server/Data/Databases/AcordexDB 69.166.8.159:/home/acordex/fmBackup/rollingStorage/$filename/

# if rsync was not successful, send email alert
if [ "$?" != "0" ]
then
  echo "Remote Filemaker rolling storage database backup failed. A Cron job is scheduled to run the backup scriptCoral_FM/Coral\ HD/Users/acordex/Desktop/Scripts/fmRemoteBackup.sh daily." | mail -s Filemaker remote rolling storage backup failed - faxalert@acordex.com
fi

# delete rollingStorage backups older than 62 days
$( ssh -p 5951 69.166.8.159 "find /home/acordex/fmBackup/rollingStorage/* -prune -mtime +62 -exec rm -rf {} \;" )
