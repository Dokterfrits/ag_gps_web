#!/bin/bash

# Function to display messages
echo_message() {
    echo -e "\n$1\n"
}

# Update package index and install prerequisites
echo_message "Updating package index and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
echo_message "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker stable repository
echo_message "Setting up the Docker stable repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, CLI, containerd, and Docker Compose plugin
echo_message "Installing Docker Engine, CLI, containerd, and Docker Compose plugin..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
echo_message "Verifying Docker installation..."
sudo docker --version
sudo docker-compose --version

# Add the current user to the Docker group
echo_message "Adding the current user to the Docker group..."
sudo usermod -aG docker $USER
echo_message "You may need to log out and log back in for the Docker group membership to take effect."

# Create a systemd service for Docker Compose
echo_message "Creating a systemd service for Docker Compose..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/docker-compose-app.service
[Unit]
Description=Docker Compose Application Service
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory='$PWD'
ExecStart=/usr/local/bin/docker-compose up --build -d
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd daemon
echo_message "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the systemd service to start on boot
echo_message "Enabling the systemd service to start on boot..."
sudo systemctl enable docker-compose-app.service

# Start the systemd service
echo_message "Starting the systemd service..."
sudo systemctl start docker-compose-app.service

echo_message "creating an external volume for docker..."
sudo docker volume create data-volume

# Final message
echo_message "Setup complete. Docker, Docker Compose have been installed, and the services are up and running. The Docker Compose application will also start on boot."
