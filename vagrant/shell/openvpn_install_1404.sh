echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 trusty main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
apt update -y
apt install -y --allow-unauthenticated openvpn
