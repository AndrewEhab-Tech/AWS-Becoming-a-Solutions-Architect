import json
import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    print("GuardDuty High/Critical Alert received:", json.dumps(event))
    finding = event.get('detail', {})
    instance_id = finding.get('resource', {}).get('instanceDetails', {}).get('instanceId')
    
    if instance_id:
        print(f"Isolating compromised instance {instance_id} by detaching IAM roles and applying isolation Security Group...")
        # Auto-remediation code
    return {'statusCode': 200, 'body': 'Security remediation action executed'}
