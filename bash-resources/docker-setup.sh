#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Docker setup options
INSTALL_DOCKER_ENGINE=false
INSTALL_DOCKER_DESKTOP=false
INSTALL_DOCKER_COMPOSE=false
ADD_USER_TO_DOCKER_GROUP=true

show_docker_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║          DOCKER SETUP                ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install Docker Engine Only      ║"
    echo -e "║  ${GREEN}2${BLUE}  Install Docker Desktop          ║"
    echo -e "║  ${GREEN}3${BLUE}  Custom Selection                ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_docker_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║        CUSTOM DOCKER SELECTION       ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Docker Engine                  ║"
    echo -e "║  ${GREEN}2${BLUE}  Docker Desktop                 ║"
    echo -e "║  ${GREEN}3${BLUE}  Docker Compose V2              ║"
    echo -e "║  ${GREEN}4${BLUE}  Add user to docker group       ║"
    echo -e "║  ${GREEN}5${BLUE}  Install Selected               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  Docker Engine: $([ "$INSTALL_DOCKER_ENGINE" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Docker Desktop: $([ "$INSTALL_DOCKER_DESKTOP" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Docker Compose: $([ "$INSTALL_DOCKER_COMPOSE" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Add to docker group: $([ "$ADD_USER_TO_DOCKER_GROUP" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
}

check_docker_installed() {
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        echo -e "${YELLOW}Docker is already installed: $DOCKER_VERSION${NC}"
        return 0
    fi
    return 1
}

check_docker_desktop_installed() {
    if systemctl --user is-active --quiet docker-desktop 2>/dev/null || \
       [ -f "/opt/docker-desktop/bin/docker-desktop" ]; then
        echo -e "${YELLOW}Docker Desktop appears to be installed${NC}"
        return 0
    fi
    return 1
}

check_ubuntu_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo -e "${YELLOW}Detected: $NAME $VERSION_ID ($VERSION_CODENAME)${NC}"
        
        # Check for supported Ubuntu versions for Docker Engine
        case $VERSION_CODENAME in
            "noble"|"jammy"|"plucky"|"questing")
                echo -e "${GREEN}✓ Supported Ubuntu version for Docker Engine${NC}"
                return 0
                ;;
            *)
                echo -e "${YELLOW}⚠ Ubuntu $VERSION_ID - Docker may have limited support${NC}"
                return 1
                ;;
        esac
    else
        echo -e "${RED}✗ Could not detect Ubuntu version${NC}"
        return 1
    fi
}

uninstall_conflicting_packages() {
    echo -e "\n${YELLOW}Checking for conflicting packages...${NC}"
    
    # List of conflicting packages
    local conflicting_packages="docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc"
    
    # Check which ones are installed
    local installed_packages=$(dpkg --get-selections $conflicting_packages 2>/dev/null | grep -v deinstall | cut -f1)
    
    if [ -n "$installed_packages" ]; then
        echo -e "${YELLOW}Found conflicting packages:${NC}"
        for pkg in $installed_packages; do
            echo -e "  ${RED}✗${NC} $pkg"
        done
        
        echo -e "\n${YELLOW}Do you want to uninstall these conflicting packages? (y/n)${NC}"
        read -p "Choice: " choice
        
        if [[ $choice =~ ^[Yy]$ ]]; then
            echo "Uninstalling conflicting packages..."
            sudo apt remove $installed_packages -y
            echo -e "${GREEN}✓ Conflicting packages uninstalled${NC}"
        else
            echo -e "${YELLOW}⚠ Skipping removal of conflicting packages${NC}"
            echo -e "${YELLOW}This may cause installation issues${NC}"
        fi
    else
        echo -e "${GREEN}✓ No conflicting packages found${NC}"
    fi
}

