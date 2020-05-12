# FanOverlord
This is a Docker container that uses IPMI to monitor and control the fans on a Dell R720 server through the iDRAC using raw commands.  

This script will read the CPU temp sensor every X seconds (20 by default) and then apply a custom defined fan speed to the iDRAC. Each state can have a custom fan speed but the Emergency state sets it back to Auto-control from the BIOS/iDRAC.  
  
Additionally it sends out healthchecks to healthchecks.io and uses Slacktee to send messages to a slack channel about emergencies. (this can be removed if not wanted).

https://github.com/NoLooseEnds/Scripts/tree/master/R710-IPMI-TEMP was the source of my knowledge on how to issue the commands and it was the inspiration for this effort.

### Server Details
```
IPMIHOST=<IP Address of the iDRAC on the Server>
IPMIUSER=<User for the iDRAC>
IPMIPW=<Password for the iDRAC
```
