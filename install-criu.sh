#!/bin/bash
sudo apt-get update && sudo apt-get install -y protobuf-c-compiler libprotobuf-c0-dev protobuf-compiler libprotobuf-dev:amd64 gcc build-essential bsdmainutils python git-core asciidoc make htop git curl supervisor cgroup-lite libapparmor-dev libseccomp-dev libprotobuf-dev libprotobuf-c0-dev protobuf-c-compiler protobuf-compiler python-protobuf libnl-3-dev libcap-dev libaio-dev apparmor libnet-dev
sudo mkdir ~/Documents/criu
cd criu
git clone https://github.com/xemul/criu criu
cd criu
sudo make clean
sudo make
sudo make install
sudo criu check
sudo criu check --all
