#!/bin/bash
exec sudo apt-get update && sudo apt-get install -y protobuf-c-compiler libprotobuf-c0-dev protobuf-compiler libprotobuf-dev:amd64 gcc build-essential bsdmainutils python git-core asciidoc make htop git curl supervisor cgroup-lite libapparmor-dev libseccomp-dev libprotobuf-dev libprotobuf-c0-dev protobuf-c-compiler protobuf-compiler python-protobuf libnl-3-dev libcap-dev libaio-dev apparmor libnet-dev
exec sudo mkdir ~/Documents/criu
exec cd criu
exec git clone https://github.com/xemul/criu criu
exec cd criu
exec sudo make clean
exec sudo make
exec sudo make install
exec sudo criu check
exec sudo criu check --all
