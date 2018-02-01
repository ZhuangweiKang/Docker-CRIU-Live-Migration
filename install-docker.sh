#!/bin/sh
cd /home/ubuntu/Docker-CRIU-Live-Migration/
sudo apt-get update
sudo apt-get install wget
sudo wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo dpkg -i docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl restart docker
echo "{\"experimental:\"true}" >> /etc/docker/daemon.json
sudo systemctl restart docker
sudo docker version
