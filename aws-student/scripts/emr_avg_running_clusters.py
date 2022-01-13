#!/usr/bin/env python3
import boto3
from datetime import datetime

## Initiate specific Region
boto3 = boto3.session.Session(region_name='us-east-1')
## Initiate EMR client 
emr = boto3.client('emr')

## Iterate EMR clusters with 'TERMINATED' state. 
page_iterator = emr.get_paginator('list_clusters').paginate(
    ClusterStates=['TERMINATED']
)

s = []

## Function to call all EMR clusters and get there Timeline status to calculate Avg time they were running.
def emr_clusters(page_iterator):
    for page in page_iterator:
        
        for item in page['Clusters']:
            start= item['Status']['Timeline']['CreationDateTime']
            end = item['Status']['Timeline']['EndDateTime']

            s.append((end-start).total_seconds())

    print('The avg time of EMR clusters in minutes:')
    print((sum(s)/len(s))/60)

emr_clusters(page_iterator)


