#! /bin/bash

# And I can't find my handy distro detecting code anywhere  :(
# One of these will work for most main distros while the non-working will be ignored
yum install docker -y
apt-get install docker -y

# start Docker
systemctl start docker

# Install Grafana via constainer (controlled version, of course)
docker run -d -p 3000:3000 --name grafana grafana/grafana:6.5.0
