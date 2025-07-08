import json
import gzip
import base64
import requests
import os  # ✅ 환경변수 사용

def lambda_handler(event, context):
    cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))

    onprem_url = os.environ.get("ONPREM_API_URL")  # ✅ 환경변수로부터 온프레미스 주소 획득

    for log_event in cw_data['logEvents']:
        log_message = log_event.get("message", "")
        try:
            response = requests.post(
                onprem_url,
                json={"log": log_message},
                timeout=3
            )
            print(f"Sent log. Response: {response.status_code}")
        except Exception as e:
            print(f"❌ Failed to send log: {e}")

    return {'statusCode': 200}
