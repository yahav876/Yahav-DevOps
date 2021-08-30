import boto3
import os
import json
from datetime import datetime


TABLE_NAME = os.environ['TABLE_NAME']
QUEUE_NAME = os.environ['QUEUE_NAME']
MAX_QUEUE_MESSAGES = os.environ['MAX_QUEUE_MESSAGES']

sqs = boto3.resource('sqs')
dynamodb = boto3.resource('dynamodb')

table = dynamodb.Table['TABLE_NAME']

def lambda_handler(event, context):

    # Get queue by name and Receive the messages.
    queue = sqs.get_queue_by_name(QueueName=QUEUE_NAME)

    print("ApproximateNumberOfMessages:", queue.attributes.get('ApproximateNumberOfMessages'))

    for message in queue.received_message(MaxNumberOfMessages=int(MAX_QUEUE_MESSAGES)):
        print(message)

    insert = table.put_item(item={
        'MessageId': message.message_id,
        'Body': message.body,
        'Timestamp': datetime.now().isoformat()
        })

    print("Wrote message to dynamoDB table: ", json.dumps(insert))

    # Delete The SQS message
    message.delete()
    print("Deleting Message from queue" + message.message_id)
    # for record in event['Records']:
    #     que_message = record['sqs']['message']['body']
    #     message_db = json.dumps(que_message)
    #     insert = table.put_item(item=message_db)
    #     insert_message = dynamodb.put_item(table=TABLE_NAME, item=message_db)
        
        