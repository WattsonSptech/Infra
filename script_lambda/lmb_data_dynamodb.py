import json, os, time, uuid, boto3
from decimal import Decimal
dynamo = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])
def lambda_handler(event, context):
    # evento vindo do IoT Core Rule -> JSON em 'event'
    # Ex.: {"deviceId":"sensor-001","temp":24.2,"hum":60}
    try:
        msg = event if isinstance(event, dict) else json.loads(event)
        item = {
            "deviceId": str(msg.get("deviceId", "unknown")),
            "ts": int(time.time()*1000),
            "id": uuid.uuid4().hex,
            "temp": Decimal(str(msg.get("temp", 0))),
            "hum": Decimal(str(msg.get("hum", 0))),
            "raw": json.dumps(msg)
        }
        dynamo.put_item(Item=item)
        return {"status": "ok", "saved": {"deviceId":
item["deviceId"], "ts": item["ts"]}}
    except Exception as e:
        return {"status": "error", "detail": str(e)}