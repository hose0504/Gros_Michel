import json
import urllib3

http = urllib3.PoolManager()
ONPREM_URL = "http://112.221.198.140:10005/receive_logs"

def lambda_handler(event, context):
    try:
        print(f"Received event: {json.dumps(event)}")
        
        # CloudWatch 로그 이벤트는 base64 + gzip 되어있는 경우가 있음
        # 여기서는 단순 이벤트로 가정
        log_data = json.dumps(event)
        
        # POST to on-prem server
        response = http.request(
            "POST",
            ONPREM_URL,
            body=json.dumps({"log": log_data}),
            headers={"Content-Type": "application/json"}
        )
        
        print(f"On-prem response status: {response.status}")
        print(f"On-prem response data: {response.data.decode()}")
        
        return {
            'statusCode': response.status,
            'body': response.data.decode()
        }

    except Exception as e:
        print(f"Error in lambda_handler: {e}")
        return {
            'statusCode': 500,
            'body': str(e)
        }