setup_docker_repository() {
    echo -e "\n${YELLOW}Setting up Docker's apt repository...${NC}"
    
    # Update package index
    sudo apt update
    
    # Install prerequisites
    echo "Installing prerequisites..."
    sudo apt install ca-certificates curl -y
    
    # Add Docker's official GPG key
    echo "Adding Docker's GPG key..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources
    echo "Adding Docker repository to sources..."
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    
    # Update package index again
    sudo apt update
    
    echo -e "${GREEN}✓ Docker repository configured${NC}"
}

install_docker_engine() {
    echo -e "\n${YELLOW}Installing Docker Engine...${NC}"
    
    if check_docker_installed; then
        echo -e "${YELLOW}Skipping Docker Engine installation${NC}"
        return 0
    fi
    
    # Check Ubuntu version
    if ! check_ubuntu_version; then
        echo -e "${RED}✗ Unsupported Ubuntu version for Docker Engine${NC}"
        return 1
    fi
    
    # Uninstall conflicting packages
    uninstall_conflicting_packages
    
    # Setup Docker repository
    setup_docker_repository
    
    # Install Docker packages
    echo "Installing Docker packages..."
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    
    if check_docker_installed; then
        echo -e "${GREEN}✓ Docker Engine installed successfully!${NC}"
        
        # Start and enable Docker service
        echo "Starting Docker service..."
        sudo systemctl start docker
        sudo systemctl enable docker
        
        # Verify Docker is running
        if sudo systemctl is-active --quiet docker; then
            echo -e "${GREEN}✓ Docker service is running${NC}"
        else
            echo -e "${YELLOW}⚠ Docker service may need manual start${NC}"
            sudo systemctl start docker
        fi
        
        return 0
    else
        echo -e "${RED}✗ Failed to install Docker Engine${NC}"
        return 1
    fi
}

install_docker_desktop() {
    echo -e "\n${YELLOW}Installing Docker Desktop...${NC}"
    
    check_ubuntu_version
    
    if check_docker_desktop_installed; then
        echo -e "${YELLOW}Skipping Docker Desktop installation${NC}"
        return 0
    fi

    # Install GNOME Terminal if not installed (required for Docker Desktop)
    echo "Checking for GNOME Terminal..."
    if ! command -v gnome-terminal &> /dev/null; then
        echo "Installing GNOME Terminal..."
        sudo apt install gnome-terminal -y
    fi

    # Create downloads directory if it doesn't exist
    mkdir -p ~/Downloads

    # Download Docker Desktop DEB package
    echo "Downloading Docker Desktop..."
    
    # Use latest stable version
    DOCKER_DEB_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"
    DOCKER_DEB_PATH="$HOME/Downloads/docker-desktop-amd64.deb"
    
    wget -q --show-progress -O "$DOCKER_DEB_PATH" "$DOCKER_DEB_URL"

    if [ -f "$DOCKER_DEB_PATH" ]; then
        echo "Docker Desktop package downloaded successfully!"
        
        # Install Docker Desktop
        echo "Installing Docker Desktop..."
        sudo apt update
        sudo apt install "$DOCKER_DEB_PATH" -y
        
        # Clean up
        rm "$DOCKER_DEB_PATH"
        
        # Verify installation
        if [ -f "/opt/docker-desktop/bin/docker-desktop" ]; then
            echo -e "${GREEN}✓ Docker Desktop installed successfully!${NC}"
            
            # Start Docker Desktop
            echo "Starting Docker Desktop..."
            systemctl --user start docker-desktop
            systemctl --user enable docker-desktop
            
            return 0
        else
            echo -e "${YELLOW}⚠ Docker Desktop files found but may need manual setup${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to download Docker Desktop package${NC}"
        return 1
    fi
}

