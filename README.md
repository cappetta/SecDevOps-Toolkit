# Overview

As a Cloud DevOps Security, I recognize the enormous value an organized
 toolbox full of automation utilities, cliff notes, & reference 
 repositories brings to any project at hand.

The tools within can be substituted for one of many alternatives. The 
cloned repo's are believed to be both cutting-edge and stable references
to additional tooling.

The goal is to outline a project agnostic automation tooling that
DevOps engineers can leverage to quickly create, test, and deploy to 
both simple & complex application environments. 

From a **Security Perspective**, the need to act quickly to changing scenarios 
is also very important.  From a time/effort perspective, there is a maximum
benefit being able to automate an environment and add a step to a startup
script to eliminate a newly released patch for an applications 
vulnerability.  

From a **Documentation Perspective**, the centralization of cliff-notes helps outline the common configuration 
& usage of the tools.  If you've used one of them before then you will 
quickly recognize how this can control single asset use-cases as well as
multi-asset

# Features
The tools directly below require you install them on your target system(s)
before using any of the examples in the vagrant/terraform folders.
## Wiki Content: 
    - Git Secrets - eliminate sensitive data from being committed
    - AWS Setup - obtaining api keys and setting up a cli
    - terraform -  general usage & argument syntax
    - vagrant - outlining
    
## Vagrant 
Use-Case: Create & Provision Infrastructure
Wiki: https://github.com/cappetta/SecDevOps-Toolkit/wiki/vagrant
URL: https://www.vagrantup.com/downloads.html

## Terraform
Use-Case: Create & Provision Infrastructure
Wiki: https://github.com/cappetta/SecDevOps-Toolkit/wiki/terraform
URL: https://www.terraform.io/downloads.html

## Cloud-Init (AWS)
Use-Case: Configure the system before it becomes available.
Wiki: 
URL: 

#### Cloud-Init Examples
General Examples: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
AWS (Windows): http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/UsingConfig_WinAMI.html 
Azure: https://azure.microsoft.com/en-us/blog/custom-data-and-cloud-init-on-windows-azure/
GCP: https://cloud.google.com/compute/docs/startupscript
    
# Other Tools
## Docker
Everyone Loves Containers so here's an Awesome Docker Link: 
https://github.com/veggiemonk/awesome-docker


## Chocolately  
Described as the the "apt-get for windows".  There are currently 4,863 
software packages available for install.  Using chocolately allows us to
leverage a large repository of programs.  

* URL: https://chocolatey.org/packages



### Execution:
It is executed through the windows shell thru a 'terraform apply' step. 
This has not yet been introduced into the vagrantfile & tested but it is
reasonably possible to do so.
 

chocolately is installed and automatically available for any combination of software installs
cli use: ```terraform apply -target=aws_instance.win2016_base -var 'software=winrar googlechrome notepadplusplus flashplayerplugin jre8'```
variables.mf - this is a file where you can set the variables & associated values


challenges - does the software that gets installed = valid testing condition

## Puppet


# Data Organization

## Vagrant - yaml

vagrant has 2 primary yaml files.  One is the aws.yaml file which has the following format & holds the credentials of the user.
```
---
access_key='xxxxx'
secret_key='xxxxx'
```

## Terraform - hcl/json 
Terraform requires manifests, essentially blueprints, which provide instructions on the resources and assets to create.  All resources have variablized attributes where defaults are stored in the variables.tf file and over-riden via commandline parameter.  For example:

declare a variable for ami:
```
var amazon_ami {
  description = 'This is an example variable for amazon ami settings'
  default = ami-xyzxyz
}
```

This command would override the default variable value and set the variable to ami-abcabc
```
terraform apply --target=aws_instance.example_instance -var 'amazon_ami=ami-abcabc'
```
