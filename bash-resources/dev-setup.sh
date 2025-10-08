#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Development tools options
INSTALL_VSCODE=false
INSTALL_NODEJS=false
INSTALL_PYTHON=false
INSTALL_GIT=false
INSTALL_TMUX=false
INSTALL_VIM=false

show_dev_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║       DEVELOPMENT TOOLS SETUP        ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install All Development Tools  ║"
    echo -e "║  ${GREEN}2${BLUE}  Custom Selection               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_dev_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║      CUSTOM DEV TOOLS SELECTION      ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Visual Studio Code            ║"
    echo -e "║  ${GREEN}2${BLUE}  Node.js (via nvm)             ║"
    echo -e "║  ${GREEN}3${BLUE}  Python3 & pip                 ║"
    echo -e "║  ${GREEN}4${BLUE}  Git                           ║"
    echo -e "║  ${GREEN}5${BLUE}  Tmux                          ║"
    echo -e "║  ${GREEN}6${BLUE}  Vim                           ║"
    echo -e "║  ${GREEN}7${BLUE}  Install Selected              ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                         ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  VS Code: $([ "$INSTALL_VSCODE" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Node.js: $([ "$INSTALL_NODEJS" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Python3: $([ "$INSTALL_PYTHON" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Git: $([ "$INSTALL_GIT" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Tmux: $([ "$INSTALL_TMUX" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Vim: $([ "$INSTALL_VIM" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
}

install_vscode() {
    echo -e "\n${YELLOW}Installing Visual Studio Code...${NC}"
    
    if command -v code &> /dev/null; then
        echo -e "${YELLOW}VS Code is already installed. Skipping...${NC}"
        return 0
    fi

    # Try Snap installation first
    echo "Attempting Snap installation..."
    if sudo snap install code --classic; then
        if command -v code &> /dev/null; then
            echo -e "${GREEN}✓ VS Code installed successfully via Snap!${NC}"
            return 0
        fi
    fi

    echo -e "${YELLOW}Snap installation failed, trying direct .deb download...${NC}"

    # Install wget if not available
    if ! command -v wget &> /dev/null; then
        echo "Installing wget..."
        sudo apt install wget -y
    fi

    # Download VS Code .deb package directly as fallback
    echo "Downloading VS Code .deb package..."
    wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/385651c938df8a906869babee516bffd0ddb9829/code_1.104.3-1759409451_amd64.deb -O /tmp/vscode.deb

    if [ -f "/tmp/vscode.deb" ]; then
        echo "VS Code .deb package downloaded successfully!"
        
        # Install VS Code using dpkg
        echo "Installing VS Code with dpkg..."
        sudo dpkg -i /tmp/vscode.deb
        
        # Fix any dependency issues
        echo "Fixing dependencies..."
        sudo apt install -f -y
        
        # Clean up
        echo "Cleaning up temporary files..."
        rm /tmp/vscode.deb

        if command -v code &> /dev/null; then
            echo -e "${GREEN}✓ VS Code installed successfully via .deb!${NC}"
            return 0
        else
            echo -e "${YELLOW}VS Code installation completed but command not found immediately${NC}"
            echo -e "${YELLOW}Try launching from applications menu or restart your session${NC}"
            return 0
        fi
    else
        echo -e "${RED}✗ Failed to download VS Code .deb package${NC}"
        echo -e "${YELLOW}You can manually install VS Code from: https://code.visualstudio.com/${NC}"
        return 1
    fi
}

