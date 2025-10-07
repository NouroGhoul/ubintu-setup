#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing Terminal & Shell enhancements...${NC}"

# Install Zsh
echo "Installing Zsh..."
sudo apt install zsh -y

# Change default shell to Zsh
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Oh My Zsh is already installed. Skipping...${NC}"
else
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    # Create a default .zshrc file if it doesn't exist
    if [ ! -f "$HOME/.zshrc" ]; then
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    fi
    echo -e "${GREEN}Oh My Zsh installed successfully!${NC}"
fi

# Install Powerlevel10k theme
echo "Installing Powerlevel10k theme..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo -e "${YELLOW}Powerlevel10k is already installed. Skipping...${NC}"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "${GREEN}Powerlevel10k installed successfully!${NC}"
    
    # Update .zshrc to use powerlevel10k theme
    if [ -f "$HOME/.zshrc" ]; then
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
        echo -e "${GREEN}Updated .zshrc to use powerlevel10k theme${NC}"
    fi
fi

# Install useful Oh My Zsh plugins
echo "Installing useful Oh My Zsh plugins..."

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Update .zshrc with recommended plugins
if [ -f "$HOME/.zshrc" ]; then
    # Check if plugins are already set
    if ! grep -q "plugins=(" ~/.zshrc; then
        echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
    else
        # Update existing plugins line to include our plugins
        sed -i 's/^plugins=(/plugins=(git zsh-autosuggestions zsh-syntax-highlighting /' ~/.zshrc
    fi
    echo -e "${GREEN}Updated .zshrc with recommended plugins${NC}"
fi

echo -e "${GREEN}Terminal setup complete!${NC}"
echo -e "${YELLOW}Please log out and log back in for Zsh to take effect.${NC}"
echo -e "${YELLOW}After logging back in, run: ${GREEN}p10k configure${YELLOW} to set up your prompt.${NC}"