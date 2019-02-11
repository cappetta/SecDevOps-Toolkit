# Overview

As a SecDevOps Engineer, I need a toolkit of frameworks, bootstrap 
solutions, vulnerable target manifests, and cliff-notes for research 
to help 'sharpen the axe'.

As a Cyber Security Expert, I constantly research, explore, and 
utilize various technologies to improve my capabilities, redefine
processes, and 'sharpen my axe' across all operating systems, 
technolgies, domains, languages, services, and protocols.
  
As a Cloud Architect, I recognize the enormous business value that rapid 
prototying, automated orchestration, & continuous delivery provide to a 
organization. 

This project is an uncoordinated set of efforts from multiple sources, 
where possible I've referenced the original source while consolidating 
things into a single repository.  If I missed a reference to a source, 
open an issue & I'll gladly provide credit toward the original source. 

The goal of this toolbox is to provide any individual with a framework
to get started implementing the use of these tools for use-cases which
benefit them.
 
# Features
The tools below require you download/install them on your target system(s)
before using any of the examples in the folders.  

## Research: 
The Ultimate cheat-sheet: `https://lzone.de/cheat-sheet/jq`

## Wiki Content:
 The wiki contains key information outlining general usage of the tools.  
 The tooling folder contains a few other tools not outlined below and 
 the supporting wiki sit ealso 
 
 https://github.com/cappetta/SecDevOps-Toolkit/wiki
 
    - Git Secrets - eliminate sensitive data from being committed
    - AWS Setup - obtaining api keys and setting up a cli
    - terraform -  general usage & argument syntax
    - vagrant - create & share a
    - puppet/ansible - configuraction mgmt tooling
    - docker -
    - cloud-int
    
## Git-Secrets
    
If you read-this you need to take action right now & execute these steps
on any system you have work/develop on.  Human-Error will leak AWS keys 
and must run this in every on any system which might have a repository 
you want protected.

    1) Make a directory for the template: mkdir ~/.git-template

    2) Install the hooks in the template directory: git secrets --install ~/.git-template

    3) Tell git to use it: git config --global init.templateDir ’~/.git-template’

    4) Execute Git-Secrets to install across all repos 
        via: tooling/scripts/update_all_repos.sh
        
    Big Thanks to Nate Jacobs @sparkbox for outlining this solution in 
    his blog: https://seesparkbox.com/foundry/git_secrets
    
    original source: `https://gist.github.com/iAmNathanJ/0ae03dcb08ba222d36346b138e83bfdf`

Hands-down the most important step you can do right now if you use
AWS, take the moment to [x] the box off your own systems now...

    
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
