import boto3


def lambda_handler(event, context):

    dynamodb = boto3.client('dynamodb', region_name='us-east-2')

    tables = dynamodb.list_tables()['TableNames']

    for t in tables:
        dynamodb.table.update(
            AttributeDefinitions=[
                {
                    'AttributeName': t,
                    'AttributeType': 'S'
                },
            ],
            BillingMode='PAY_PER_REQUEST'
        )
