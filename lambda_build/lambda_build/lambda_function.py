import json
import gzip
import base64
import requests

def lambda_handler(event, context):
    try:
        # 압축 해제
        cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))

        for log_event in cw_data.get('logEvents', []):
            log_message = log_event.get("message", "")
            try:
                response = requests.post(
                    "http://172.30.192.49:8000/receive_logs",  # ⚠️ FastAPI의 실제 경로 확인
                    json={"log": log_message},
                    timeout=3
                )
                print(f"✅ Sent log. Response: {response.status_code}")
            except Exception as e:
                print(f"❌ Failed to send log: {e}")

    except Exception as outer:
        print(f"❌ Failed to decode or parse event: {outer}")

    return {'statusCode': 200}
