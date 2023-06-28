#! /bin/bash

# Variables
DOCKER_COMPOSE_VERSION="1.26.2"
AIRBYTE_REPO="https://github.com/airbytehq/airbyte.git"
AIRBYTE_DIRECTORY="airbyte"

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common wget

# Add Docker's GPG key and repo
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Update again and install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add user to Docker group
sudo usermod -a -G docker $USER

# Install Docker Compose
sudo wget https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) -O /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose version
docker-compose --version

# Check if Airbyte directory exists and clone if not
cd
if [[ ! -e $AIRBYTE_DIRECTORY ]]; then
    git clone $AIRBYTE_REPO
elif [[ ! -d $AIRBYTE_DIRECTORY ]]; then
    echo "$AIRBYTE_DIRECTORY already exists but is not a directory" 1>&2
fi

# Navigate to Airbyte directory and start up the Docker Compose
cd $AIRBYTE_DIRECTORY
docker-compose up -d

