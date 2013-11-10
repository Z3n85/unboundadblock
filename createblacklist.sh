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


###################################################################################
#This part does stuff

#Housecleaning old file, just in case
rm $FINALLIST

#Get blacklist, Parse out non-URL entries
curl $BLACKLISTURL | grep -v [^a-z0-9\.\*] | grep [a-z0-9A-Z] |while read line; do

	echo "local-zone: \"$line\" redirect" >> $FINALLIST
	echo "local-data: \"$line A 127.0.0.1\"" >> $FINALLIST

done

#change permissions on final blacklist file
chown $OWNER:$GROUP $FINALLIST
chmod $PERMISSIONS $FINALLIST

#restart service
$UNBOUNDRESTART
