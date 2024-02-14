#! /bin/bash

# And I can't find my handy distro detecting code anywhere  :(
# One of these will work for most main distros while the non-working will be ignored

# Ubuntu/similar
apt-get update
apt install docker.io -y

# RPM-based
yum install docker -y
systemctl start docker

# Install Grafana via container (controlled version, of course)
docker run -d -p 3000:3000 --name grafana grafana/grafana:6.5.0
