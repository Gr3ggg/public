# How to Install OpenVPN Server on Ubuntu
# https://github.com/angristan/openvpn-install

curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
./openvpn-install.sh

# You need to run the script as root and have the TUN module enabled.
# The first time you run it, you’ll have to follow the assistant and answer a few questions to setup your VPN server.