# import boto3

# def lambda_handler(event, context):
#     ec2 = boto3.resource('ec2')

#     # Filter for instances with the specific tag
#     filters = [
#         {'Name': 'tag:ManagedBy', 'Values': ['terraform']},
#         {'Name': 'instance-state-name', 'Values': ['running']}
#     ]

#     # Retrieve instances based on the filter
#     instances = ec2.instances.filter(Filters=filters)

#     # List to hold instance IDs for logging
#     instance_ids = []

#     for instance in instances:
#         instance_ids.append(instance.id)
#         instance.stop()

#     print("Stopped instances: " + ", ".join(instance_ids))

#     return {
#         'statusCode': 200,
#         'body': f'Stopped instances: {instance_ids}'
#     }


import boto3

# def lambda_handler(event, context):
ec2 = boto3.resource('ec2')

    # Filter for instances with the specific tag
filters = [
    {'Name': 'tag:ManagedBy', 'Values': ['terraform']}
    # {'Name': 'instance-state-name', 'Values': ['stopped']}
]

# Retrieve instances based on the filter
instances = ec2.instances.filter(Filters=filters)

# List to hold instance IDs for logging
instance_ids = []

for instance in instances:
    instance_ids.append(instance.id)
    instance.start()

print("Started instances: " + ", ".join(instance_ids))

    # return {
    #     'statusCode': 200,
    #     'body': f'Started instances: {instance_ids}'
    # }
