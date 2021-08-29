import boto3
import os


dynamodb = boto3.resource('dynamodb')

table = dynamodb