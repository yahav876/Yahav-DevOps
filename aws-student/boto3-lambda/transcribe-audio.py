import boto3



s3 = boto3.client('s3')
transcribe = boto3.client('transcribe')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        url = "https://s3.amazonaws.com/{0}/{1}".format(bucket_name, key)

        filename = key.replace("music/", '')
        response = transcribe.start_transcription_job(
            TranscriptionJobName=filename,
            LanguageCode='en-US',
            Media={'MediaFileUri': url},
            MediaFormat='mp3',)
        print(response)

        filename = key.replace("music/", '')
        response = transcribe.start_transcription_job(
            TranscriptionJobName=filename,
            LanguageCode='en-US',
            Media={'MediaFileUri': url},
            MediaFormat='mp3',)
        print(response)
