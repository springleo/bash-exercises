#!/bin/bash

# Configuration
THRESHOLD=80                      # Disk usage threshold percentage
LOG_FILE="/var/log/disk_usage.log" # Log file to store alerts
EMAIL="mikkilimanohar@gmail.com"          # Email to send alerts
HOSTNAME=$(hostname)               # Server hostname

# Function to send an alert email
send_email() {
    local filesystem=$1
    local usage=$2
    mail -s "Disk Usage Alert on $HOSTNAME" "$EMAIL" <<EOF
Warning: Disk usage on $HOSTNAME has exceeded the threshold.

Filesystem: $filesystem
Usage: $usage%

Please take necessary actions to free up space.
EOF
}
# echo ${x/\%/}
# Monitor disk usage
while read -r filesystem size used avail percent mountpoint; do
    usage=${percent/\%/} # Strip the '%' sign
    if (( usage > THRESHOLD )); then
        # Log the alert
        echo "$(date): WARNING - $filesystem is at $usage% usage" >> "$LOG_FILE"
        # Send an alert email
        send_email "$filesystem" "$usage"
    fi
#done < <(df -h --output=source,size,used,avail,pcent,target | tail -n +2)
done < <(df -h )

# End of script

