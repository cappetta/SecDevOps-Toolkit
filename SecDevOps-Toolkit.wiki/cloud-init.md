# Cloud-Init Overview:

### Cloud-init Explained:
Cloud-init is a tool which handles the initialization (bootstrapping) of 
a process/steps within a cloud instance before it becomes available to the end-user.  

Read the Docs: http://cloudinit.readthedocs.io/en/latest/

### Project specific 
There are 2 basic cloud-init files and a few custom scenarios: 
  * linux.setup.yml - this initializes the system so root provisioning can occur without  
  * windows.setup.yml - this creates terraform user w/ default pass, reduces UAC, shuts off firewall, & enables winrm.
  
  Custom:
  * centos.docker.setup.yml - installs docker & aws cli in centos
  * ubuntu.docker.setup.yml - installs docker & aws cli in ubuntu
  * samba.setup.yaml - installs a samba server w/ anonymous access
  * windows.smbv3_disable.setup.yml - performs windows.setup + disables smbv3, reverts to smb1 w/o encryption 
  * windows.smbv3_disable.setup.yml - performs windows.setup + enables smbv3 protocol w/ encryption
  

