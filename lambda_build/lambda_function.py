import os
import json
import gzip
import base64
import requests

def lambda_handler(event, context):
    try:
        # 압축된 로그 데이터 디코딩 및 JSON 파싱
        cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))

        # 온프레미스 API URL (환경 변수로부터)
        url = os.environ.get("ONPREM_API_URL", "http://172.30.192.49:8000/logs")

        for log_event in cw_data['logEvents']:
            log_message = log_event.get("message", "")
            
            response = requests.post(
                url,
                json={"log": log_message},
                timeout=3
            )
            print(f"✅ Sent log: {log_message.strip()} | Response: {response.status_code}")

    except Exception as e:
        print(f"❌ Error in lambda_handler: {str(e)}")

    return {'statusCode': 200}
