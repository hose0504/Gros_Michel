import json
import gzip
import base64
import requests

def lambda_handler(event, context):
    cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))
    
    for log_event in cw_data['logEvents']:
        # 로그 메시지를 추출
        log_message = log_event.get("message", "")
        try:
            # FastAPI가 기대하는 구조로 전송
            response = requests.post(
             "http://172.30.192.49:8000/logs",  # ✅ EC2의 프라이빗 IP
             json={"log": log_message},
             timeout=3
            )

            print(f"Sent log. Response: {response.status_code}")
        except Exception as e:
            print(f"❌ Failed to send log: {e}")

    return {'statusCode': 200}
