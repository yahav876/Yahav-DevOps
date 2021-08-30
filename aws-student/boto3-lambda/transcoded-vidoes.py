import boto3
import os
import datetime import datetime
import urllib
import json


s3 = boto3.resource('s3')
transcoded = boto3.client('elastictranscoder')

PIPELINE_ID = os.environ['PIPELINE_ID']
SOURCE_BUCKET = os.environ['SOURCE_BUCKET']
TRANSCODED_BUCKET = os.environ['TRANSCODED_BUCKET']

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    # Get key name from event.
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'] , encoding='utf-8')
        filename = os.path.splitext(key)[0]

    # Create transcoded job.
    job = transcoded.create_job(
        PipelineId=PIPELINE_ID,

    )