import boto3
import urllib3
import os

s3 = boto3.client('s3')
http = urllib3.PoolManager()

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        obj = s3.get_object(Bucket=bucket, Key=key)
        log_data = obj['Body'].read().decode('utf-8')

        response = http.request(
            "POST",
            url=os.environ['ONPREM_API_URL'],
            body=log_data.encode('utf-8'),
            headers={"Content-Type": "application/json"}
        )

        print("Response status from OnPrem:", response.status)

    return {"statusCode": 200, "body": "Success"}
