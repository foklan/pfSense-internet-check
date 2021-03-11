#!/bin/sh

# HOSTS can be either you ISP or google.com
HOSTS="google.com"
COUNT=10

echo "Pinging.."
echo "HOSTS: " $HOSTS
echo "COUNT: " $COUNT
######
for myHost in $HOSTS
do
  counting=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )
  echo "counting: " $counting

  if [ $counting > 2 ]; then
   echo "Ping OK"
   #now=$(date +"%T")
   #echo "$now : Internet connectivity is ONLINE!" >> /tmp/result.txt

  else
   # network down
   # Save RRD data
   /etc/rc.backup_rrd.sh
   
   #send error to log
   now=$(date +"%T")
   echo "$now : Internet connectivity is OFFLINE!" >> /tmp/result.txt
   #echo "OpenVPN service will be restarted!" >> /tmp/result.txt

   #Restart service
   echo "Service restarting..."
   #Restart service
   /usr/local/sbin/pfSsh.php playback svc restart openvpn client 1
fi
done
