#!/bin/sh

# Install docker & docker-compose
sudo apt-get update -y
sudo apt-get install \
apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io hwinfo -y
sudo systemctl enable docker
sudo systemctl start docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# Create docker-compose stack for openvpn
cat <<EOF > stack.yaml
version: '2'
services:
  openvpn:
    cap_add:
     - NET_ADMIN
    image: kylemanna/openvpn
    container_name: openvpn
    ports:
     - "1194:1194/udp"
    restart: always
    volumes:
     - ./openvpn-data/conf:/etc/openvpn

EOF

# Initialize the configuration files and certificates
sudo docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
sudo docker-compose run --rm openvpn ovpn_initpki

# Initiate openVPN container
sudo docker-compose -f stack.yaml up -d

# Generate a client certificate
export CLIENTNAME="circles-up-test"
# with a passphrase (recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
# # without a passphrase (not recommended)
# docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass

