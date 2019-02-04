# Terraform Overview:
Terraform can be used for orchestration & environment setup at scale yet only returns an "All Success" or "A Failure" type result.  
This often means failures require deeper inspection and analysis throughout the orchestration process. 

# Terminology:
* Manifest: this is any file with a .tf ending
* resources:  the manifest files contain aws_resource declarations, these are resources.
* configs:  these values are specific to an AWS environment and should not be shared.  This represents Access/Secret keys, VPC-IDs, subnets
 or any other data element which can be considered private.

# Setup - variables.tf
The variables manifest is a template with `xxxx` values in places where specific data is needed. A few of the values that require updating to use
the terraform manifests can also be created dynamically.  For the purposes of this wiki, I will outline how to update them via hard-coding:

* access key
* secret key
* vpc_id
* key name
* subnet_id
* security group id (secgroup_id)


## Prevent Committing Private data
Once you have updated the manifest with the appropriate information you can setup git to ignore the recent changes in these files to prevent accidental commit of data:

`git update-index --assume-unchanged <file>` 
to start tracking changes again:
`git update-index --no-assume-unchanged <file>`


## Variable manifest template
```
# ------------------------------------------
# Credentials via API Keys
# ------------------------------------------
variable access_key {
  description = "The API Access key to AWS"
  default="xxxxxxxxx"
}

variable secret_key {
  description = "The API Secret key to AWS"
  default="xxxxxxxxxxxx"
}


provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-2"
}
```


# After configuring
Once you update the variables manifests you are able to leverage terraform to create, setup, & destroy various AWS services.
