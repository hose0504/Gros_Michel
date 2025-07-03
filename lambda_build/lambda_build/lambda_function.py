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
                    " http://112.221.198.140:10005/receive_logs",  # ⚠️ FastAPI의 실제 경로 확인
                    json={"log": log_message},
                    timeout=3
                )
                print(f"✅ Sent log. Response: {response.status_code}")
            except Exception as e:
                print(f"❌ Failed to send log: {e}")

    except Exception as outer:
        print(f"❌ Failed to decode or parse event: {outer}")

    return {'statusCode': 200}
