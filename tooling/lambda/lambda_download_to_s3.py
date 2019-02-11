import boto3
import botocore.vendored.requests.packages.urllib3 as urllib3

def lambda_handler(event, context):

    url='https://download.vulnhub.com/node/Node.ova' # put your url here
    bucket = 'bucketID' #your s3 bucket
    key = 'node.ova' #your desired s3 path or filename

    s3=boto3.client('s3')
    http=urllib3.PoolManager()
    s3.upload_fileobj(http.request('GET', url,preload_content=False), bucket, key)

