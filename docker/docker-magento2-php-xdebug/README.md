# Docker Magento 2 PHP Xdebug

Proof-of-concept Docker container for using Xdebug with Docker and PhpStorm

See https://serversforhackers.com/c/getting-xdebug-working

## Xdebug Setup

* Add the IP address of the host to `xdebug.ini`:
```bash
xdebug.remote_host=192.168.1.105
```
* Set the idekey to `docker`:
```bash
xdebug.idekey=docker
```

## PhpStorm Setup

* Create a new `Run configuration` (Run, Edit Configurations)
* Add a new `PHP Remote Debug` configuration
* Enable `Filter debug connection by IDE key`
* Set the IDE key to `docker`
* Create a new server configuration:
    * Host: `localhost`
    * Port: `80`
    * Debugger: `Xdebug`
    * Use path mappings: `Yes`
    * Map the webroot (`app`) to `/var/www/html`
* Enable `Start listening for PHP Debug connections`
    
## Run it

* Build the image:
```bash
docker-compose build
```
* Run the container:
```bash
docker-compose up -d
```
* Set a breakpoint in a PHP file in the project or enable the `Break on first line in PHP scripts` setting
* Drop the `XDEBUG_SESSION` cookie in a browser and refresh the page
* Or set the `XDEBUG_CONFIG` environment variable in a terminal, then execute the script:
```bash
export XDEBUG_CONFIG="idekey=docker"
```
