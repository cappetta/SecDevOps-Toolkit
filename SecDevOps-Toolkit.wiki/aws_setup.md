# AWS Setup Wiki 

## Setup your API credentials

In order to get cli and/or api access to the environment you need to setup your individual access keys.  This is found in by going into: `AWS Console > IAM Users > {Select User} > Click on Security Credentials > Click on Create Access Key`.  

The next window, containing the secret access key, is displayed only 1 time - so it is imperative that you copy and safely store the Access Key & Secret Access Key.

## Setup AWSCLI in python environment
If you do not use python virtual environments then it is strongly advised to setup it up quickly so you can isolate python dependencies.  In this scenario, I will create an isolated environment for my aws cli queries.

```
virtualenv aws 
```

from there source the new environments activate file: 

```
source ./aws/bin/activate
```

to deactivate the isoloated python environment: 
``` 
source ./aws/bin/deactivate
```

### Install Aws cli
pip install awscli

### Setup your AWS CLI w/ credentials
aws configure  - this will prompt you to enter your access-key, secret-access-key, and region.  If you have multiple AWS accounts you can setup another profile w/ the --profile flag: ` aws configure --profile fortifydata `

Then commands with the profile flag: `aws ec2 describe-instances --profile client_profile` will allow you to query a specific AWS environment
