#!/bin/sh

# variables
HOSTS="google.com"
COUNT=5
ping_output=/var/log/scripts/ping-check-result.log

######
echo "Pinging.."
echo "HOSTS: " $HOSTS
echo "COUNT: " $COUNT
echo "logpath: " $ping_output

######
for myHost in $HOSTS
do
  counting=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )
  echo "counting: " $counting

  if [ $counting -gt 2 ]; then
   echo "Ping OK"
   #echo "$(date +"%H:%M:%S") : Internet connectivity is ONLINE!" >> $ping_output

  else
   # network down
   # Save RRD data
   /etc/rc.backup_rrd.sh

   #send error to log
   echo "$(date +"%H:%M:%S") : Internet connectivity is OFFLINE!" >> $ping_output

   echo "Service restarting..."
   #Restart service
   /usr/local/sbin/pfSsh.php playback svc restart openvpn client 1
fi
done
