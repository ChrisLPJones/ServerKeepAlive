#!/bin/bash

routerSshUserName="routerSshUserName"  # SSH username for the router
serverUserName="serverUserName"        # Username to run the commands as on the server
routerIP="192.168.0.1"                 # IP address of the router
clientName="Windows PC"                # Name of the client computer
clientIP="192.168.0.100"               # IP address of the client computer

while :
do
  echo "$(date +%d/%m/%y' - '%r) - Checking if clients are online." | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
  clientStatus=$(ping $clientIP -w 1 | grep -o "1 received")
  if [ "$clientStatus" = "1 received" ]
  then
    echo "$(date +%d/%m/%y' - '%r) - $clientName is Online." | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
    echo "$(date +%d/%m/%y' - '%r) - Keep-Alive and recheck in 10 minutes." | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
    echo "" | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
    sleep 600
  else
    echo "$(date +%d/%m/%y' - '%r) - No clients are online." | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
    echo "$(date +%d/%m/%y' - '%r) - Suspending." | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
    echo "" | runuser -u $serverUserName -- ssh $routerSshUserName@$routerIP -T 'cat >> /jffs/scripts/server.log'
    systemctl suspend    
    sleep 100
  fi
done