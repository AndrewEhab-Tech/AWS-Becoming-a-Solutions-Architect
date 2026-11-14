import json
import boto3
import os
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ.get('TABLE_NAME', 'saa-p3-customer-records'))

def lambda_handler(event, context):
    http_method = event.get('httpMethod', 'GET')
    path = event.get('path', '')
    
    # Extract user identity from Cognito JWT authorizer claims
    user_id = event.get('requestContext', {}).get('authorizer', {}).get('claims', {}).get('sub', 'anonymous-user')
    
    if http_method == 'POST':
        body = json.loads(event.get('body', '{}'))
        record_id = str(uuid.uuid4())
        item = {
            'userId': user_id,
            'recordId': record_id,
            'title': body.get('title', 'Untitled'),
            'content': body.get('content', '')
        }
        table.put_item(Item=item)
        return {
            'statusCode': 201,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'message': 'Created successfully', 'item': item})
        }
    elif http_method == 'GET':
        response = table.query(
            KeyConditionExpression=boto3.dynamodb.conditions.Key('userId').eq(user_id)
        )
        return {
            'statusCode': 200,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'items': response.get('Items', [])})
        }
        
    return {
        'statusCode': 400,
        'body': json.dumps({'error': 'Unsupported HTTP method'})
    }
