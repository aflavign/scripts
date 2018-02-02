import boto3
import requests
response = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
instance_id = response.text
asgclient = boto3.client('autoscaling')
response = asgclient.describe_auto_scaling_instances(InstanceIds=[instance_id])
if len(response['AutoScalingInstances'])>0:
  isinasg=response['AutoScalingInstances'][0]['InstanceId']
  print(isinasg)
else:
  print("Instance Id Not Found")

