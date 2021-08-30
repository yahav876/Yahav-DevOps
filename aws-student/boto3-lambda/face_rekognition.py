import boto3
import os

TABLE_NAME = os.environ['TABLE_NAME']

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table[TABLE_NAME]

s3 = boto3.client('s3')
rekognition = boto3.client('rekognition')

def lambda_handler(event, context):

    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        object = s3.object(bucket_name, key)
        image = object.get()['Body'].read()

        response = rekognition.recognize_celebrities(Image={'Bytes': image})
        
        names = []
        for celeb in response['CelebrityFaces']:
            name = celeb['Name']
            print('Nmae: ' + name)
            names.append(name)

        print('Saving Face data into dynamoDB table:', TABLE_NAME)

        response = table.put_item(
            Item={
                'key': key,
                'names': names,
            }
        )
        

