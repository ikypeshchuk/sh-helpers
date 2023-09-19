#!/bin/sh

# Update the system
sudo apt update && sudo apt upgrade -y

# Install curl if not already installed
sudo apt install -y curl

# Download Docker to the system
curl -fsSL https://get.docker.com -o get-docker.sh

# Run Docker installation
sh get-docker.sh

# Add the user to the Docker group
sudo groupadd docker
sudo usermod -aG docker $USER

# Check Docker version
sudo docker version

# Install Docker Machine
# Get the latest release of Docker Machine
LATEST_MACHINE_RELEASE=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/docker/machine/releases/latest)
LATEST_MACHINE_VERSION=$(echo $LATEST_MACHINE_RELEASE | grep -oP "[^/]+$")

base="https://github.com/docker/machine/releases/download/$LATEST_MACHINE_VERSION" &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
chmod +x /usr/local/bin/docker-machine

# Check Docker Machine version
docker-machine version

# Install Docker Compose
# Get the latest release of Docker Compose
LATEST_COMPOSE_RELEASE=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/docker/compose/releases/latest)
LATEST_COMPOSE_VERSION=$(echo $LATEST_COMPOSE_RELEASE | grep -oP "[^/]+$")

sudo curl -L "https://github.com/docker/compose/releases/download/$LATEST_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Change permissions for Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Create a symbolic link for Docker Compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Check Docker Compose version
docker-compose --version

# Clean up temporary files
rm get-docker.sh

