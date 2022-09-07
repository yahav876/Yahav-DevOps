#!/opt/homebrew/bin/python3
import boto3



route53 = boto3.client('route53')
elb = boto3.client('elbv2')


def main(zone_id="Z0417720YU4MKKBPN5X2"):

    list_elb = elb.describe_load_balancers()
    elb_dns_names = [e['DNSName'] for e in list_elb['LoadBalancers']]

    list_records = route53.list_resource_record_sets(HostedZoneId=zone_id,MaxItems="300")
    record_values = [record['ResourceRecords'] for record in list_records['ResourceRecordSets']]
    # records_value = [v['Value'] for v in list_records]
    # print(records_values)
    # print(dns_names)
    # for r in list_records['ResourceRecordSets']:
    #     print(r['ResourceRecords'])
    for name in elb_dns_names:
        # print(name)
        # # records_values = [record['ResourceRecords'] for record in list_records['ResourceRecordSets']]
    # for record in record_values:
    #     # print(record)
        if name in record_values:
            print(name)




if __name__ == '__main__':
    main()