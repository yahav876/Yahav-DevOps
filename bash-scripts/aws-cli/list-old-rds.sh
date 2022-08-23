#!/bin/sh

# Profiles list
declare -a PROFILES=("2013" "2019" "2017" "playground-vidaa")
# Regions list
declare -a REGIONS=("eu-north-1" "ap-south-1" "eu-west-3" "eu-west-2" "eu-west-1" "ap-northeast-3" "me-south-1" "ap-northeast-2" "ap-northeast-1" "sa-east-1" "ca-central-1" "ap-east-1" "ap-southeast-1" "ap-southeast-2" "eu-central-1" "us-east-1" "us-east-2" "us-west-1" "us-west-2")


# Iterate through all profiles and regions
for p in "${PROFILES[@]}"
    do
    echo "Searching RDS-MySql versions older than 5.7.31 & 8.0.21 in ${p}..."
    for r in "${REGIONS[@]}"
    do
    echo $r
    # List RDS-MySql versions older than 5.7.31 ARN's 
    OUTPUT=`aws rds describe-db-instances --region=$r --profile=$p --output json --query "DBInstances[?EngineVersion <= '5.7.31'].[Engine=='mysql',DBInstanceArn,EngineVersion]"`
    echo "RDS older than 5.7.31"
    echo $OUTPUT
    # List RDS-MySql versions older than 8.0.21 ARN's
    OUTPUT2=`aws rds describe-db-instances --region=$r --profile=$p --output json --query "DBInstances[?EngineVersion <= '8.0.21'].[Engine=='mysql',DBInstanceArn,EngineVersion]"`
    echo "RDS older than 8.0.21"
    echo $OUTPUT2
    done
done