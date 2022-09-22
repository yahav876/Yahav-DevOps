#!/opt/homebrew/bin/python3
# from tkinter import _ExceptionReportingCallback
from urllib import response
from xml.etree.ElementTree import Comment
import boto3


route53 = boto3.client('route53')
elb = boto3.client('elbv2')


def main(zone_id="Z0417720YU4MKKBPN5X2"):

    list_elb = elb.describe_load_balancers()

    list_records = route53.list_resource_record_sets(
        HostedZoneId=zone_id, MaxItems="300")

    for record in list_records['ResourceRecordSets']:
        if record['Type'] == "CNAME":
            for lb in list_elb['LoadBalancers']:
                if lb['DNSName'] in record['ResourceRecords'][0]['Value']:

                # Delete CNAME record
                    delete_record = route53.change_resource_record_sets(
                        HostedZoneId=zone_id,
                        ChangeBatch={
                            'Changes': [
                                {
                                    'Action': 'DELETE',
                                    'ResourceRecordSet': {
                                        'Name': record['Name'][:-1],
                                        'Type': 'CNAME',
                                        'TTL': 300,
                                        'ResourceRecords': [
                                            {
                                                'Value': record['ResourceRecords'][0]['Value']
                                            },
                                        ],
                                    },
                                },
                            ]
                        }

                    )
                    # Create Alias record
                    create_record = route53.change_resource_record_sets(
                        HostedZoneId=zone_id,
                        ChangeBatch={
                            'Changes': [
                                {
                                'Action': 'CREATE',
                                    'ResourceRecordSet': {
                                        'Name': record['Name'][:-1],
                                        'Type': 'A',
                                        'AliasTarget':
                                            {
                                                'HostedZoneId': lb['CanonicalHostedZoneId'],
                                                'DNSName': lb['DNSName'] + ".",
                                                'EvaluateTargetHealth': True

                                            },

                                    },
                                },
                            ]
                        }

                    )


if __name__ == '__main__':
    main()


# 'NextRecordName': 'param-ui-oc.vidaahub.com.', 'NextRecordType': 'CNAME',