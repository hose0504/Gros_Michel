import json
import gzip
import base64
import requests

def lambda_handler(event, context):
    cw_data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))
    
    for log_event in cw_data['logEvents']:
        try:
            requests.post("http://192.168.100.10:8080/logs", json=log_event, timeout=3)
        except Exception as e:
            print(f"Failed to send log: {e}")
            
    return {'statusCode': 200}
