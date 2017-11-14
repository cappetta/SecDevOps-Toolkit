echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 xenial main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
sudo rm /var/lib/apt/lists/* -vf
sudo apt-get update -y && sudo apt-get upgrade -y
apt install -y --allow-unauthenticated openvpn
