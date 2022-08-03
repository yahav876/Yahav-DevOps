
#!/opt/homebrew/bin/python3

from operator import contains
from tracemalloc import Snapshot
from unittest import result
from urllib import response
import boto3
import itertools
import datetime

ec2_client = boto3.client('ec2' , region_name="us-west-2")
# regions = [region['RegionName']
#             for region in ec2_client.describe_regions()['Regions']]

# for region in regions:
#     ec2 = boto3.client('ec2', region_name=region)
# Get only running instances

snapdate = '2022-01-01'
snapshots = ec2_client.describe_snapshots(
    Filters=[{'Name': 'owner-id',
            'Values': ['675549661734']}],OwnerIds=["self"])


# print(snapshots)
# count = 0
for s in snapshots['Snapshots']:
    print(s["SnapshotId"])

    # snap_date = datetime.datetime.strftime(s['StartTime'], '%Y-%m-%d')
    # if snapdate > snap_date:
        # print(s["SnapshotId"])
    # count = count + s["VolumeSize"] 
    # print[s]
# print(count)

        # volID = v['VolumeId']
        # print(v['VolumeId'])
        # print("Deleting un-atacched ebs volume: {}".format(v['VolumeId']))
        # delete = ec2.delete_volume(VolumeId=v['VolumeId'])
        # snapshots = ec2.create_snapshot(
        #     VolumeId=volID,
        #     TagSpecifications=[
        #         {
        #             'ResourceType': 'snapshot',
        #             'Tags': [
        #                 {
        #                     'Key': 'cost-optimization',
        #                     'Value': "vidaa-israel"
        #                 }
        #             ]
        #         }
        #     ]
            # Filters=[
            #     {
            #         'Name': 'volume-id',
            #         'Values': [volumeID],
            #     }
            # ]
        # )
    # for s in snapshots['Snapshots']:
    #     ec2.create_tags(
    #         Resources=[s['SnapshotId']],
    #         Tags=[
    #             {
    #                 'Key': 'cost-optimization',
    #                 'Value': 'vidaa-israel'
    #             },
    #         ]

    #     )
# print(snapshots)

# for s in snapshots['Snapshots']:
#     if "2022-06-16" in  s['StartTime']:
#         print(s)

    # # for v in volumes:
    # if volumes['Volumes'] == []:
    #     pass
    # else:
    #     for v in volumes['Volumes']:
    #         print("Creating snapshot for: {} ".format(v['VolumeId']))
    #         snapshot = ec2.create_snapshot(VolumeId=v['VolumeId'])
    #         print("Tagging recent snapshot of ebs volume: {}".format(v['VolumeId']))
    #         # print("Deleting un-atacched ebs volume: {}".format(v['VolumeId']))
    #         # delete = ec2.delete_volume(VolumeId=v['VolumeId'])


#     return event , region

# result(lambda_handler(1,2))


# def main():
#     lambda_handler()


# if __name__ == '__main__':
#     main()
