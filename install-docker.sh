#!/bin/bash
exec cd ~/
exec sudo mkdir Docker
exec cd Docker
exec wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
exec sudo dpkg -i docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
exec sudo groupadd docker
exec which docker
exec sudo usermod -aG docker $USER
echo "{\"experimental\":true}" > /etc/docker/daemon.json
exec cat /etc/docker/daemon.json
exec sudo systemctl daemon-reload
exec sudo systemctl restart docker
