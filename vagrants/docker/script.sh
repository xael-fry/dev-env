#!/bin/bash
# Author - Alexandre Chatiron


# Variables
DOCKER_VERSION=v0.16.1


# read env  config
ENV_FILE="$1"
HTTP_PROXY=

if [ -f "$ENV_FILE" ]; then
    echo -e "reading file $ENV_FILE"
    while IFS='=' read -r key value
    do
        key="ENV_"$(echo $key | tr '.' '_')
        eval ${key}=\${value}
    done <<< $(cat $ENV_FILE)

    HTTP_PROXY="${ENV_HTTP_PROXY}"
fi

echo -e "\n--- Setup proxy .. ---\n"

if [ -n "$HTTP_PROXY" ]; then
    echo "use proxy to ${HTTP_PROXY}"
    export http_proxy=${HTTP_PROXY}
    export https_proxy=${HTTP_PROXY}
    export ftp_proxy=${HTTP_PROXY}

    sudo sed -i "/.*use_proxy = .*/c use_proxy = on" /etc/wgetrc
    sudo sed -i "/.*http_proxy = .*/c http_proxy = $HTTP_PROXY" /etc/wgetrc
    sudo sed -i "/.*https_proxy = .*/c https_proxy = $HTTP_PROXY" /etc/wgetrc
    sudo sed -i "/.*ftp_proxy = .*/c ftp_proxy = $HTTP_PROXY" /etc/wgetrc
    sudo echo "Acquire::http::Proxy \"$HTTP_PROXY\";" | sudo tee /etc/apt/apt.conf

else
    echo "turn off proxy"
    sudo sed -i "/.*use_proxy = .*/c use_proxy = off" /etc/wgetrc

    unset http_proxy
    unset https_proxy
    unset ftp_proxy
fi    

sudo apt-get install -y --reinstall ca-certificates
sudo update-ca-certificates


echo -e "\n--- Installing now... ---\n"

# Install using the repository

## Set up the repository
sudo apt-get update


### Install packages to allow apt to use a repository over HTTPS:

sudo apt-get install -y\
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

### Add Dockers official GPG key:

sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

### Verify that you now have the key with the fingerprint
sudo apt-key fingerprint 0EBFCD88

### Use the following command to set up the stable repository. 

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
   
   
# Install Docker CE

## Update the apt package index

sudo apt-get update

## Install the latest version of Docker CE and containerd

sudo apt-get install -y docker-ce docker-ce-cli containerd.io


    sudo usermod -a -G docker $USER

# First, create a systemd drop-in directory for the Docker service:
# 
# mkdir /etc/systemd/system/docker.service.d
# 
# Now create a file called /etc/systemd/system/docker.service.d/http-proxy.conf that adds the HTTP_PROXY environment variable:
# 
# [Service]
# Environment="HTTP_PROXY=http://proxy.example.com:80/"
# 
# If you have internal Docker registries that you need to contact without proxying you can specify them via the NO_PROXY environment variable:
# 
# Environment="HTTP_PROXY=http://proxy.example.com:80/"
# Environment="NO_PROXY=localhost,127.0.0.0/8,docker-registry.somecorporation.com"
# 
# Flush changes:
# 
# $ sudo systemctl daemon-reload
# 
# Verify that the configuration has been loaded:
# 
# $ sudo systemctl show --property Environment docker
# Environment=HTTP_PROXY=http://proxy.example.com:80/
# 
# Restart Docker:
# 
# $ sudo systemctl restart docker

# https://blog.codeship.com/using-docker-behind-a-proxy/
