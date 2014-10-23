#!/bin/bash
# File for checking/notification of delayed processed files on ghwmsapp2 at the path below.
# (on ghwmsapp2) Checked path: /opt/redprairie/wmsprd880/les/files/hostin/xml_inbound/
#

XML_HOME=/opt/redprairie/wmsprd880/les/files/hostin/xml_inbound
RUNDATE=`date +%d.%m.%Y-%H%M`
NOTIFY=dveer@northwest.ca
MAX_AGE_MIN=30
LOG=/tmp/check_for_redprairie_files.$RUNDATE.log
LOGGER="tee -a $LOG"
HOSTNAME=$(hostname -s)

# find XML files that have a date older than 30 minutes for the xml_inbound directory
echo ">>> Finding XML files older than $MAX_AGE_MIN minutes..." | $LOGGER
echo -en '\n' | $LOGGER
find $XML_HOME -name *.xml -type f -amin +$MAX_AGE_MIN | $LOGGER

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
	cat $LOG | echo mailx -s "Delayed XML files in '\\ghwmsapp2\wmsprd880in\xml_inbound' have been found on $HOSTNAME at $RUNDATE" -r ghwmsapp2@northwest.ca $NOTIFY | $LOGGER
else
	echo -en '\n' | $LOGGER
	echo ">>> No delayed files have been found. Thus, exiting." | $LOGGER
fi

# Delete the output file, if file exists and size is greater than 0 KB.
if [ -s $LOG ]
then
        rm $LOG
fi
