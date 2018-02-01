#!/bin/sh
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl –fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
which docker
sudo docker version
sudo usermod -aG docker $USER
echo "{\"experimental:true\"}" >> /etc/docker/daemon.json
sudo systemctl restart docker
sudo docker version
