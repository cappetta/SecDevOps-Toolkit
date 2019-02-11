import boto3
import logging

#setup simple logging for INFO
logger = logging.getLogger()
logger.setLevel(logging.INFO)

region = 'us-west-2'
#define the connection
ec2 = boto3.resource('ec2', region_name=region)

def lambda_handler(event, context):
    # Use the filter() method of the instances collection to retrieve
    # all running EC2 instances.
    filters = [{
        'Name': 'key-name',
        'Values': ['circleci']
    },
        {
            'Name': 'instance-state-name',
            'Values': ['running']
        }
    ]

    #filter the instances
    instances = ec2.instances.filter(Filters=filters)

    #locate all running instances
    RunningInstances = [instance.id for instance in instances]

    #print the instances for logging purposes
    #print RunningInstances