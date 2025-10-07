#!/bin/bash
echo "Installing Media & Entertainment apps..."

# Install media apps
sudo apt install vlc obs-studio qbittorrent -y

# Install Steam
sudo apt install steam -y

# Install LocalSend
sudo apt install localsend -y

echo "Media apps installation complete!"