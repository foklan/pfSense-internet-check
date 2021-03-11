# pfSense internet connectivity check

This is simple script which checks if pfSense has connectivity to internet.
If not, then it will restart VPN service and output error message to the file.
This file can be send by email to inform about internet drops during day.



## Installation instructions

1. Login to pfsense with ssh, select "8" for shell command
2. Go to: /usr/local/bin
3. To remount file systems as read-write, run: /etc/rc.conf_mount_rw
4. Create file: ping-check.sh (to create file, simple howto: vi ping-check.sh, then carefully click "i" and paste the code, click "esc", type ":wq!" - all in that order! )
5. chmod 700 ping-check.sh
6. To mount as read-only again, run: /etc/rc.conf_mount_ro
7. exit
Now you need to add a cron job to automatically run this every 5 minutes..
8. Go into pfSense web interface - and select:
	-   Packages (under System)
	-   Cron
	-   Select "+" and install Cron.
9. Then go into Cron (under Services)
10. Click "+" and add
minute: 5  
hours: *  
mday: *  
month: *  
wday: *  
(who): root  
command: /usr/local/bin/ping-check.sh

Click "Save"


## Instructions to setup mail notifications
...work in progress
