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


# Assosiate elastic ip 
sudo apt install awscli -y
instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
allocated_eip=44.199.93.146
REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
aws ec2 associate-address --instance-id $instance_id --public-ip $allocated_eip --region $REGION


# Create docker-compose stack for mediawiki
cat <<EOF > stack.yaml
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8080:80
    links:
      - database
    volumes:
      - /var/www/html/images
  database:
    image: mysql
    restart: always
    environment:
      MYSQL_DATABASE: mediawiki-ct-db
      MYSQL_USER: cloudteam
      MYSQL_PASSWORD: pVqNgSKm
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
EOF

# Initiate media wiki & mysql containers
sudo docker-compose -f stack.yaml up -d


# Install Backup prerequisite
sudo docker exec -it default_database_1 apt update -y
sudo docker exec -it default_database_1 apt install vim awscli -y

sudo cat << EOF > /home/ubuntu/debian.cnf
[client]
host     = localhost
user     = cloudteam
password = "pVqNgSKm"
socket   = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host     = localhost
user     = cloudteam
password = "pVqNgSKm"
socket   = /var/run/mysqld/mysqld.sock
basedir  = /usr
EOF

sudo docker cp /home/ubuntu/debian.cnf default_database_1:/etc/mysql/

sudo docker exec default_database_1 mkdir /root/backup-wiki

sudo cat << EOF > /home/ubuntu/crontab
0  1    * * *   root mysqldump -h database --no-tablespaces -u cloudteam --default-character-set=binary mediawiki-ct-db --password=pVqNgSKm > /root/backup-wiki/wiki-mediawiki-ct-db-$(date '+%Y%m%d').sql | aws s3 cp ~/backup-wiki/wiki-mediawiki-ct-db-$(date '+%Y%m%d').sql s3://mediawiki-cloudteam/backup-wiki/ 
EOF

sudo docker cp /home/ubuntu/crontab default_database_1:/etc/

aws s3 cp s3://mediawiki-cloudteam/backup-wiki/wiki-mediawiki-ct-db-$(date '+%Y%m%d').sql wiki-mediawiki-ct-db-$(date '+%Y%m%d').sql
sudo docker cp wiki-mediawiki-ct-db-$(date '+%Y%m%d').sql default_database_1:/root/backup-wiki/

aws s3 cp s3://mediawiki-cloudteam/backup-wiki/LocalSettings.php LocalSettings.php
sudo docker cp LocalSettings.php default_mediawiki_1:/var/www/html


sudo cat << EOF > /home/ubuntu/restoreDB.sh
 mysql -u cloudteam --password=pVqNgSKm mediawiki-ct-db < /root/backup-wiki/wiki-mediawiki-ct-db-$(date '+%Y%m%d').sql
EOF

sudo chmod +x /home/ubuntu/restoreDB.sh

sudo docker cp /home/ubuntu/restoreDB.sh default_database_1:/root

DATA_STATE="unknown"
until ["${DATA_STATE}" == "done"]; do
  sudo docker exec default_database_1 /bin/sh -c /root/restoreDB.sh
  sleep 10
  DATA_STATE="done"
done







