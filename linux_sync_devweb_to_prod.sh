#!/bin/bash
#
# $Id: linux_sync_devweb_to_prod.sh 2014-02-04 15:55:46Z isdvee $
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
FAILURE_NOTIFY=servergroup@northwest.ca
#FAILURE_NOTIFY=servergroup@northwest.ca,helpdesk@northwest.ca
#PHONE_NOTIFY=2049358016@page.mts.ca

RSYNC_OUTPUT=/tmp/linux_sync_devweb_to_prod.$$

# These directories _must_ exist. 
# If the mount point or destination direcory are not present, the mount and copy, respectively, will fail.
#SOURCE_MOUNT=/mnt/tmpDRFiles
#DEST_BASE=/mnt/ddbackup/gh/DRFiles


# These mount options are specified so that the copied files have 
# an appropriate owner, group and mode. As well, stored credentials 
# for the task service account are specified.
#MOUNTOPTS="ro,credentials=/root/.taskservice.cred,uid=TNWC/Administrator,gid=TNWC/Server Group,file_mode=0775,dir_mode=0775"

# Source array. To add a new directory to mirror, add it to the end of the array.
# Be sure to escape any characters that might be eaten by string expansion
#SOURCEUNC[0]="ghnas:Depts/INFOSERV/Server Group/TNWC Corporate"
#SOURCEUNC[1]="ghnas:Depts/INFOSERV/Server Group/Infrastructure Documentation"
#SOURCEUNC[2]="ghnas:Depts/INFOSERV/Shared Resources/PasswordMGR"
#SOURCEUNC[3]="ghnas:Server\$"
#SOURCEUNC[4]="ghadmin:AdminScripts/ServerScripts/Scheduled/WinSysDocumenter"
#SOURCEUNC[5]="ghnas:Depts/INFOSERV/ITGovernance/IT Disaster Recovery"
#SOURCEUNC[6]="ghnas:Depts/INFOSERV/network group/1 technology specific/disaster recovery PM"
#SOURCEUNC[7]="ghnas:Depts/INFOSERV/DBA Group/DBADocs"
#SOURCEUNC[8]="ghnas:Global/Business Continuity"

# clear a counter so that we know if anything failed
FAIL=0

echo "This is the script $0 running on ghadminlx." >> $RSYNC_OUTPUT 2>&1
echo "If any failures have been detected, check there first." >> $RSYNC_OUTPUT 2>&1

echo "Starting rsync process..." >> $RSYNC_OUTPUT 2>&1
# Starting to run the rsync command. All output is captured into a file at the end.

	# Copy the files 
	echo /usr/bin/rsync -ati --stats --delete-after --numeric-ids  "$SOURCE_DIR" "$DEST_DIR"
	/usr/bin/rsync -ati --stats --delete-after --numeric-ids  "$SOURCE_DIR" "$DEST_DIR"
	rc=$?
	echo "rsync returned $rc"
	if [[ $rc != 0 ]] ; then
		# bump the counter on a non-zero rsync
		let "FAIL += 1"
	fi
done >> $RSYNC_OUTPUT 2>&1

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
rm $RSYNC_OUTPUT

