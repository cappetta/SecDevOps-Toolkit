# Vagrant Overview
Vagrant is a DevOps tooling which is used to quickly reproduce an virtual environment.  The vagrant-controlled asset has a series of functionality 
leveraged to fully initialize, setup, configure, maintain, and destroy virtual machines yet it does not handle simitaniously orchestration more than 10 assets very well.  

In scenarios where more than 10 assets need to be created, setup, provisioned, & staged we can leverage terraform.

## Vagrant setup
Vagrant can be highly configured by using yaml. This toolkit requires the need for 2 yaml files:

    - aws.yaml: this contains your aws credentials.
    - all.yaml: this is a large yaml file for many instances (windows, linux, containers)
    - *.yaml: this represents a custom created yaml file for the use-case you are working on.

## Prevent Committing Private data
Once you modify the aws.yaml file you can remove it from git tracking by: 
`git update-index --assume-unchanged <file>` 
to start tracking changes again:
`git update-index --no-assume-unchanged <file>`

## YAML Variables to modify:
```yaml
  ami_id: ami-xxxxxx 
  user:   <name of ami default user>
  region:     'us-xxx-1'
  subnet_id:   'subnet-xxxxxx'
  secgroup_name: 'sg-xxxxxx'
  aws_keypair_name: "xxxxxx"
```

