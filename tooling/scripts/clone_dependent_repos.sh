#!/bin/bash
mkdir - /tmp/tests;
cd /tmp/tests
# there are many repo's with enormously valuable information - this downloads them to your toolbox.

function downloadGit(){
  echo "downloading repo: $1"
  git clone $1
  echo "-------------"


}
dir=Offensive;
mkdir $dir; cd $dir
downloadGit https://github.com/frizb/OSCP-Survival-Guide.git
downloadGit https://github.com/codingo/Reconnoitre.git
downloadGit https://github.com/erik1o6/oscp.git
downloadGit https://github.com/scipag/vulscan.git
downloadGit https://github.com/darkoperator/Metasploit-Plugins.git
downloadGit https://github.com/DataSploit/datasploit.git
downloadGit https://github.com/offensive-security/exploit-database.git
downloadGit https://github.com/Exploit-install/snmpwn.git
downloadGit https://github.com/offensive-security/exploit-database.git
downloadGit https://github.com/offensive-security/exploit-database-bin-sploits.git
downloadGit https://github.com/offensive-security/exploit-database-papers.git
downloadGit https://github.com/OWASP/joomscan.git
downloadGit https://github.com/JohnTroony/php-webshells



#wiki Technical content
cd ..; mkdir wiki; cd wiki
downloadGit https://github.com/cappetta/SecDevOps-Toolkit.wiki.git

# Cloud SecDevOps tooling
dir=SecDevOps;
cd ..; mkdir $dir; cd $dir
downloadGit https://github.com/Netflix/security_monkey.git
downloadGit https://github.com/dowjones/hammer.git
downloadGit https://github.com/docker/docker-bench-security.git


dir=DevOps;cd ..; mkdir $dir; cd $dir
downloadGit https://github.com/scottslowe/learning-tools.git
downloadGit https://github.com/nicholasjackson/slack-bot-lex-lambda.git
downloadGit https://github.com/fedekau/terraform-with-circleci-example.git

# Vulnerable AWS configurations
downloadGit https://github.com/RhinoSecurityLabs/cloudgoat.git


