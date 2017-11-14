echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 precise main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
apt-get update -y
apt-get install -y --allow-unauthenticated openvpn
