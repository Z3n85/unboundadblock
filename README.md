A very simple ad blacklist script for the unbound DNS server.  

Strips all extraneous materials out from URL, formats in the correct format for unbound, and dumps it in a location of your choice.  

add the following line to your unbound config:
include: "/your/blacklist/file/location.file"

Add to crontab daily or weekly, and enjoy ad free browing.  

Made / tested on OpenBSD 5.3 - contains some basic stuff for setting permissions and using a different restart script if you want to use it somewhere else. 

Now with a much faster, much lighter weight, much less readable version.   
