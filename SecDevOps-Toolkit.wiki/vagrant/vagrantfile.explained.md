
## Vagrant 
Download / Install: https://www.vagrantup.com/downloads.html

### Introduction to Vagrant 
Vagrant is an Ruby-based tool used to automate the setup of 
development environments. It was designed to be customized and currently
works across many common platforms using providers to integrate w/ 
VirtualBox, VMWare, AWS, Azure, Google Cloud, Docker, Docker-Compose, 
+ many more.  

#### Vagrant plugins
vagrant currently has 494 plugins available.  To obtain a full list of 
available plugins perform `gem list --remote vagrant-` 


The plugins I use managed are managed by the dependency_manager.rb script
via the `check_plugins` array
  * vagrant-docker-login: https://github.com/leighmcculloch/vagrant-docker-login
  * vagrant-docker-compose: https://github.com/leighmcculloch/vagrant-docker-compose
  * vagrant-awsinfo:  https://github.com/johntdyer/vagrant-awsinfo
  * vagrant-aws: https://github.com/mitchellh/vagrant-aws
  * vagrant-vcloud: https://github.com/frapposelli/vagrant-vcloud
  * vagrant-vsphere: https://github.com/nsidc/vagrant-vsphere

#### Dive Deeper

Dive Deeper into providers and plugins on the vagrant wiki:
* https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins

#### Extending Vagrant w/ Ruby
A simple example outlining the natural extension of vagrant using ruby 
code is the dependency_manager script used within the vagrantfile but 
technically managed from this repo: 

https://github.com/DevNIX/Vagrant-dependency-manager


### Vagrant How-To's
  * vagrant, chocolately, & puppet: 
    http://tallmaris.com/using-vagrant-with-chocolatey-and-puppet-to-spin-up-virtual-machines/


# YAML Examples: 

## Implement YAML files:
```
require 'yaml'
creds = YAML.load_file("./yaml/aws.yaml")
nodes = YAML.load_file(creds['yaml_of_instances'])
```

## YAML file format:

### aws.yaml 
The central file of hard-coded credentials
```
---
access_key: "xxxxxxxx"
secret_key: "xxxxxxxx"
private_key_path: "/path/to/your/file.pem"
aws_keypair_name: "name_of_aws_keypair"
docker_user: self-explanatory
docker_email: self-explanatory@usecase.com
docker_reg_pass: secret
docker_registry_url: https://docker-registry.ur.site.com
yaml_of_instances: ./yaml/vagrant.all.yaml
```

### vagrant.yaml
```
---
- name:       win7
  ami:        'ami-xxxxxx'
  user:       'vagrant'
  region:     'us-east-1'
  isWindows:  True
  subnet_id:   'subnet-xxxxxxx'
  secgroup_name: 'sg-xxxxxxx'
  aws_keypair_name: "xxxxxxx"
  type: "t2.small"
  userData: 'cloud-init/windows_initialize.txt'
  folders: # additional folders to sync up
    - main_folder:
      local:    '/path/to/local/file'
      virtual:  'C:\\Users\vagrant\Desktop\files'
  initScript:
    - install_all_dependencies:
      init: "./shared/shell/main.cmd"
  # This shell provisioner installs chocolatey, ruby, and puppet. Also runs librarian-puppet.

- name:       centos7
  ami:        'ami-6d1c2007'
  user:       centos
  region:     'us-east-1'
  subnet_id:   'subnet-xxxxxxx'
  secgroup_name: 'sg-xxxxxxx'
  aws_keypair_name: "xxxxxxx"
  type: "t2.small"
  userData: 'cloud-init/scanner_initialize.txt'
```

## Detect the Operating System of the host...
```
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end
    def OS.unix?
        !OS.windows?
    end
    def OS.linux?
        OS.unix? and not OS.mac?
    end
end
```


```
# install Docker, docker-compose, and login to private repo
config.vm.provision :docker
config.vm.provision :docker_compose, yml: ["/vagrant/docker/docker_compose.yml"], rebuild: true, project_name: "project_name", run: "always"
config.vm.provision :docker_login, username: creds["docker_user"], email: creds["docker_email"], password: creds["docker_reg_pass"], server: creds["docker_registry_url"]

```
