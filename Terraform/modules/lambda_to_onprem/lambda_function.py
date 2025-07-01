import json
import requests
import base64
import gzip

def lambda_handler(event, context):
    print("🔔 Lambda triggered")

    # CloudWatch 로그는 압축 + base64 로 인코딩됨
    cw_data = event['awslogs']['data']
    compressed_payload = base64.b64decode(cw_data)
    uncompressed_payload = gzip.decompress(compressed_payload)
    log_data = json.loads(uncompressed_payload)

    print(f"📄 Decoded log data: {json.dumps(log_data)}")

    # 로그 이벤트 추출
    events = log_data.get("logEvents", [])
    for evt in events:
        message = evt.get("message", "")
        payload = {
            "log": message,
            "timestamp": evt.get("timestamp")
        }

        try:
            # 온프레 서버로 POST 전송
            response = requests.post(
                "http://172.30.192.49:8080/receive_logs",
                headers={"Content-Type": "application/json"},
                data=json.dumps(payload),
                timeout=5
            )
            print(f"✅ Log sent: {response.status_code} - {response.text}")
        except Exception as e:
            print(f"❌ Error sending log: {e}")
