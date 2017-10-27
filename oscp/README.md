# Overview:
This provides a quick guide to setup and execute the following scripts:
	- full_nmap_script_test.sh


## full_nmap_script_test
Dependency:  This requires you to have run a db_nmap scan using the following flags against a cidr block & export that data from msfconsole into a csv file:

- run the scan, import results into msf db
db_nmap -A -sV -p- 10.11.1.0/24

- export the scan data:
services -o /tmp/info.csv

- run the full nmap script test:
./full_nmap_script_test.sh


The output from the full nmap script is stored in: /tmp/nmap_test/<service>/<script>.out