install_docker_compose() {
    echo -e "\n${YELLOW}Installing Docker Compose...${NC}"
    
    # Check if Docker Compose is already installed
    if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
        echo -e "${YELLOW}Docker Compose is already installed${NC}"
        if command -v docker-compose &> /dev/null; then
            DOCKER_COMPOSE_VERSION=$(docker-compose --version)
            echo -e "${GREEN}✓ $DOCKER_COMPOSE_VERSION${NC}"
        fi
        if docker compose version &> /dev/null; then
            DOCKER_COMPOSE_V2=$(docker compose version)
            echo -e "${GREEN}✓ $DOCKER_COMPOSE_V2${NC}"
        fi
        return 0
    fi

    # Note: docker-compose-plugin should already be installed with docker-ce
    # If not, we'll install it manually
    if ! dpkg -l | grep -q docker-compose-plugin; then
        echo "Installing Docker Compose plugin..."
        sudo apt install docker-compose-plugin -y
    fi

    if docker compose version &> /dev/null; then
        DOCKER_COMPOSE_VERSION=$(docker compose version)
        echo -e "${GREEN}✓ $DOCKER_COMPOSE_VERSION${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Docker Compose${NC}"
        return 1
    fi
}

add_user_to_docker_group() {
    echo -e "\n${YELLOW}Adding user to docker group...${NC}"
    
    # Check if user is already in docker group
    if groups $USER | grep -q '\bdocker\b'; then
        echo -e "${YELLOW}User is already in docker group${NC}"
        return 0
    fi

    # Add user to docker group
    sudo usermod -aG docker $USER
    
    echo -e "${GREEN}✓ User added to docker group${NC}"
    echo -e "${YELLOW}Note: You need to log out and log back in for this to take effect${NC}"
    echo -e "${YELLOW}After logging back in, you can run docker commands without sudo${NC}"
    
    return 0
}

test_docker_installation() {
    echo -e "\n${YELLOW}Testing Docker installation...${NC}"
    
    # Test with hello-world image
    echo "Running hello-world container..."
    if sudo docker run --rm hello-world 2>&1 | grep -q "Hello from Docker!"; then
        echo -e "${GREEN}✓ Docker test successful!${NC}"
        return 0
    else
        echo -e "${RED}✗ Docker test failed${NC}"
        return 1
    fi
}

verify_docker_installation() {
    echo -e "\n${YELLOW}Verifying Docker installation...${NC}"
    
    local success=true
    
    if [ "$INSTALL_DOCKER_ENGINE" = true ] || [ "$INSTALL_DOCKER_DESKTOP" = true ]; then
        if check_docker_installed; then
            echo -e "${GREEN}✓ Docker Engine: $(docker --version)${NC}"
            
            # Test Docker
            test_docker_installation
            [ $? -ne 0 ] && success=false
        else
            echo -e "${RED}✗ Docker Engine: Not found${NC}"
            success=false
        fi
    fi
    
    if [ "$INSTALL_DOCKER_COMPOSE" = true ]; then
        if docker compose version &> /dev/null; then
            echo -e "${GREEN}✓ Docker Compose: $(docker compose version | head -n1)${NC}"
        else
            echo -e "${RED}✗ Docker Compose: Not found${NC}"
            success=false
        fi
    fi
    
    if [ "$ADD_USER_TO_DOCKER_GROUP" = true ]; then
        if groups $USER | grep -q '\bdocker\b'; then
            echo -e "${GREEN}✓ User is in docker group${NC}"
        else
            echo -e "${YELLOW}⚠ User not in docker group (log out/in required)${NC}"
        fi
    fi
    
    return $([ "$success" = true ] && echo 0 || echo 1)
}

