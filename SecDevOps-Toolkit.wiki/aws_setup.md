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

### Import Images into AWS and Create AMI's
1. Upload .ova file to S3
2. create role, role-policy, then import image

aws iam create-role --role-name vmimport --assume-role-policy-document file://vmimport-trust-policy.json
aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://vmimport-role-policy.json
aws ec2 import-image --description "redhunt" --disk-containers file://import_redhunt.json


### EC2Launch vs. Cloud-Init



```
EC2Launch Tasks

EC2Launch performs the following tasks by default during the initial instance boot:

    Sets up new wallpaper that renders information about the instance.

    Sets the computer name.

    Sends instance information to the Amazon EC2 console.

    Sends the RDP certificate thumbprint to the EC2 console.

    Sets a random password for the administrator account.

    Adds DNS suffixes.

    Dynamically extends the operating system partition to include any unpartitioned space.

    Executes user data (if specified). For more information about specifying user data, see Working with Instance User Data.

    Sets persistent static routes to reach the metadata service and KMS servers.

    Important

    If a custom AMI is created from this instance, these routes are captured as part of the OS configuration and any new instances launched from the AMI will retain the same routes, regardless of subnet placement. In order to update the routes, see Updating metadata/KMS routes for Server 2016 when launching a custom AMI.


```