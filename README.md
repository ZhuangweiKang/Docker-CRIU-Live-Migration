Install Docker CRIU on Ubuntu16.04 and Using NFS(Network File System) implements live migration on harware architecture.
# Docker CRIU
## Prerequisites

Ubuntu 16.04 Xenial with Linux kernel > 4.3.

### 1. Install Docker-ce 17.03
```sh
wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.0~ce-0~ubuntu-xenial_amd64.deb
sudo dpkg -i /path/to/package.deb
# Daemon environment will run automaticly

# Run docker without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# docker checkpoint is an experimental feature, so you should enable docker experimental feature
sudo nano /etc/docker/daemon.json
```

```Json
# Add the following code as content:
{
  "experimental":true
}
```
```sh
# Then check whether experimental feature has been enabled:
docker version
# You will see the value of "experimental" has been true.
```
### 2. Install CRIU 3.7
```sh
sudo apt-get update && sudo apt-get install -y protobuf-c-compiler libprotobuf-c0-dev protobuf-compiler libprotobuf-dev:amd64 gcc build-essential bsdmainutils python git-core asciidoc make htop git curl supervisor cgroup-lite libapparmor-dev libseccomp-dev libprotobuf-dev libprotobuf-c0-dev protobuf-c-compiler protobuf-compiler python-protobuf libnl-3-dev libcap-dev libaio-dev apparmor libnet-dev

git clone https://github.com/xemul/criu criu
cd criu
sudo make clean
sudo make 
sudo make install

# Then check if your criu works well
sudo criu check
sudo criu check --all
# You will see 'looks good'
```
### 3. Test your Docker CRIU
```sh
systemctl restart docker
docker run -d --name looper --security-opt seccomp:unconfined busybox  \
         /bin/sh -c 'i=0; while true; do echo $i; i=$(expr $i + 1); sleep 1; done'

# check docker logs by:
docker logs looper

# Create checkpoint for container looper
docker checkpoint create looper checkpoint1

# You can use the following code to check your checkpoint:
docker checkpoint ls looper

# Check the status of your container by:
docker ps
# The looper container has exited. 

# Restore you looper container
docker start --checkpoint checkpoint1 looper
docker ps   #or docker logs looper
# You'll see you container has been resumed.
```
