# https://github.com/riponbanik/security_monkey/blob/master/security_monkey.sh

#!/bin/bash -e

echo "Security Monkey Installation Started"

### Proxy Configuration
echo "Configure Proxy"
echo 'export http_proxy=http://awsproxy.example.com:80' >> /etc/profile.d/proxy.sh
echo 'export https_proxy=http://awsproxy.example.com:80' >> /etc/profile.d/proxy.sh
echo 'export HTTP_PROXY=http://awsproxy.example.com:80' >> /etc/profile.d/proxy.sh
echo 'export HTTPS_PROXY=http://awsproxy.example.com:80' >> /etc/profile.d/proxy.sh
echo 'export no_proxy=localhost,169.254.169.254,.example.com,s3-ap-southeast-2.amazonaws.com' >> /etc/profile.d/proxy.sh
echo 'export NO_PROXY=localhost,169.254.169.254,.example.com,s3-ap-southeast-2.amazonaws.com' >> /etc/profile.d/proxy.sh
source /etc/profile
echo 'Defaults env_keep += "http_proxy https_proxy no_proxy"' > /etc/sudoers.d/100-keep-proxy
echo 'Acquire::http::Proxy "http://awsproxy.example.com:80/";' > /etc/apt/apt.conf.d/11proxy

### Install Packages
echo "Update and Install Packages"
sudo apt-get update
sudo apt-get -y install python-pip python-dev python-psycopg2 postgresql postgresql-contrib libpq-dev nginx supervisor git libffi-dev gcc python-virtualenv
sudo apt-get -y install postgresql postgresql-contrib

### Prerequisites Directory
echo "Create directory and modify permission"
sudo mkdir -p /var/log/security_monkey
sudo mkdir -p /var/www
sudo chown -R www-data /var/log/security_monkey/
sudo chown www-data /var/www

### Local Database
echo "Create local postgres database"
cat <<EOF > /tmp/db.sql
CREATE DATABASE "secmonkey";
CREATE ROLE "securitymonkeyuser" LOGIN PASSWORD 'securitymonkeypassword';
CREATE SCHEMA secmonkey;
GRANT Usage, Create ON SCHEMA "secmonkey" TO "securitymonkeyuser";
set timezone TO 'GMT';
select now();
\q
EOF
sudo -u postgres psql -f /tmp/db.sql

### Clone and build the App
echo "Clone and build security_monkey"
cd /usr/local/src
sudo git clone --depth 1 --branch master https://github.com/Netflix/security_monkey.git
sudo chown -R `whoami`:www-data /usr/local/src/security_monkey
cd security_monkey
virtualenv venv
source venv/bin/activate
pip install --upgrade setuptools
pip install --upgrade pip
pip install --upgrade urllib3[secure]
sudo python setup.py install
cd ..

## Compile the Web UI
#Get the Google Linux package signing key.
curl https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Set up the location of the stable repository.
cd ~
curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > dart_stable.list
sudo mv dart_stable.list /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update
sudo apt-get install -y dart

# Build the Web UI
cd /usr/local/src/security_monkey/dart
sudo /usr/lib/dart/bin/pub get
sudo /usr/lib/dart/bin/pub build

# Copy the compiled Web UI to the appropriate destination
sudo mkdir -p /usr/local/src/security_monkey/security_monkey/static/
sudo /bin/cp -R /usr/local/src/security_monkey/dart/build/web/* /usr/local/src/security_monkey/security_monkey/static/
sudo chgrp -R www-data /usr/local/src/security_monkey


### Configure the Application
echo "Configure Service"
host_name=`cat /etc/hostname`
sudo sed -i "s/ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com/$host_name/g" /usr/local/src/security_monkey/env-config/config.py
export RANDOM_KEY=$(date +%s | sha256sum | base64 | head -c 32)
sudo sed -i 's/<INSERT_RANDOM_STRING_HERE>/$RANDOM_KEY/g' /usr/local/src/security_monkey/env-config/config.py
sudo sed -i 's/securitymonkey@example.com/security_monkey@example.com/g' /usr/local/src/security_monkey/env-config/config.py
sudo sed -i 's/EMAILS_USE_SMTP = False/EMAILS_USE_SMTP = True/g' /usr/local/src/security_monkey/env-config/config.py
sudo sed -i 's/smtp.example.com/email.example.com/g' /usr/local/src/security_monkey/env-config/config.py
sudo sed -i 's/465/25/g' /usr/local/src/security_monkey/env-config/config.py
export SECURITY_MONKEY_SETTINGS=/usr/local/src/security_monkey/env-config/config.py

### Create the database tables
echo "Upgrade DB"
cd /usr/local/src/security_monkey/
monkey db upgrade


### Setting up Supervisor
sudo chgrp -R www-data /var/log/security_monkey
sudo cp /usr/local/src/security_monkey/supervisor/security_monkey.conf /etc/supervisor/conf.d/security_monkey.conf
sudo chown -R www-data /var/log/security_monkey/
sudo sed -i 's/command=\/usr\/local\/src\/security_monkey\/venv\/bin\/monkey/command=\/usr\/local\/bin\/monkey/g' /etc/supervisor/conf.d/security_monkey.conf
sudo service supervisor restart
sudo supervisorctl status

### Create an SSL Certificate
echo "Configure Self Signed SSL"
sudo openssl genrsa -out server.key 2048
sudo openssl rsa -in server.key -out server.key.insecure
sudo mv server.key server.key.secure
sudo mv server.key.insecure server.key
sudo openssl req -new -key server.key -out server.csr -subj "/C=US/ST=GA/L=Sydney/O=Security/OU=Infrastructure & Operations/CN=secmon.example.com"
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
sudo cp server.crt /etc/ssl/certs
sudo cp server.key /etc/ssl/private

### Setup Nginx
echo "Configure Nginx"
sudo cp /usr/local/src/security_monkey/nginx/security_monkey.conf /etc/nginx/sites-available/security_monkey.conf
sudo ln -s /etc/nginx/sites-available/security_monkey.conf /etc/nginx/sites-enabled/security_monkey.conf
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart

echo "Security Monkey Installation Completed Successfully"
