#!/bin/bash
cd ~/Documents
sudo mkdir Docker
cd Docker
wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo dpkg -i docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo groupadd docker
which docker
sudo usermod -aG docker $USER
echo "{\"experimental\":true}" > /etc/docker/daemon.json
cat /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
