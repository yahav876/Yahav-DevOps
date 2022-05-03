#!/bin/sh

# Profiles list
declare -a PROFILES=("2013")
# Regions list
declare -a REGIONS=("eu-north-1" "ap-south-1" "eu-west-3" "eu-west-2" "eu-west-1" "ap-northeast-3" "me-south-1" "ap-northeast-2" "ap-northeast-1" "sa-east-1" "ca-central-1" "ap-east-1" "ap-southeast-1" "ap-southeast-2" "eu-central-1" "us-east-1" "us-east-2" "us-west-1" "us-west-2")


# Iterate through all profiles and regions
for p in "${PROFILES[@]}"
    do
    echo "Searching Python 3.6 lambda functions in ${p}..."
    for r in "${REGIONS[@]}"
    do
    echo $r
    # List python 3.6 lambda functions ARN's 
    OUTPUT=`aws lambda list-functions --function-version ALL --region=$r --profile=$p --output text --query "Functions[?Runtime=='python3.6'].FunctionArn"`
    echo $OUTPUT
    done
done