confirm_installation() {
    local selections=()
    [ "$INSTALL_DOCKER_ENGINE" = true ] && selections+=("Docker Engine")
    [ "$INSTALL_DOCKER_DESKTOP" = true ] && selections+=("Docker Desktop")
    [ "$INSTALL_DOCKER_COMPOSE" = true ] && selections+=("Docker Compose V2")
    [ "$ADD_USER_TO_DOCKER_GROUP" = true ] && selections+=("Add user to docker group")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No Docker components selected for installation.${NC}"
        return 1
    fi

    echo -e "\n${YELLOW}The following will be installed/configured:${NC}"
    for item in "${selections[@]}"; do
        echo -e "  ${GREEN}✓${NC} $item"
    done
    
    if [ "$INSTALL_DOCKER_DESKTOP" = true ]; then
        echo -e "\n${YELLOW}Note: Docker Desktop requires GNOME Terminal for full functionality.${NC}"
    fi
    
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
    sudo apt install curl wget ca-certificates gnupg lsb-release -y
    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

install_selected_docker() {
    local success=true
    
    # Install system dependencies first
    install_dependencies
    
    # Install Docker Engine if selected (required for Docker Desktop too)
    if [ "$INSTALL_DOCKER_ENGINE" = true ] || [ "$INSTALL_DOCKER_DESKTOP" = true ]; then
        install_docker_engine
        [ $? -ne 0 ] && success=false
    fi
    
    # Install Docker Desktop if selected
    if [ "$INSTALL_DOCKER_DESKTOP" = true ]; then
        install_docker_desktop
        [ $? -ne 0 ] && success=false
    fi
    
    # Install Docker Compose if selected
    if [ "$INSTALL_DOCKER_COMPOSE" = true ]; then
        install_docker_compose
        [ $? -ne 0 ] && success=false
    fi
    
    # Add user to docker group if selected
    if [ "$ADD_USER_TO_DOCKER_GROUP" = true ]; then
        add_user_to_docker_group
        [ $? -ne 0 ] && success=false
    fi
    
    # Verify installation
    verify_docker_installation
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ Docker installation completed!${NC}"
        echo -e "\n${YELLOW}Next steps:${NC}"
        if [ "$ADD_USER_TO_DOCKER_GROUP" = true ]; then
            echo -e "1. ${GREEN}Log out and log back in${NC} to use docker without sudo"
        fi
        if [ "$INSTALL_DOCKER_DESKTOP" = true ]; then
            echo -e "2. Launch ${GREEN}Docker Desktop${NC} from your applications menu"
            echo -e "3. Accept the Docker Subscription Service Agreement when prompted"
        fi
        echo -e "4. Run ${GREEN}docker --version${NC} and ${GREEN}docker compose version${NC} to verify"
        echo -e "5. Try ${GREEN}docker run hello-world${NC} to test your setup"
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main Docker installation logic
echo -e "${YELLOW}Docker Setup${NC}"

while true; do
    show_docker_menu
    read -p "Choose an option (0-3): " main_choice
    
    case $main_choice in
        1)
            # Install Docker Engine Only
            INSTALL_DOCKER_ENGINE=true
            INSTALL_DOCKER_COMPOSE=true
            ADD_USER_TO_DOCKER_GROUP=true
            if confirm_installation; then
                install_selected_docker
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Install Docker Desktop
            INSTALL_DOCKER_ENGINE=true
            INSTALL_DOCKER_DESKTOP=true
            INSTALL_DOCKER_COMPOSE=true
            ADD_USER_TO_DOCKER_GROUP=true
            if confirm_installation; then
                install_selected_docker
                read -p "Press Enter to continue..."
            fi
            ;;
        3)
            # Custom selection
            while true; do
                show_custom_docker_menu
                read -p "Choose an option (0-5): " custom_choice
                
                case $custom_choice in
                    1)
                        INSTALL_DOCKER_ENGINE=$([ "$INSTALL_DOCKER_ENGINE" = true ] && echo false || echo true)
                        ;;
                    2)
                        INSTALL_DOCKER_DESKTOP=$([ "$INSTALL_DOCKER_DESKTOP" = true ] && echo false || echo true)
                        ;;
                    3)
                        INSTALL_DOCKER_COMPOSE=$([ "$INSTALL_DOCKER_COMPOSE" = true ] && echo false || echo true)
                        ;;
                    4)
                        ADD_USER_TO_DOCKER_GROUP=$([ "$ADD_USER_TO_DOCKER_GROUP" = true ] && echo false || echo true)
                        ;;
                    5)
                        if confirm_installation; then
                            install_selected_docker
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