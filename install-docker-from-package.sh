#!/bin/sh
cd /home/ubuntu/Docker-CRIU-Live-Migration/
sudo wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo dpkg -i docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
# Daemon environment will run automaticly

# Run docker without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# docker checkpoint is an experimental feature, so you should enable docker experimental feature
echo "{\"experimental:\":true}" >> /etc/docker/daemon.json
sudo systemctl restart docker

sudo docker version
