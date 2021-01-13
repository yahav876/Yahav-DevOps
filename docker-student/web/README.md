# Make s3 bucket to mount with your docker container using Nginx image.

To mount s3 bucket we need to install a tool called s3fs
sudo apt install s3fs -y

mkdir /mnt/container-mount

sudo s3fs my-s3-bucket-name /mnt/container-mount -o allow_other -o default_acl=public-read -o use_cache=/tmp/s3fs 

than run the container with your local mount point 

docker run -d --name mount-s3bucket -p 80:80 --mount type=bind,src/mnt/container-mount,target=/usr/share/nginx/html,readonly nginx 

Done!

Now go to your ip address and check it out!
