
#!/bin/bash

# Variables
DOCKER_COMPOSE_VERSION="1.25.3"
AMUNDSEN_REPO="https://github.com/amundsen-io/amundsen.git"
AMUNDSEN_DIRECTORY="amundsen"

# Update and install dependencies
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker and Docker Compose
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo chmod 666 /var/run/docker.sock

# Enable and start Docker and Containerd services
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker.service
sudo systemctl start containerd.service

# Check status of the services
sudo systemctl status docker.service
sudo systemctl status containerd.service

# Clone Amundsen repository
git clone --recursive $AMUNDSEN_REPO

# Start Amundsen with Docker Compose
docker-compose -f docker-amundsen.yml up

# Setup Python environment for Amundsen Databuilder
cd $AMUNDSEN_DIRECTORY/databuilder
python3 -m venv venv
source venv/bin/activate
pip3 install --upgrade pip
pip3 install -r requirements.txt
python3 setup.py install

# Load sample data
python3 example/scripts/sample_data_loader.py
