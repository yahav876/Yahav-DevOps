#!/bin/bash

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
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable docker
sudo systemctl stop docker
sudo mkfs -t ext4 /dev/xvdb
sudo mkdir  /mnt/neura
sudo mount /dev/xvdb /mnt/neura
sudo rsync -aP /var/lib/docker/ /mnt/neura
sudo mv /var/lib/docker /var/lib/docker.old

sudo touch /etc/docker/daemon.json
sudo echo \
"{
   \"data-root\": \"/mnt/neura\"
}" > /etc/docker/daemon.json

sudo systemctl restart docker

sudo docker run -d -p 3000:3000 grafana/grafana
sudo docker run -d \
 --name graphite \
 --restart=always \
 -p 80:80 \
 -p 2003-2004:2003-2004 \
 -p 2023-2024:2023-2024 \
 -p 8125:8125/udp \
 -p 8126:8126 \
 graphiteapp/graphite-statsd