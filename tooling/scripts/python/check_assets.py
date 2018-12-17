import boto3
from botocore.exceptions import ClientError
import json

session = boto3.Session(profile_name='circleci')
client = session.client('ec2', region_name='us-west-2')
try:
# client.delete_key_pair( KeyName='circleci_terraform')
    keypairs = client.describe_key_pairs()
    print '-------------------------'
    eips = client.describe_addresses()
    print keypairs
    print eips
    for address in eips['Addresses']:
            print address['AssociationId']
            # client.disassociate-address(AllocationId=address['AssociationId'])
            print address['AllocationId']
            client.release_address(AllocationId=address['AllocationId'])
    print '-------------------------'
except ClientError as e:
    print '[ERROR]: ' +  e.__str__()

