docker build -t "owasp/sonarqube" docker/.
docker run -d -p 9000:9000 -p 9092:9092 owasp/sonarqube (docker image name)
localhost:9000

docker run -i -p 80:80 -p 443:443 -t ismisepaul/securityshepherd /bin/bash

/usr/bin/mysqld_safe &
service tomcat7 start

# Setup RailsGoat
# https://github.com/OWASP/railsgoat
git clone https://github.com/OWASP/railsgoat.git

# Setup NodeGoat
git clone https://github.com/OWASP/NodeGoat.git




docker run --rm -it -p 80:80 vulnerables/web-dvwa

# Juice Shop
# https://hub.docker.com/r/bkimminich/juice-shop/
docker run --rm -p 3000:3000 bkimminich/juice-shop


# reference: https://github.com/commjoen/ubuntu/blob/master/script/custom/provision-containers.sh

echo "provisioning containers"
echo "container overview:" >> containers.md

echo "juiceshop container:">> containers.md
echo "docker run --rm -p 3000:3000 bkimminich/juice-shop" >> containers.md
echo "https://github.com/bkimminich/juice-shop" >> containers.md
docker pull bkimminich/juice-shop

echo " ">> containers.md
echo "webgoat container (7.1):" >> containers.md
echo "docker run -p 8080:8080 -t webgoat/webgoat-7.1" >> containers.md
echo "https://github.com/WebGoat/WebGoat" >> containers.md
docker pull webgoat/webgoat-7.1
docker run -p 8082:8080 -t webgoat/webgoat-7.1

echo " ">> containers.md
echo "webgoat container (8.0):" >> containers.md
echo "docker run -p 8080:8080 -it webgoat/webgoat-8.0 /home/webgoat/start.sh" >> containers.md
echo "https://github.com/WebGoat/WebGoat" >> containers.md
docker pull webgoat/webgoat-8.0
docker run -p 8081:8080 -it webgoat/webgoat-8.0 /home/webgoat/start.sh

echo " ">> containers.md
echo "dvws container:">> containers.md
echo "docker run -d -p 80:80 -p 8080:8080 tssoffsec/dvws" >> containers.md
echo "https://hub.docker.com/r/tssoffsec/dvws/" >> containers.md
docker run -d -p 80:80 -p 8080:8080 tssoffsec/dvws

echo " ">> containers.md
echo "dvwa container:">> containers.md
echo "docker run -d -p 80:80 -p 80:80 vulnerables/web-dvwa" >> containers.md
echo "https://hub.docker.com/r/tssoffsec/dvws/" >> containers.md
docker run --rm -it -p 80:80 vulnerables/web-dvwa

echo " ">> containers.md
echo "xvwa container:">> containers.md
echo "docker run --name xvwa -d -p 80:80 tuxotron/xvwa" >> containers.md
echo "https://github.com/s4n7h0/xvwa" >> containers.md
docker run --name xvwa -d -p 80:80 tuxotron/xvwa

docker run owasp/glue


echo " ">> containers.md
echo "mailcatcher container:">> containers.md
echo "docker run -d -p 1080:1080 --name mailcatcher schickling/mailcatcher" >> containers.md
echo "https://hub.docker.com/r/schickling/mailcatcher/" >> containers.md
docker run -d -p 1080:1080 --name mailcatcher schickling/mailcatcher


echo " ">> containers.md
echo "Metasploit Vulnerable Services container:">> containers.md
echo "docker run --rm -it \
       -p 20:20 -p 21:21 -p 80:80 -p 443:443 -p 4848:4848 \
       -p 6000:6000 -p 6060:6060 -p 7000:7000 -p 7181:7181 \
       -p 7547:7547 -p 8000:8000 -p 8008:8008 -p 8020:8020 \
       -p 8080:8080 -p 8400:8400 \
       vulnerables/metasploit-vulnerability-emulator" >> containers.md
echo "https://hub.docker.com/r/vulnerables/metasploit-vulnerability-emulator/" >> containers.md
docker run --rm -it \
       -p 20:20 -p 21:21 -p 80:80 -p 443:443 -p 4848:4848 \
       -p 6000:6000 -p 6060:6060 -p 7000:7000 -p 7181:7181 \
       -p 7547:7547 -p 8000:8000 -p 8008:8008 -p 8020:8020 \
       -p 8080:8080 -p 8400:8400 \
       vulnerables/metasploit-vulnerability-emulator


docker run --name vulnerablewordpress -d -p 80:80 -p 3306:3306 wpscan/vulnerablewordpress