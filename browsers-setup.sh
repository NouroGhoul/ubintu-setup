#!/bin/bash
echo "Installing Web Browsers..."

# Install Brave (via apt)
sudo apt install brave-browser -y

# Install Google Chrome (download .deb)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt install -f -y
rm google-chrome-stable_current_amd64.deb

echo "Web browsers installation complete!"