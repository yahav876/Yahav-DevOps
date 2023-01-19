#!/opt/homebrew/bin/python3

import boto3

client = boto3.client('ec2', region_name='us-west-2')

sg_original_ids = [
"sg-01fc02caaf00b561e", 
"sg-0855acabd74007ae4",
"sg-7713e70d",
"sg-0e2288d11ccbb41e9",
"sg-0f65b1a3969abd868"
]
sg_new_id = ["sg-0b39a6e251ee8b7ee"]

instance_id = "i-071519e6205b79a62"


modify_sg = client.modify_instance_attribute(
    InstanceId = instance_id,
    Groups = sg_original_ids
)
