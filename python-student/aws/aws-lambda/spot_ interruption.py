import re
import boto3


def lambda_handler(event, context):

    command = 'sudo docker exec default_database_1 /bin/sh -c /root/spot-interruption.sh'
    ssm = boto3.client('ssm', region_name='us-east-1')
    ssmresponse = ssm.send_command(Targets=[
        {
            'Key': 'tag:Name',
            'Values': [
                'mediawiki',
            ]
        },
    ], DocumentName='AWS-RunShellScript', Parameters={'commands': [command]})
