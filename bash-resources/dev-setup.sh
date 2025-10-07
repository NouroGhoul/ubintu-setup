#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing Development Tools...${NC}"

# Install core development tools
echo "Installing core development tools..."
sudo apt install tmux git vim build-essential -y

# Install VS Code (Snap)
echo "Installing VS Code..."
sudo snap install code --classic

# Install nvm (Node Version Manager)
echo "Installing nvm (Node Version Manager)..."
if [ -d "$HOME/.nvm" ]; then
    echo -e "${YELLOW}nvm is already installed. Skipping...${NC}"
else
    # Download and install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    
    # Load nvm immediately for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    
    echo -e "${GREEN}nvm installed successfully!${NC}"
fi

# Source nvm for this script session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install and use Node.js LTS
echo "Installing Node.js LTS..."
if command -v nvm &> /dev/null; then
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    echo -e "${GREEN}Node.js LTS installed successfully!${NC}"
else
    echo -e "${RED}nvm not found! Installing Node.js via alternative method...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Install Python3 and pip
echo "Installing Python3 and pip..."
sudo apt install python3 python3-pip python3-venv -y

# Verify installations
echo -e "\n${YELLOW}Verifying installations...${NC}"

# Check Node.js and npm
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓ Node.js: $NODE_VERSION${NC}"
else
    echo -e "${RED}✗ Node.js not installed${NC}"
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓ npm: $NPM_VERSION${NC}"
else
    echo -e "${RED}✗ npm not installed${NC}"
fi

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✓ $PYTHON_VERSION${NC}"
else
    echo -e "${RED}✗ Python3 not installed${NC}"
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✓ $GIT_VERSION${NC}"
else
    echo -e "${RED}✗ Git not installed${NC}"
fi

# Install global npm packages
echo -e "\n${YELLOW}Installing useful global npm packages...${NC}"
npm install -g yarn pnpm nodemon typescript @angular/cli create-react-app

echo -e "\n${GREEN}Development tools installation complete!${NC}"
echo -e "${YELLOW}Note: You may need to restart your terminal or run 'source ~/.bashrc' for nvm to work in new sessions.${NC}"