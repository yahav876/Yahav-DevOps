#!/bin/bash

# Set AWS CLI to use the specific profile
export AWS_PROFILE=default

# Disable AWS CLI paging behavior
export AWS_PAGER=""

# Get the IDs and Names of EC2 instances with the specified tag
instances_info=$(aws ec2 describe-instances \
    --filters "Name=tag:ManagedBy,Values=terraform" "Name=instance-state-name,Values=running,stopped" \
    --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0]]" \
    --output text)

# Check if there are any matching instances
if [ -z "$instances_info" ]; then
    echo "No instances with the specified tag found."
    exit 0
fi

# Process each instance
while read -r instance_id instance_name; do
    # If instance name is empty, use the instance ID
    if [ -z "$instance_name" ]; then
        instance_name=$instance_id
    fi

    # Generate a name for the AMI
    ami_name="${instance_name}-final-image"

    # Create an image for the instance
    echo "Creating image for instance $instance_id ($instance_name) with name $ami_name..."
    aws ec2 create-image \
        --instance-id "$instance_id" \
        --name "$ami_name" \
        --tag-specifications "ResourceType=image,Tags=[{Key=Name,Value=$ami_name}]"

    # Add a delay to avoid throttling (optional, adjust as needed)
    sleep 2

done <<< "$instances_info"

echo "Image creation process initiated for tagged instances."
