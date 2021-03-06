#!/bin/bash
#
# $Id: linux_sync_devweb_to_prod_northwest_ca.sh 06 Feb 2014 16:05:00 isdvee $
# 
######################################################################
#                                                                    #
# This script will run on demand and will synchronize files between  #
# locations listed in SOURCEDIR and with the DESTDIR which will be   #
# on nwc-ux2 in the Radiant environment.                             #
#                                                                    #
#                                                                    #
# CAUTION! - Be careful when editing this script.                    #
#            The quoting is finicky due to the path conversions,     #
#            escaped characters, etc.                                #
#                                                                    #
######################################################################
#                                                                    #
# This script was written by David J. Veer on 4 February 2014.       #
#                                                                    #
#                                                                    #
######################################################################

# Define who should get e-mailed if the backup fails.
SUCCESS_NOTIFY=dveer@northwest.ca
FAILURE_NOTIFY=dveer@northwest.ca
#PHONE_NOTIFY=2049358016@page.mts.ca

RSYNC_OUTPUT=/tmp/linux_sync_devweb_to_prod.$$
TIMESTAMP=$(date +%d-%m-%Y-%H-%M-%S)
# clear a counter so that we know if anything failed
FAIL=0

echo "This is the script $0 running on ghadminlx." >> $RSYNC_OUTPUT 2>&1
echo "If any failures have been detected, check there first." >> $RSYNC_OUTPUT 2>&1

echo "Starting rsync process..." >> $RSYNC_OUTPUT 2>&1
# Starting to run the rsync command. All output is captured into a file at the end.

	# Copy the files 
	echo /usr/bin/rsync -ruvap --exclude 'content' --exclude 'config.inc.php' isdvee@devweb2:/srv/northwest.ca/ /srv/websites/northwest.ca-$TIMESTAMP/ >> $RSYNC_OUTPUT 2>&1
	/usr/bin/rsync -ruvap --exclude 'content' --exclude 'config.inc.php' isdvee@devweb2:/srv/northwest.ca/ /srv/websites/northwest.ca-$TIMESTAMP/ >> $RSYNC_OUTPUT 2>&1
	
	rc=$?
	echo "rsync returned $rc"
	if [[ $rc != 0 ]] ; then
		# bump the counter on a non-zero rsync
		let "FAIL += 1"
	fi

if [[ $FAIL != 0 ]] ; then
	# Send e-mail about failed backup for this client.
	cat $RSYNC_OUTPUT | mailx -s "Web Dev->Prod Sync Failed - ghadminlx rsync devweb2 to nwc-ux2" $FAILURE_NOTIFY
else
	# Send e-mail about Succesful backup for this client, if there is someone to notify.
	if test "X" != "X$SUCCESS_NOTIFY" ; then
		cat $RSYNC_OUTPUT | mailx -s "Web Dev->Prod Sync Failed Success - ghadminlx rsync devweb2 to nwc-ux2" $SUCCESS_NOTIFY
	fi
fi
 
# Remove output file, clean things up at the end
#rm $RSYNC_OUTPUT
