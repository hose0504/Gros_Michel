import json
import gzip
import base64
import requests

def lambda_handler(event, context):
    cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))
    
    for log_event in cw_data['logEvents']:
        log_message = log_event.get("message", "")
        try:
            response = requests.post(
                "http://<온프레미스_IP>:8000/logs",  # ✅ 여기에 실제 온프레미스 서버 IP 입력
                json={"log": log_message},
                timeout=3
            )
            print(f"Sent log. Response: {response.status_code}")
        except Exception as e:
            print(f"❌ Failed to send log: {e}")

    return {'statusCode': 200}
