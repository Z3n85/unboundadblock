#! /bin/bash
#  Creates DNS blacklist for unbound server
##################################################################################
#Config bits
#Notifification email
EMAIL="changeme@changeme.com"
#Final blacklistlist location
FINALLIST="/var/unbound/etc/blacklist.list"

#static file option
STATICBLACKLIST="/usr/local/dnsblacklist/static.list"

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
blacklist="$(curl $BLACKLISTURL)"
static="$(cat $STATICBLACKLIST)"

#Get blacklist, Parse out non-URL entries, dump to blacklist file
echo "$blacklist$static" | sed -n '/[^a-z0-9\.\*]/!p' | sed -n '/[a-zA-Z0-0]/p' | awk '{print "local-zone: \""$0"\" redirect\nlocal-data: \""$0" A 127.0.0.1\""}' > $FINALLIST 

#change permissions on final blacklist file
chown $OWNER:$GROUP $FINALLIST
chmod $PERMISSIONS $FINALLIST

#restart service, redirect output to mail
$UNBOUNDRESTART | mail -s "YourDNSBlockUpdate" $EMAIL 