install_nodejs() {
    echo -e "\n${YELLOW}Installing Node.js via nvm...${NC}"
    
    # Install nvm (Node Version Manager)
    echo "Installing nvm..."
    if [ -d "$HOME/.nvm" ]; then
        echo -e "${YELLOW}nvm is already installed.${NC}"
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        
        # Load nvm immediately for current session
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        echo -e "${GREEN}✓ nvm installed successfully!${NC}"
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
        
        # Install global npm packages
        echo "Installing global npm packages..."
        npm install -g yarn pnpm nodemon typescript @angular/cli create-react-app
        
        NODE_VERSION=$(node -v)
        NPM_VERSION=$(npm -v)
        echo -e "${GREEN}✓ Node.js $NODE_VERSION installed successfully!${NC}"
        echo -e "${GREEN}✓ npm $NPM_VERSION configured${NC}"
        return 0
    else
        echo -e "${RED}✗ nvm not found! Installing Node.js via alternative method...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
        
        if command -v node &> /dev/null; then
            NODE_VERSION=$(node -v)
            echo -e "${GREEN}✓ Node.js $NODE_VERSION installed via alternative method!${NC}"
            return 0
        else
            echo -e "${RED}✗ Failed to install Node.js${NC}"
            return 1
        fi
    fi
}

install_python() {
    echo -e "\n${YELLOW}Installing Python3 and pip...${NC}"
    
    if command -v python3 &> /dev/null; then
        echo -e "${YELLOW}Python3 is already installed.${NC}"
        PYTHON_VERSION=$(python3 --version)
        echo -e "${GREEN}✓ $PYTHON_VERSION${NC}"
    else
        sudo apt install python3 python3-pip python3-venv -y
        if command -v python3 &> /dev/null; then
            PYTHON_VERSION=$(python3 --version)
            echo -e "${GREEN}✓ $PYTHON_VERSION installed successfully!${NC}"
        else
            echo -e "${RED}✗ Failed to install Python3${NC}"
            return 1
        fi
    fi

    # Check pip
    if command -v pip3 &> /dev/null; then
        PIP_VERSION=$(pip3 --version | head -n1)
        echo -e "${GREEN}✓ $PIP_VERSION${NC}"
    fi
    
    return 0
}

install_git() {
    echo -e "\n${YELLOW}Installing Git...${NC}"
    
    if command -v git &> /dev/null; then
        echo -e "${YELLOW}Git is already installed.${NC}"
        GIT_VERSION=$(git --version)
        echo -e "${GREEN}✓ $GIT_VERSION${NC}"
        return 0
    fi

    sudo apt install git -y

    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        echo -e "${GREEN}✓ $GIT_VERSION installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Git${NC}"
        return 1
    fi
}

install_tmux() {
    echo -e "\n${YELLOW}Installing Tmux...${NC}"
    
    if command -v tmux &> /dev/null; then
        echo -e "${YELLOW}Tmux is already installed.${NC}"
        TMUX_VERSION=$(tmux -V)
        echo -e "${GREEN}✓ $TMUX_VERSION${NC}"
        return 0
    fi

    sudo apt install tmux -y

    if command -v tmux &> /dev/null; then
        TMUX_VERSION=$(tmux -V)
        echo -e "${GREEN}✓ $TMUX_VERSION installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Tmux${NC}"
        return 1
    fi
}

install_vim() {
    echo -e "\n${YELLOW}Installing Vim...${NC}"
    
    if command -v vim &> /dev/null; then
        echo -e "${YELLOW}Vim is already installed.${NC}"
        VIM_VERSION=$(vim --version | head -n1)
        echo -e "${GREEN}✓ $VIM_VERSION${NC}"
        return 0
    fi

    sudo apt install vim -y

    if command -v vim &> /dev/null; then
        VIM_VERSION=$(vim --version | head -n1)
        echo -e "${GREEN}✓ $VIM_VERSION installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Vim${NC}"
        return 1
    fi
}

confirm_installation() {
    local selections=()
    [ "$INSTALL_VSCODE" = true ] && selections+=("Visual Studio Code")
    [ "$INSTALL_NODEJS" = true ] && selections+=("Node.js with nvm")
    [ "$INSTALL_PYTHON" = true ] && selections+=("Python3 & pip")
    [ "$INSTALL_GIT" = true ] && selections+=("Git")
    [ "$INSTALL_TMUX" = true ] && selections+=("Tmux")
    [ "$INSTALL_VIM" = true ] && selections+=("Vim")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No development tools selected for installation.${NC}"
        return 1
    fi

    echo -e "\n${YELLOW}The following will be installed:${NC}"
    for item in "${selections[@]}"; do
        echo -e "  ${GREEN}✓${NC} $item"
    done
    
    echo -e "\n${YELLOW}Are you sure you want to proceed? (y/n)${NC}"
    read -p "Choice: " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        return 0
    else
        echo -e "${YELLOW}Installation cancelled.${NC}"
        return 1
    fi
}

