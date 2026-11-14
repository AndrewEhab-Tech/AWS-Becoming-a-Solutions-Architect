import json
import boto3

rds = boto3.client('rds', region_name='eu-west-1')

def lambda_handler(event, context):
    print("Disaster recovery failover signal received from EventBridge / Route 53 Alarm!")
    cluster_id = 'saa-p5-aurora-eu-replica'
    
    try:
        response = rds.failover_global_cluster(
            GlobalClusterIdentifier='saa-p5-global-db',
            TargetDbClusterIdentifier=cluster_id
        )
        print(f"Global cluster failover initiated for {cluster_id}")
        return {'statusCode': 200, 'body': 'Failover triggered successfully'}
    except Exception as e:
        print(f"Error promoting replica: {str(e)}")
        return {'statusCode': 500, 'body': str(e)}
