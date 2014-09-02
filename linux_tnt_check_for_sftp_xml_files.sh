#!/bin/bash
# File for checking/notification of delayed transfer of OTM XML files to the TNT hubs.
#

SFTP_HOME=/srv/home
RUNDATE=`date +%d.%m.%Y-%H%M`
NOTIFY=dveer@northwest.ca
MAX_AGE_MIN=15
LOG=/tmp/check_for_sftp_files.$RUNDATE.log
LOGGER="tee -a $LOG"
HOSTNAME=$(hostname -s)

# find all dirs under /srv/home with an authorized_keys file larger than 0k (not empty) to find the active hubs
ACTIVE_HUBS=$(find $SFTP_HOME -name authorized_keys -type f -size +0k | cut -f1 -d".")

# find XML files that have a date older than 15 minutes for the active hubs
echo ">>> Finding XML files older than $MAX_AGE_MIN minutes..." | $LOGGER
echo -en '\n' | $LOGGER
find $ACTIVE_HUBS -name *.xml -type f -amin +$MAX_AGE_MIN | $LOGGER

# find the number of occurrences in the log file
FILES=$(grep .xml $LOG | wc -l)

# Email out the list of files that are delayed in transfer, if any exist
if [ $FILES -gt 0 ]
then
	echo -en '\n' | $LOGGER
	echo "These files have been delayed in transfer for at least $MAX_AGE_MIN minute(s) on $HOSTNAME." | $LOGGER
	echo "Please investigate." | $LOGGER
	echo -en '\n' | $LOGGER
	echo -en '\n' | $LOGGER
	echo "This message has been auto-generated, do not reply to this email."
	echo -en '\n' | $LOGGER
	echo ">>> Alert generated - $RUNDATE on $(hostname)" | $LOGGER
	cat $LOG | echo mailx -s "Delayed TNT SFTP XML files have been found on $HOSTNAME at $RUNDATE" -r noreply@northwest.ca $NOTIFY | $LOGGER
else
	echo -en '\n' | $LOGGER
	echo ">>> No delayed files have been found. Thus, exiting." | $LOGGER
fi

# Delete the output file, if file exists and size is greater than 0 KB.
if [ -s $LOG ]
then
        rm $LOG
fi
