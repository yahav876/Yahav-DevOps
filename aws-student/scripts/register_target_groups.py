#!/usr/bin/env python3


import boto3

client = boto3.client('elbv2')

response = client.describe_target_groups()
for t in response['TargetGroups']:
    if t['TargetType'] == 'ip':
        pass
    else:
        register = client.register_targets(
            TargetGroupArn=t['TargetGroupArn'],
            Targets=[
                {
                'Id': 'i-00d05a3ae44e14bd6',
                'Port': t['Port']
                }
            ]
        )
    
    
