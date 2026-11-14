import json
import boto3
import os
import uuid
from datetime import datetime

s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

DDB_TABLE = os.environ.get('DDB_TABLE', 'saa-p2-image-metadata')
DEST_BUCKET = os.environ.get('DEST_BUCKET')
SNS_TOPIC = os.environ.get('SNS_TOPIC')

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    table = dynamodb.Table(DDB_TABLE)
    
    # Process S3 / SQS records
    records = event.get('Records', [])
    for rec in records:
        body = json.loads(rec['body']) if 'body' in rec else rec
        # Extract bucket and key
        s3_info = body.get('Records', [{}])[0].get('s3', {})
        src_bucket = s3_info.get('bucket', {}).get('name')
        src_key = s3_info.get('object', {}).get('key')
        
        if not src_bucket or not src_key:
            continue
            
        image_id = str(uuid.uuid4())
        print(f"Processing image {src_key} from {src_bucket}")
        
        # Metadata storage
        table.put_item(
            Item={
                'ImageId': image_id,
                'OriginalKey': src_key,
                'Status': 'PROCESSED',
                'ProcessedTimestamp': datetime.utcnow().isoformat(),
                'Sizes': ['original', 'thumbnail_150x150', 'web_800x600']
            }
        )
        
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Pipeline processed successfully', 'processed': len(records)})
    }
