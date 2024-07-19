# Server Keep Alive

This Bash script is designed to save server resources by putting the server to sleep when no clients are active on the network. It works hand-in-hand with [WakeServer](https://github.com/ChrisLPJones/WakeServer), ensuring that the server is active only when needed.


## How It Works

The script runs in an infinite loop (`while :`) and performs the following actions:

1. Logs the current date and time with a message indicating that it is checking if clients are online.
2. Pings the specified client IP address and checks if the response indicates that the client is online.

### If the client is online:
- Logs the current date and time with a message indicating that the client is online.
- Logs a keep-alive message and waits for 10 minutes (`sleep 600`) before rechecking.

### If the client is not online:
- Logs the current date and time with a message indicating that no clients are online.
- Logs a suspending message and suspends the system (`systemctl suspend`).
- Waits for 100 seconds (`sleep 100`) before rechecking.



## Prerequisites

- SSH public key authentication access to the router
- A router that supports custom scripts (e.g., with jffs partition)
- runuser and ssh commands available on the server
- systemctl available for system suspension

## Installation

### 1. Clone the repository:
```bash
git clone https://github.com/chrislpjones/serverkeepalive.git
cd serverkeepalive
```
### 2. Edit the script:

Open the serverkeepalive.sh file and update the following variables with your actual values:

```bash
routerSshUserName="yourRouterSshUserName"  # SSH username for the router
serverUserName="yourServerUserName"        # Username to run the commands as on the server
routerIP="yourRouterIP"                    # IP address of the router
clientName="yourClientName"                # Name of the client computer
clientIP="yourClientIP"                    # IP address of the client computer

```
**3. Make the script executable:**
```bash
chmod +x serverkeepalive.sh
```

## Running the Script at Boot
To ensure the script runs at boot, you can create a systemd service:

**1. Create a systemd service file:**
```bash
sudo nano /etc/systemd/system/serverkeepalive.service
```
**2. Add the following content to the file:**
```bash
[Unit]
Description=Wake Server
After=network.target

[Service]
User=yourServerUserName
ExecStart=/path/to/your/script/serverkeepalive.sh
Restart=always

[Install]
WantedBy=multi-user.target
```
Replace /path/to/your/script/serverkeepalive.sh with the actual path to your script and yourServerUserName with the appropriate username.

**3. Reload systemd to apply the new service:**

```bash
sudo systemctl daemon-reload
```
**4. Enable the service to start on boot:**

```bash
sudo systemctl enable serverkeepalive.service
```
**5. Start the service:**
```bash
sudo systemctl start serverkeepalive.service
```
**6. Check the service status:**
```bash
sudo systemctl status serverkeepalive.service
```
## Logging
The script logs various events to a log file on the router. Each log entry includes the current date and time, along with a descriptive message. The following events are logged:

* Start of the client check process
* Client online status
* Keep-alive messages
* Client offline status
* System suspension events
* The logs can be found on the router in the /jffs/scripts/server.log file.

## Notes

- Ensure the router's SSH server is configured correctly and the specified user has the necessary permissions to write to the log file.
- Make sure that `systemctl` is available and functional on the server to allow for system suspension.
- Customize the sleep durations and other parameters as needed to fit your specific requirements.
- This script is intended to work in conjunction with [WakeServer](https://github.com/ChrisLPJones/WakeServer), ensuring efficient use of server resources by waking the server only when necessary.