install_dependencies() {
    echo -e "\n${YELLOW}Installing system dependencies...${NC}"
    sudo apt update
    sudo apt install curl wget build-essential -y
    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

install_selected_tools() {
    local success=true
    
    # Install system dependencies first
    install_dependencies
    
    # Install in logical order
    if [ "$INSTALL_GIT" = true ]; then
        install_git
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_PYTHON" = true ]; then
        install_python
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_NODEJS" = true ]; then
        install_nodejs
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_VSCODE" = true ]; then
        install_vscode
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_TMUX" = true ]; then
        install_tmux
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_VIM" = true ]; then
        install_vim
        [ $? -ne 0 ] && success=false
    fi
    
    # Verify installations
    echo -e "\n${YELLOW}Verifying installations...${NC}"
    
    if [ "$INSTALL_VSCODE" = true ]; then
        if command -v code &> /dev/null; then
            echo -e "${GREEN}✓ VS Code: Installed${NC}"
        else
            echo -e "${RED}✗ VS Code: Not found${NC}"
        fi
    fi
    
    if [ "$INSTALL_NODEJS" = true ]; then
        if command -v node &> /dev/null; then
            echo -e "${GREEN}✓ Node.js: $(node -v)${NC}"
        else
            echo -e "${RED}✗ Node.js: Not found${NC}"
        fi
    fi
    
    if [ "$INSTALL_PYTHON" = true ]; then
        if command -v python3 &> /dev/null; then
            echo -e "${GREEN}✓ Python3: $(python3 --version)${NC}"
        else
            echo -e "${RED}✗ Python3: Not found${NC}"
        fi
    fi
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ Development tools installation completed!${NC}"
        if [ "$INSTALL_NODEJS" = true ]; then
            echo -e "${YELLOW}Note: You may need to restart your terminal or run 'source ~/.bashrc' for nvm to work in new sessions.${NC}"
        fi
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main development tools installation logic
echo -e "${YELLOW}Development Tools Setup${NC}"

while true; do
    show_dev_menu
    read -p "Choose an option (0-2): " main_choice
    
    case $main_choice in
        1)
            # Install all tools
            INSTALL_VSCODE=true
            INSTALL_NODEJS=true
            INSTALL_PYTHON=true
            INSTALL_GIT=true
            INSTALL_TMUX=true
            INSTALL_VIM=true
            if confirm_installation; then
                install_selected_tools
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Custom selection
            while true; do
                show_custom_dev_menu
                read -p "Choose an option (0-7): " custom_choice
                
                case $custom_choice in
                    1)
                        INSTALL_VSCODE=$([ "$INSTALL_VSCODE" = true ] && echo false || echo true)
                        ;;
                    2)
                        INSTALL_NODEJS=$([ "$INSTALL_NODEJS" = true ] && echo false || echo true)
                        ;;
                    3)
                        INSTALL_PYTHON=$([ "$INSTALL_PYTHON" = true ] && echo false || echo true)
                        ;;
                    4)
                        INSTALL_GIT=$([ "$INSTALL_GIT" = true ] && echo false || echo true)
                        ;;
                    5)
                        INSTALL_TMUX=$([ "$INSTALL_TMUX" = true ] && echo false || echo true)
                        ;;
                    6)
                        INSTALL_VIM=$([ "$INSTALL_VIM" = true ] && echo false || echo true)
                        ;;
                    7)
                        if confirm_installation; then
                            install_selected_tools
                            read -p "Press Enter to continue..."
                            break
                        fi
                        ;;
                    0)
                        break
                        ;;
                    *)
                        echo -e "${RED}Invalid option!${NC}"
                        read -p "Press Enter to continue..."
                        ;;
                esac
            done
            ;;
        0)
            echo -e "${GREEN}Returning to main menu...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done