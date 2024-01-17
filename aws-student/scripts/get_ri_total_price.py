import boto3
from boto3.session import Session
from collections import defaultdict

accounts = ['default', '2017', ]

def get_total_upfront_cost(service, profile):
    session = Session(profile_name=profile)
    client = session.client(service)

    # Fetch reserved instances
    if service == 'ec2':
        instances = client.describe_reserved_instances()['ReservedInstances']
        instance_count_key = 'InstanceCount'
        instance_type_key = 'InstanceType'
    elif service == 'rds':
        instances = client.describe_reserved_db_instances()['ReservedDBInstances']
        instance_count_key = 'DBInstanceCount'
        instance_type_key = 'DBInstanceClass'
    elif service == 'elasticache':
        instances = client.describe_reserved_cache_nodes()['ReservedCacheNodes']
        instance_count_key = 'CacheNodeCount'
        instance_type_key = 'CacheNodeType'
    elif service == 'es':
        instances = client.describe_reserved_elasticsearch_instances()['ReservedElasticsearchInstances']
        instance_count_key = 'ElasticsearchInstanceCount'
        instance_type_key = 'ElasticsearchInstanceType'

    # Calculate total upfront cost and organize by purchase month
    monthly_costs = defaultdict(float)
    monthly_instance_types = defaultdict(set)
    for ri in instances:
        if ri['State'] == 'active':
            instance_count = ri.get(instance_count_key, 1)
            cost = ri['FixedPrice'] * instance_count
            purchase_month = ri.get('StartTime').strftime('%Y-%m') if service != 'ec2' else ri.get('Start').strftime('%Y-%m')
            instance_type = ri.get(instance_type_key, 'N/A')
            monthly_costs[purchase_month] += cost
            monthly_instance_types[purchase_month].add(instance_type)

    return monthly_costs, monthly_instance_types


def calculate_costs_for_profiles(profiles, services):
    for profile in profiles:
        print(f"\nProfile: {profile}")
        for service in services:
            monthly_costs, monthly_instance_types = get_total_upfront_cost(service, profile)
            total_cost = sum(monthly_costs.values())

            print(f"\n{service.upper()} Reserved Instances Costs and Instance Types for Profile {profile}:")
            for month, cost in monthly_costs.items():
                instance_types = ', '.join(monthly_instance_types[month])
                print(f"  {month}: ${cost:.2f}, Instance Types: {instance_types}")

            print(f"Total Cost for {service.upper()} Reserved Instances: ${total_cost:.2f}")

# List of AWS profiles and services
profiles = ['default', '2017', '2013']
services = ['ec2', 'rds', 'elasticache', 'es']

calculate_costs_for_profiles(profiles, services)
# # Calculate, print total upfront costs per month, total costs, and instance types
# for service in ['ec2', 'rds', 'elasticache', 'es']:
#     monthly_costs, monthly_instance_types = get_total_upfront_cost(service)
#     total_cost = sum(monthly_costs.values())

#     print(f"\n{service.upper()} Reserved Instances Costs and Instance Types:")
#     for month, cost in monthly_costs.items():
#         instance_types = ', '.join(monthly_instance_types[month])
#         print(f"  {month}: ${cost:.2f}, Instance Types: {instance_types}")

#     print(f"Total Cost for {service.upper()} Reserved Instances: ${total_cost:.2f}")
