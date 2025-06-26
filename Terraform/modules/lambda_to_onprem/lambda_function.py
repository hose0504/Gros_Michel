import json, gzip, base64, requests

def lambda_handler(event, context):
    data = json.loads(gzip.decompress(base64.b64decode(event['awslogs']['data'])))
    for log_event in data['logEvents']:
        log_message = log_event['message']
        try:
            requests.post("http://172.30.192.49:8000/logs", json={"log": log_message}, timeout=2)
        except Exception as e:
            print("Failed to send to on-prem:", e)
