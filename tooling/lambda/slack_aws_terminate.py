# coding=utf-8
import os
import boto3
import urllib2

"""
Required Lambda Environment Variables:
- slack_webhook
"""

def send_slack_msg(msg):
    try:
        payload = '{"text": "' + msg + '", "response_type": "ephemeral"}'
        urllib2.urlopen(os.environ['slack_webhook'], payload)
    except Exception, e:
        print 'error sending Slack msg: ' + str(e)


### Lambda handler ###
def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='eu-central-1')  # Use the correct region here
    instances = ec2.describe_instances()
    ids = []

    for r in instances['Reservations']:
        for i in r['Instances']:
            ids.append(i['InstanceId'])

    ec2.terminate_instances(InstanceIds=ids)

    if len(ids) > 0:
        send_slack_msg('Terminated running instances!')

    return 'Terminated instances: ' + str(ids)
