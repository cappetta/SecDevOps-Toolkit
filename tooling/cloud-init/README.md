# Overview

The goal of these cloud-init files is to provide an inventory of possible
automated solutions to initializing cloud EC2 assets before they become 
available to the end user.

with the: 
- windows.setup.yml file you can easily create windows 
asset with reduced security controls and the winrm protocol enabled.
- linux.setup.yml -  setup a bootstrap linux w/ requiretty disabled
- centos.docker.setup.yml - setup/install a bootstrap centos docker 
instance
- kali.setup.yml - setup a kali server w/ tightvnc
- samba.setup.yml - simple cloud-init yml file setting up samba
- windows.smbv3*{enable|disable}.yml - reduced windows security settings 
with smbv3 configured
 


