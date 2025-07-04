import json
import gzip
import base64
import requests
import os

def lambda_handler(event, context):
    try:
        cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))
    except Exception as e:
        print(f"❌ Failed to decode log data: {e}")
        return {'statusCode': 500}

    onprem_url = os.environ.get("ONPREM_API_URL", "http://112.221.198.140:10005/receive_logs")

    if not onprem_url:
        print("❌ ONPREM_API_URL is not set")
        return {'statusCode': 500}

    for log_event in cw_data.get('logEvents', []):
        log_message = log_event.get("message", "")
        try:
            response = requests.post(
                onprem_url,
                json={"log": log_message},
                timeout=3
            )
            print(f"✅ Sent log: {log_message.strip()} | Response: {response.status_code}")
        except Exception as e:
            print(f"❌ Failed to send log: {e}")

    return {'statusCode': 200}
