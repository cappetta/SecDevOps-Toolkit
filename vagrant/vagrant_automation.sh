#!/bin/bash
echo Launching the Box without provisioning
vagrant up --no-provision $1
echo Starting Shell Provisioning
vagrant provision --provision-with shell $1 
#echo Starting Puppet Provisioning
#vagrant provision --provision-with puppet $1
echo Starting Docker Provisioning
vagrant provision --provision-with docker $1
echo Logging into Docker Registery
vagrant provision --provision-with docker_login $1
#echo Starting Docker-Compose Provisioning
#vagrant provision --provision-with docker_compose
#echo Reloading Vagrant
#vagrant reload
