#!/bin/bash

# Set the threshold for disk utilization (90% in this case)
threshold=90
# Get the current disk utilization percentage for the specified filesystem
disk_utilization=$(df -h | grep "/dev/xvda1" | awk '{print $5}' | sed 's/%//')

# Check if the disk utilization is above the threshold
if [ "$disk_utilization" -gt "$threshold" ]; then
    # Delete files from the specific directory
    echo "Disk utilization is above $threshold%. Deleting files from /etc/confluent/rs-connect-cluster/logs..."
    find /etc/confluent/rs-connect-cluster/logs -type f -daystart -mtime +10 -delete \;
    echo "Files deleted successfully."
else
    echo "Disk utilization is below $threshold%. No action needed."
fi
