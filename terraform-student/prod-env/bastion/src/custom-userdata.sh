#!/bin/sh
  # Assosiate elastic ip 
  sudo apt update -y
  sudo apt install awscli -y
  instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  allocated_eip=1.1.1.1.21
  REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
  aws ec2 associate-address --instance-id $instance_id --public-ip $allocated_eip --region $REGION