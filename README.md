A very simple ad blacklist script for the unbound DNS server.  

Strips all extraneous materials out from URL, formats in the correct format for unbound, and dumps it in a location of your choice.  

add the following line to your unbound config:
include: /your/blacklist/file/location.file

Add to crontab daily or weekly, and enjoy ad free browing.  

Made for OpenBSD 5.3
