import boto3
import os
import time

def lambda_handler(event, context):
    logs = boto3.client('logs')
    log_group_name = os.environ['LOG_GROUP_NAME']
    bucket_name = os.environ['S3_BUCKET']

    from_time = int((time.time() - 3600) * 1000)  # 1시간 전
    to_time = int(time.time() * 1000)             # 현재 시간

    task_name = "export-" + str(int(time.time()))

    response = logs.create_export_task(
        logGroupName=log_group_name,
        fromTime=from_time,
        to=to_time,
        destination=bucket_name,
        destinationPrefix="exported",
        taskName=task_name
    )

    print("Export task created:", response['taskId'])
