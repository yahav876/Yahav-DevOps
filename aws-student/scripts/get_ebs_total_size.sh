#!/bin/bash

# Get all EBS volumes and their types and sizes
aws ec2 describe-volumes --query 'Volumes[*].[VolumeType, Size]' --output text | \
awk '
{
    typeSize[$1]+=$2
}
END {
    for (type in typeSize)
        print "Total size for type " type ": " typeSize[type] " GB"
}'

