#!/bin/bash

# Install docker
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



# Format second disk to ext4 and configure Docker to save all data in that disk.
hw=$(hwinfo --disk | grep 'Device File:' | cut -d ' ' -f5)
disk=$(echo $hw | cut -d ' ' -f2)
sudo mkfs -t ext4 $disk
sudo mkdir  /mnt/example
sudo mount /dev/xvdb /mnt/example
sudo rsync -aP /var/lib/docker/ /mnt/example
sudo mv /var/lib/docker /var/lib/docker.old
sudo touch /etc/docker/daemon.json
sudo echo \
"{
   \"data-root\": \"/mnt/example\"
}" > /etc/docker/daemon.json
sudo systemctl restart docker

# Run Grafana & Graphite containers
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
