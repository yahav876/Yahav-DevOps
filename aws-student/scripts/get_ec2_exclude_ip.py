#!/opt/homebrew/bin/python3

import boto3




ec2_client = boto3.client('ec2', region_name='us-west-2')
# regions = [region['RegionName']
#            for region in ec2_client.describe_regions()['Regions']]
instances = ec2_client.describe_instances(
Filters=[
    {
        'Name': 'instance-state-name',
        'Values': [
            'running',
        ]
    },
    ],
    MaxResults=150
)

ignore_net = ['192.169.1.', '192.168.1.', '192.168.2.', '192.168.10.']

for i in instances['Reservations']:
    for n in i['Instances'][0]['NetworkInterfaces']:
        if n['PrivateIpAddress']:
            print('ok')
