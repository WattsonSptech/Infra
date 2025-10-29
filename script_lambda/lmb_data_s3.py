import json, os, time, uuid, boto3
from decimal import Decimal
from datetime import datetime

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    str_json = json.dumps(event)

    s3_client.put_object(
        Bucket="bkt-wattson-raw-637952174709",
        Key=f"telemetry_{datetime.now().isoformat()}.json",
        Body=str_json,
        ContentType='text/plain'
    )

    return {"status": "ok"}
