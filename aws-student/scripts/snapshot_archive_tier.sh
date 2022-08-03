#!/usr/bin/env zsh
# aws ec2 describe-snapshots --filters Name=storage-tier,Values=archive --region=us-west-2 

# d=$(date +'%Y-%m-%d' -d '15 days ago')

aws ec2 describe-snapshots \
    --filters Name=storage-tier,Values=archive \
    --query "Snapshots[?(StartTime<='2021-03-31')].[SnapshotId]" \
    --region=us-west-2
