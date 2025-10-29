import json, os, boto3,uuid
from decimal import Decimal
dynamo = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])
def lambda_handler(event, context):

    if not isinstance(event,list):
        return {"status":400,"body":"Entrada esperada era list"}
    try:   
        with dynamo.batch_writer() as b:
            for item in event:
                obj = {
                    "id" : str(uuid.uuid4()),
                    "instant": str(item.get("timestamp","")),
                    "value": Decimal(str(item.get("valor",0))),
                    "zone": str(item.get("zona",""))
                }
                b.put_item(Item=obj)
        return {
            'statusCode': 200,
            'body': json.dumps(f'Sucesso! {len(event)} itens foram enviados para a tabela {os.environ["TABLE_NAME"]}.')
        }
    except Exception as e:
        return {'statusCode': 500, 'body': f"Houve um erro ao tentar enviar os dados para a tabela: {e}"}