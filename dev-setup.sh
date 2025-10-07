#!/bin/bash
echo "Installing Development Tools..."

# Install core development tools
sudo apt install tmux git vim -y

# Install VS Code (Snap)
sudo snap install code --classic

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Python3 and pip
sudo apt install python3 python3-pip -y

echo "Development tools installation complete!"