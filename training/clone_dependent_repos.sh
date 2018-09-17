#!/bin/bash
# there are many repo's with enormously valuable information - this downloads them to your toolbox.
dir=Offensive;
mkdir $dir; cd $dir
git clone https://github.com/frizb/OSCP-Survival-Guide.git
git clone https://github.com/codingo/Reconnoitre.git
git clone https://github.com/erik1o6/oscp.git
git clone https://github.com/scipag/vulscan.git
git clone https://github.com/darkoperator/Metasploit-Plugins.git
git clone https://github.com/DataSploit/datasploit.git
git clone https://github.com/offensive-security/exploit-database.git
git clone https://github.com/Exploit-install/snmpwn
git clone https://github.com/offensive-security/exploit-database
git clone https://github.com/offensive-security/exploit-database-bin-sploits
git clone https://github.com/offensive-security/exploit-database-papers

#wiki Technical content
cd ..; mkdir wiki; cd wiki
git clone https://github.com/cappetta/SecDevOps-Toolkit.wiki.git

# Cloud SecDevOps tooling
dir=Defensive;
cd ..; mkdir $dir; cd $dir
git clone https://github.com/Netflix/security_monkey.git
git clone https://github.com/dowjones/hammer.git
git clone https://github.com/docker/docker-bench-security.git

dir=education;
cd ..; mkdir $dir; cd $dir
git clone https://github.com/scottslowe/learning-tools.git
git clone https://github.com/nicholasjackson/slack-bot-lex-lambda.git


# Vulnerable AWS configurations
git clone https://github.com/RhinoSecurityLabs/cloudgoat.git


