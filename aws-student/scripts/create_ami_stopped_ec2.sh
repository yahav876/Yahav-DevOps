#!/bin/bash

# Set AWS CLI to use the specific profile
export AWS_PROFILE=2017

# Disable AWS CLI paging behavior
export AWS_PAGER=""

# Get the IDs and Names of all stopped EC2 instances
instances_info=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=stopped" \
    --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0]]" \
    --output text)

# Check if there are any stopped instances
if [ -z "$instances_info" ]; then
    echo "No stopped instances found."
    exit 0
fi

# Process each instance
while read -r instance_id instance_name; do
    # If instance name is empty, use the instance ID
    if [ -z "$instance_name" ]; then
        instance_name=$instance_id
    fi

    # Generate a unique name for the AMI
    ami_name="backup-ec2-stopped-${instance_name}-$(date +%Y%m%d%H%M%S)"

    # Create an image for the instance with a tag
    echo "Creating image for instance $instance_id ($instance_name) with name $ami_name..."
    aws ec2 create-image \
        --instance-id "$instance_id" \
        --name "$ami_name" \
        --no-reboot \
        --tag-specifications "ResourceType=image,Tags=[{Key=Name,Value=$ami_name}]"

    # Add a delay to avoid throttling (optional, adjust as needed)
    sleep 2

done <<< "$instances_info"

echo "Image creation process initiated for all stopped instances."

