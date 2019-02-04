
# Lab 5 task 3 - cli
```
[ec2-user@ip-10-0-0-206 ~]$ aws configservice put-configuration-recorder --recording-group allSupported=false,includeGlobalResourceTypes=false,resourceTypes=AWS::S3::Bucket --configuration-recorder name=default,roleARN=arn:aws:iam::815136738847:role/ConfigRole
[ec2-user@ip-10-0-0-206 ~]$ aws configservice put-delivery-channel --delivery-channel configSnapshotDeliveryProperties={deliveryFrequency=Twelve_Hours},name=default,s3BucketName=qls-128930-69626669cb40734e-configbucket-1gm2g4aw3mv38,snsTopicARN=arn:aws:sns:us-west-2:815136738847:qls-128930-69626669cb40734e-ConfigSNSTopic-13TJ1FFAOOIGB
[ec2-user@ip-10-0-0-206 ~]$ aws configservice start-configuration-recorder --configuration-recorder-name default
[ec2-user@ip-10-0-0-206 ~]$ ls -alrt
total 32
-rw-r--r-- 1 ec2-user ec2-user  124 Mar  4  2015 .bashrc
-rw-r--r-- 1 ec2-user ec2-user  176 Mar  4  2015 .bash_profile
-rw-r--r-- 1 ec2-user ec2-user   18 Mar  4  2015 .bash_logout
drwxr-xr-x 3 root     root     4096 Jan 25 16:42 ..
drwx------ 2 ec2-user ec2-user 4096 Jan 25 16:42 .ssh
drwxr-xr-x 2 root     root     4096 Jan 25 16:43 .aws
-rw-r--r-- 1 ec2-user ec2-user 2596 Jan 25 16:43 lambda_function.py
drwx------ 4 ec2-user ec2-user 4096 Jan 25 16:43 .
[ec2-user@ip-10-0-0-206 ~]$ less lambda_function.py
[ec2-user@ip-10-0-0-206 ~]$ vim S3ProhibitPublicReadAccess.json
[ec2-user@ip-10-0-0-206 ~]$ vim S3ProhibitPublicWriteAccess.json
[ec2-user@ip-10-0-0-206 ~]$ aws configservice put-config-rule --config-rule file://S3ProhibitPublicReadAccess.json
[ec2-user@ip-10-0-0-206 ~]$ aws configservice put-config-rule --config-rule file://S3ProhibitPublicWriteAccess.json
[ec2-user@ip-10-0-0-206 ~]$ zip lambda_function.zip lambda_function.py
  adding: lambda_function.py (deflated 64%)
[ec2-user@ip-10-0-0-206 ~]$
[ec2-user@ip-10-0-0-206 ~]$ aws lambda create-function --function-name RemoveS3PublicAccessDemo --runtime "python3.6" --handler lambda_function.lambda_handler --zip-file fileb://lambda_function.zip --environment Variables={TOPIC_ARN=arn:aws:sns:us-west-2:815136738847:qls-128930-69626669cb40734e-ConfigSNSTopic-13TJ1FFAOOIGB} --role arn:aws:iam::815136738847:role/LambdaRole
{
    "FunctionName": "RemoveS3PublicAccessDemo",
    "LastModified": "2019-01-25T18:11:00.511+0000",
    "RevisionId": "3723476b-fa27-47fa-b55d-dc6dd5419fa1",
    "MemorySize": 128,
    "Environment": {
        "Variables": {
            "TOPIC_ARN": "arn:aws:sns:us-west-2:815136738847:qls-128930-69626669cb40734e-ConfigSNSTopic-13TJ1FFAOOIGB"
        }
    },
    "Version": "$LATEST",
    "Role": "arn:aws:iam::815136738847:role/LambdaRole",
    "Timeout": 3,
    "Runtime": "python3.6",
    "TracingConfig": {
        "Mode": "PassThrough"
    },
    "CodeSha256": "qVkSskOJF4fwBNkYmVE9s0Kg5wWslarcG3GwZXgR9A4=",
    "Description": "",
    "CodeSize": 1116,
    "FunctionArn": "arn:aws:lambda:us-west-2:815136738847:function:RemoveS3PublicAccessDemo",
    "Handler": "lambda_function.lambda_handler"
}
```

# Task 5 - 

```bash
[ec2-user@ip-10-0-0-206 ~]$ aws events put-rule --name ConfigNonCompliantS3Event --event-pattern file://CloudWatchEventPattern.json
{
    "RuleArn": "arn:aws:events:us-west-2:815136738847:rule/ConfigNonCompliantS3Event"
}
```