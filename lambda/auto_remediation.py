import boto3
import os

ec2 = boto3.client("ec2")

def lambda_handler(event, context):
    instance_id = os.environ["INSTANCE_ID"]

    ec2.reboot_instances(
        InstanceIds=[instance_id]
    )

    return {
        "status": "SUCCESS",
        "action": "EC2 reboot triggered",
        "instance_id": instance_id
    }
