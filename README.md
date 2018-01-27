# Docker Container Live Migration Depends on CRIU & NFS

[![N|Solid](http://training.play-with-docker.com/images/docker-logo.svg)](http://training.play-with-docker.com/images/docker-logo.svg)

Prerequests:

  - Two Ubuntu16.04 servers with Linux kernel > 4.3
  - Host IP: 129.59.1.1
  - Client IP: 129.59.1.2

# Steps

  - Step 1: Configure NFS on host & client server
  - Step 2: Install Docker & CRIU on these two servers

### Step 1: Configure NFS on host & client server

- ##### Downloading and Installing the Components 
- On the host:
```sh
$ sudo apt-get update
$ sudo apt-get install nfs-kernel-server
```
- On the client:
```sh
$ sudo apt-get update
$ sudo apt-get install nfs-common
```
We export the host's /home directory. Since it already exists, we don’t need to create it. 

- ##### Configuring the NFS Exports on the Host Server
```sh
$ sudo nano /etc/exports
# Add the below line to exports file:
/home       129.59.1.2(rw,sync,no_root_squash,no_subtree_check)
# Then restart nfs-kernel-server service
$ sudo systemctl restart nfs-kernel-server
```
- ##### Adjusting the Firewall on the Host
```sh
# First, check firewall status
$ sudo ufw status
# If ufw is inactive, use the below command to enable ufw:
$ sudo ufw enable
# Make ufw allow incoming and outgoing:
$ sudo ufw default allow incoming
$ sudo ufw default allow outgoing
# Make client server can access host server
$ sudo ufw allow from 129.59.1.2 to any port nfs
# Check ufw status
$ sudo ufw status numbered
```
- ##### Creating the Mount Points on the Client
```sh
$ sudo mkdir -p /nfs/home
```
- ##### Mounting the Directory on the Client

```sh
sudo mount 129.59.1.1:/home /nfs/home
```
- ##### Checking the Mounted Directory on the Client
```sh
$ df -h
```
### Step 2: Downloading and Installing Docker & CRIU on Both Servers
- ##### If your kernel is older than 4.3, upgrade Linux Kernel for 64-bit System. Here is Linux 4.14...
``` sh
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-headers-4.14.0-041400_4.14.0-041400.201711122031_all.deb
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-headers-4.14.0-041400-generic_4.14.0-041400.201711122031_amd64.deb
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-image-4.14.0-041400-generic_4.14.0-041400.201711122031_amd64.deb
$ sudo dpkg -i *.deb
$ sudo reboot
```
- ##### Installing Docker-ce 17.03 through package

```sh
$ wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
$ sudo dpkg -i /path/to/package.deb
# Daemon environment will run automaticly

# Run docker without sudo
$ sudo groupadd docker
$ sudo usermod -aG docker $USER

# docker checkpoint is an experimental feature, so you should enable docker experimental feature
$ sudo nano /etc/docker/daemon.json
```

```Json
# Add the following code as content:
{
  "experimental":true
}
```
```sh
# Then check whether experimental feature has been enabled:
$ docker version
# You will see the value of "experimental" has been true.
```
- ##### Install CRIU 3.7
```sh
$ sudo apt-get update && sudo apt-get install -y protobuf-c-compiler libprotobuf-c0-dev protobuf-compiler libprotobuf-dev:amd64 gcc build-essential bsdmainutils python git-core asciidoc make htop git curl supervisor cgroup-lite libapparmor-dev libseccomp-dev libprotobuf-dev libprotobuf-c0-dev protobuf-c-compiler protobuf-compiler python-protobuf libnl-3-dev libcap-dev libaio-dev apparmor libnet-dev

$ git clone https://github.com/xemul/criu criu
$ cd criu
$ sudo make clean
$ sudo make 
$ sudo make install

# Then check if your criu works well
$ sudo criu check
$ sudo criu check --all
# You will see 'looks good'
```
- ##### Test your live migration
1. On the host
```sh
$ docker run -d --name looper2 --security-opt seccomp:unconfined busybox \
         /bin/sh -c 'i=0; while true; do echo $i; i=$(expr $i + 1); sleep 1; done'

# wait a few seconds to give the container an opportunity to print a few lines, then
$ docker checkpoint create --checkpoint-dir=/home/ubuntu/Container-Checkpoints/ looper2 checkpoint2

# check your container & print log file
$ docker ps
$ docker logs looper2
```
2. On the client
```sh
$ docker create --name looper-clone --security-opt seccomp:unconfined busybox \
         /bin/sh -c 'i=0; while true; do echo $i; i=$(expr $i + 1); sleep 1; done'

$ docker start --checkpoint-dir=/nfs/home/ubuntu/Container-Checkpoints/ --checkpoint=checkpoint2 looper-clone

# check your container
$ docekr ps
$ docker logs looper-clone
```
