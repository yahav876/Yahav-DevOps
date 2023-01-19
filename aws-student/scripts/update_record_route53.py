#!/opt/homebrew/bin/python3
from urllib import response
from xml.etree.ElementTree import Comment
import boto3
from logging import getLogger


logger = getLogger('route53_change')

route53 = boto3.client('route53')
elb = boto3.client('elbv2')
cf = boto3.client('cloudfront')

# Replace the hosted zone ID 
def elbs(zone_id="Z0115161285UW0N1PKIU2"):

    list_elb = elb.describe_load_balancers()
    # print(list_elb['LoadBalancers'])
    list_records = route53.list_resource_record_sets(
        HostedZoneId=zone_id,
        MaxItems="300"
        # StartRecordName='param-ui-oc.vidaahub.com.vidaaclub.com.',
        # StartRecordType='CNAME'
        )
    # print(list_records)
    
    # Iterate all CNAME records and check if the ELB exist to replace it for an Alias.
    for record in list_records['ResourceRecordSets']:
        if record['Type'] == "CNAME":
            for lb in list_elb['LoadBalancers']:
                # continue
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
                    if not delete_record:
                        logger.error("Delete record failed %s", record)
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
                    if not create_record:
                        logger.error("Delete record failed %s", record)



def cloudfront(zone_id="Z0115161285UW0N1PKIU2"):

    list_cf= cf.list_distributions()
    list_records = route53.list_resource_record_sets(
    HostedZoneId=zone_id,
    MaxItems="300"
    # StartRecordName='param-ui-oc.vidaahub.com.vidaaclub.com.',
    # StartRecordType='CNAME'
    )

    for record in list_records['ResourceRecordSets']:
        if record['Type'] == "CNAME":
            for cloudfront in list_cf['DistributionList']['Items']:
                if cloudfront['DomainName'] in record['ResourceRecords'][0]['Value']:

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
                                                'HostedZoneId': "Z2FDTNDATAQYW2",
                                                'DNSName': cloudfront['DomainName'],
                                                'EvaluateTargetHealth': True

                                            },

                                    },
                                },
                            ]
                        }

                    )




if __name__ == '__main__':
    elbs()
    cloudfront()


# 'NextRecordName': 'param-ui-oc.vidaahub.com.', 'NextRecordType': 'CNAME',

