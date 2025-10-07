#!/bin/bash
echo "Installing Graphite Theme..."

# Install Graphite GTK Theme
git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
cd Graphite-gtk-theme
./install.sh
cd ..
rm -rf Graphite-gtk-theme

echo "Graphite theme installation complete!"