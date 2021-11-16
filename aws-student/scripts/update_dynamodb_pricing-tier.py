from logging import Filter
import boto3

dynamodb = boto3.client('dynamodb', region_name='us-east-2')

def lambda_handler(event, context):


    tables = dynamodb.list_tables()['TableNames']
    
    for t in tables:

        try:
            response = dynamodb.update_table(
                TableName=t,
                BillingMode='PAY_PER_REQUEST'
            )
            
        except dynamodb.exceptions.ResourceInUseException as e:
            pass

while True:
    second_list = dynamodb.list_tables(ExclusiveStartTableName='prod_6365a174-2aee-40b7-a63c-b4a57e5c3984')['TableNames']
    for t2 in second_list:
        response2 = dynamodb.update_table(
                TableName=t2,
                BillingMode='PAY_PER_REQUEST'
                )
