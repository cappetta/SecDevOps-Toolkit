# Why would you want to use me?

As a Cloud Architect, I recognize the enormous business value that rapid 
prototying & extreme programming principles provide to a global IT 
workforce. 

The tools outlined below enable Developers, DevOps Engineers, &
Designers the ability to define, isolate, & automate dependencies to 
create a reproducible & automated application / infrastructure 
environment.  

The goal of this toolbox is to provide any individual with a framework
to get started implementing the use of these tools for use-cases which
benefit them.

# Tools in the ToolBox (Install Pre-req's)
The tools directly below require you install them on your target system(s)
before using any of the examples in the vagrant/terraform folders.

## Vagrant 
Download / Install: https://www.vagrantup.com/downloads.html

## Terraform
Download / Install: https://www.terraform.io/downloads.html


# Other Tools
## Docker
Everyone Loves Containers so here's an Awesome Docker Link: 
https://github.com/veggiemonk/awesome-docker

## Cloud-Init (AWS
There are 2 basic cloud-init files: 
  * Linux: linux.setup.yml
    - this initializes sudo w/o tty 
  * Windows: windows.setup
    - this creates terraform user w/ default pass, reduces UAC, shuts off firewall, enables winrm
  
### Cloud-init Explained:
Cloud-init is a tool which handles the initialization (bootstrapping) of 
a cloud instance before it becomes available to the end-user.  

#### Cloud-Init Examples
General Examples: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
AWS (Windows): http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/UsingConfig_WinAMI.html 
Azure: https://azure.microsoft.com/en-us/blog/custom-data-and-cloud-init-on-windows-azure/
GCP: https://cloud.google.com/compute/docs/startupscript
    



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

vagrant has 2 primary yaml files.  One is the aws.yaml file which has the following format & holds the credentials.

## Terraform - hcl/json 
