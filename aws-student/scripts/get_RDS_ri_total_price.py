import boto3

# Create RDS client
rds = boto3.client('rds')

# Describe all reserved DB instances
response = rds.describe_reserved_db_instances()

# Filter for active reserved DB instances
active_rds = [ri for ri in response['ReservedDBInstances'] if ri['State'] == 'active']

# Calculate total price
total_price = sum(ri['FixedPrice'] for ri in active_rds)

print(f"Total price for active RDS Reserved Instances: ${total_price}")
