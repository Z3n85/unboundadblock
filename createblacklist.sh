#! /bin/bash
#  Creates DNS blacklist for unbound server
##################################################################################
#Config bits

#Final blacklistlist location
FINALLIST="/var/unbound/etc/blacklist.list"

#URL to get list of ad servers to blacklist from
BLACKLISTURL="http://pgl.yoyo.org/as/serverlist.php?hostformat=adblock;showintro=0"

#Owner/group for final blacklist file
OWNER=_unbound
GROUP=_unbound

#Permissions for final file
PERMISSIONS=500

#Unbound restart script
UNBOUNDRESTART=/etc/rc.d/unbound\ restart

#Temporary files
TMPFILE="/tmp/blacklist.tmp"
WORKFILE="/tmp/work.tmp"

###################################################################################
#This part does stuff

#Housecleaning old files, just in case
rm $FINALLIST
rm $TMPFILE
rm $WORKFILE

#retrieve new IP list
curl $BLACKLISTURL >> $TMPFILE

#Parse out non-URL entries
grep -v [^a-z0-9\.\*] $TMPFILE >> $WORKFILE

#Kill off the tmpfile, or else it matains old data when new data is appended in
rm $TMPFILE 

#remove whitespace/extra lines, dump into tempfile
grep [a-z0-9A-Z] $WORKFILE >> $TMPFILE 


#read in sanitized urls from tmpfile, format them in correct fashion for unbound to read
cat $TMPFILE |while read line;do

	echo "local-zone: \"$line\" redirect" >> $FINALLIST
	echo "local-data: \"$line A 127.0.0.1\"" >> $FINALLIST

done

#change permissions on final blacklist file
chown $OWNER:$GROUP $FINALLIST
chmod $PERMISSIONS $FINALLIST

#restart service
$UNBOUNDRESTART
