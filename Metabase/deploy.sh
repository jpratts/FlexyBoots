#! /bin/bash

# Variables
DOCKER_COMPOSE_VERSION="1.26.2"
METABASE_DATA_PATH="~/metabase-data"
METABASE_DB_FILE="/metabase-data/metabase.db"
METABASE_PORT="3000"
METABASE_NAME="metabase"
METABASE_IMAGE="metabase/metabase"

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

# Run Metabase as a Docker container
cd
docker run -d -p $METABASE_PORT:$METABASE_PORT \
    -v $METABASE_DATA_PATH:$METABASE_DATA_PATH \
    -e "MB_DB_FILE=$METABASE_DB_FILE" \
    --name $METABASE_NAME $METABASE_IMAGE

