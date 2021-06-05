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
In this section we will setup email reports which will be generated once a day and send to email at midnight (00:01)

1. ### Setup your email accounts for notiications
	- #### System > Advanced > Notifications > E-Mail
	- if you want to use gmail account then setup should look like this:
		- Disable SMTP = UNCHECK
		- E-Mail server = smtp.gmail.com
		- SMTP Port of E-Mail server = 465 (don't forget to allow this port in FW)
		- Connection timeout to E-Mail server = 19
		- Secure SMTP Connection = CHECK
		-  Validate SSL/TLS = CHECK
		-  From e-mail address = email which you want to send emails from
		-  Notification E-Mail address = notification email destination
		-  Notification E-Mail auth password = password for "From e-mail address"
		-  Notification E-Mail auth mechanism = PLAIN
2. ### Setup Email report
	- #### Staus > Email Reports
	- Add New Report
		- Enter Description
		- Choose frequency and on which day report should be generated
		- In section **Included Commands** enter your command which result will be shown in your report
			- In my case I'm saving ping results in "/var/log/scripts/ping-check-result.log" so I'll use this command: `/bin/cat /var/log/scripts/ping-check-result.log`
		- Save
3. ### Deleting report content from previous day
	- If you are running reports everyday as I am then you may need to clear old report data each day because if you won't then you'll have data from previous days which may not be desirable. In this case you can solve this problem with setting up a script and execute it by cron everyday at 00:02

This is that simple script to remove old data from report:
It will overwrite report lines and print current date in header
``` bash
#!/bin/sh

now=$(date +"%m-%d-%y")
echo "Start of day $now" > /var/log/scripts/ping-check-result.log
```
