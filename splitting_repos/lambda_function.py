import json
import boto3
import uuid
import os
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    body = json.loads(event['body'])
    item_id = str(uuid.uuid4())
    item = {
        'id': item_id,**body
        }

table.put_item(Item=item)

return {
    'statusCode': 200,
    'body': json.dumps({'id': item_id, 'message': 'Item created successfully'}),
    'headers': {
        'Content-Type': 'application/json'
    }
} 