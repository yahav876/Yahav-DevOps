#!/opt/homebrew/bin/python3
from urllib import response
from xml.etree.ElementTree import Comment
import boto3


route53 = boto3.client('route53')
elb = boto3.client('elbv2')


def main(zone_id="Z0115161285UW0N1PKIU2"):

    list_elb = elb.describe_load_balancers()
    elb_dns_names = [e['DNSName'] for e in list_elb['LoadBalancers']]

    list_records = route53.list_resource_record_sets(
        HostedZoneId=zone_id, MaxItems="300")
    record_values = [record['ResourceRecords']
                     for record in list_records['ResourceRecordSets']]
    # records_value = [v['Value'] for v in list_records]
    # print(records_values)
    # print(dns_names)
    # for r in list_records['ResourceRecordSets']:
    #     print(r['ResourceRecords'])
    # for name in elb_dns_names:
    #     print(name)
    # # records_values = [record['ResourceRecords'] for record in list_records['ResourceRecordSets']]
    # print(record_values)

    # Change record from CNAME to Alias
    response = route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            # 'Comment': 'testing',
            'Changes': [
                {
                    'Action': 'DELETE',
                    'ResourceRecordSet': {
                        'Name': 'test.vidaaclub.com',
                        'Type': 'CNAME',
                        'TTL': 300,
                        'ResourceRecords': [
                            {
                                'Value': 'hiupgrade-nginx-vidaahub-ext-c899bb89cbc3ffeb.elb.us-west-2.amazonaws.com.'
                            },
                        ],
                        # 'AliasTarget':
                        #     {
                        #         'HostedZoneId': 'Z18D5FSROUN65G',
                        #         'DNSName': 'hiupgrade-nginx-vidaahub-ext-c899bb89cbc3ffeb.elb.us-west-2.amazonaws.com.',
                        #         'EvaluateTargetHealth': True

                        #     },

                    },
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': 'test.vidaaclub.com',
                        'Type': 'A',
                        'AliasTarget':
                            {
                                'HostedZoneId': 'Z18D5FSROUN65G',
                                'DNSName': 'hiupgrade-nginx-vidaahub-ext-c899bb89cbc3ffeb.elb.us-west-2.amazonaws.com.',
                                'EvaluateTargetHealth': True

                            },

                    },
                },
            ]
        }

    )

    # for record in record_values:
    #     for test in record:
    #         print(test['Value'])
    # print(record)
    # if name in record_values:
    #     print(name)


if __name__ == '__main__':
    main()
