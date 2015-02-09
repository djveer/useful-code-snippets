o!/bin/bash

# Create a log entry for the uploaded file.
echo "[$(date '+%Y-%m-%d-%H%M')] - $1 has been uploaded to the server." >> /var/log/pure-uploadscript.log


# Upload the file to the corresponding directory on the FTP server (ghext3)
sftp -b /root/uploadscript_batch "sftp.visadps.northwest.ca|xferadm"@sftp.visadps.northwest.ca

# Move the file from "incoming" directory to "processing" directory.
mv -v --no-clobber $1 /srv/ftp/processed/$(basename $1).$(date '+%Y-%m-%d-%H%M') >> /var/log/pure-uploadscript.log
