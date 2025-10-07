#!/bin/bash
echo "Installing Terminal & Shell enhancements..."

# Install Zsh
sudo apt install zsh -y

# Change default shell to Zsh
chsh -s $(which zsh)

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Terminal setup complete! Please log out and log back in for Zsh to take effect."
echo "After logging back in, run: p10k configure"