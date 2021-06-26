#! /bin/bash

# Because I have no idea what your favorite distro is...
if [ -n "$(command -v yum)" ]; then
yum install docker -y
elif [ -n "$(command -v apt-get)" ]; then
apt-get install docker -y

# start Docker
systemctl start docker

# Install Grafana via constainer (controlled version, of course)
docker run -d -p 3000:3000 --name grafana grafana/grafana:6.5.0
