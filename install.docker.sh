#!/bin/bash

apt-get -yq update && apt-get -yq upgrade && apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -qy

# Enable net.ipv4.ip_forward for the system
	echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/30-project-forward.conf
# Enable without waiting for a reboot or service restart
	echo 1 > /proc/sys/net/ipv4/ip_forward
		# Enable net.ipv6.conf.all.forwarding for the system
		echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-openvpn-forward.conf
		# Enable without waiting for a reboot or service restart
		echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

	

# Add Repos
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

	

# Install Dependancies

apt-get update -yq && \
apt-get -yq install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  htop \
  iftop \
  sudo \
  vnstat \
  curl \
  git \
  nano \
  wget \
  docker-ce \
  docker-ce-cli \
  containerd.io
  
# Get Variables..
COMPOSE_VERSION=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1)
  
# Enable & Start Docker
systemctl enable docker
systemctl start docker

# Confirm Docker Install
docker version

# Install Docker-Compose
wget  https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)
sudo mv ./docker-compose-$(uname -s)-$(uname -m) /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
export PATH=$PATH:/usr/bin/docker-compose
echo "export PATH=$PATH:/usr/bin/docker-compose" >>  $HOME/.bash_profile
echo "Confirming Docker-Compose is operating"
docker-compose --version
	
# Install Docker-Cleanup ( https://gist.github.com/wdullaer/76b450a0c986e576e98b )
git clone https://gist.github.com/76b450a0c986e576e98b.git /tmp/ixpcontrol/docker-cleanup
mv /tmp/ixpcontrol/docker-cleanup/docker-cleanup /usr/local/bin/docker-cleanup
sudo chmod +x /usr/local/bin/docker-cleanup


mkdir -p /opt/apps;
mkdir -p /opt/data;
