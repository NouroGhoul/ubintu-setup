#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# System tools options
INSTALL_FLATPAK=false
INSTALL_GNOME_TWEAKS=false
INSTALL_TIMESHIFT=false
INSTALL_PROTON_VPN=false

# Ubuntu version detection functions
get_ubuntu_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$VERSION_ID"
    else
        echo "unknown"
    fi
}

get_ubuntu_codename() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$UBUNTU_CODENAME"
    else
        echo "unknown"
    fi
}

show_system_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║      SYSTEM & PACKAGE MANAGEMENT     ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install All System Tools       ║"
    echo -e "║  ${GREEN}2${BLUE}  Custom Selection               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_system_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║       CUSTOM SYSTEM SELECTION        ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Flatpak Package Manager        ║"
    echo -e "║  ${GREEN}2${BLUE}  GNOME Tweaks & Extensions      ║"
    echo -e "║  ${GREEN}3${BLUE}  Timeshift System Backup        ║"
    echo -e "║  ${GREEN}4${BLUE}  Proton VPN                     ║"
    echo -e "║  ${GREEN}5${BLUE}  Install Selected               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  Flatpak: $([ "$INSTALL_FLATPAK" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  GNOME Tweaks: $([ "$INSTALL_GNOME_TWEAKS" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Timeshift: $([ "$INSTALL_TIMESHIFT" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Proton VPN: $([ "$INSTALL_PROTON_VPN" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
}

install_flatpak_plugin() {
    local version=$(get_ubuntu_version)
    local codename=$(get_ubuntu_codename)
    
    echo -e "\n${YELLOW}Detected Ubuntu $version ($codename)${NC}"
    
    # Check if it's 18.10 (Cosmic) or later
    if [[ "$version" == "18.10" ]] || [[ "$version" > "18.10" ]]; then
        echo "Ubuntu version supports Flatpak plugin installation"
        
        # Check for Ubuntu 23.10+ (which has App Center instead of GNOME Software)
        if [[ "$version" == "23.10" ]] || [[ "$version" == "24.04" ]] || [[ "$version" > "23.10" ]]; then
            echo -e "${YELLOW}Ubuntu $version uses App Center - installing GNOME Software with Flatpak support...${NC}"
            
            # Install GNOME Software as deb package with Flatpak plugin
            if ! command -v gnome-software &> /dev/null; then
                echo "Installing GNOME Software with Flatpak plugin..."
                sudo apt install gnome-software gnome-software-plugin-flatpak -y
            else
                echo "GNOME Software already installed, adding Flatpak plugin..."
                sudo apt install gnome-software-plugin-flatpak -y
            fi
            
        # Check for Ubuntu 20.04 to 23.04 (GNOME Software as Snap)
        elif [[ "$version" == "20.04" ]] || [[ "$version" == "20.10" ]] || 
             [[ "$version" == "21.04" ]] || [[ "$version" == "21.10" ]] ||
             [[ "$version" == "22.04" ]] || [[ "$version" == "22.10" ]] ||
             [[ "$version" == "23.04" ]]; then
            
            echo -e "${YELLOW}Ubuntu $version uses Snap GNOME Software - installing deb version with Flatpak support...${NC}"
            echo -e "${YELLOW}Note: This will install both Snap and deb versions of 'Software'${NC}"
            
            sudo apt install gnome-software gnome-software-plugin-flatpak -y
            
        # Ubuntu 18.10 to 19.10 (original GNOME Software)
        else
            echo "Installing GNOME Software Flatpak plugin..."
            sudo apt install gnome-software-plugin-flatpak -y
        fi
        
        echo -e "${GREEN}✓ Flatpak GUI support installed${NC}"
    else
        echo -e "${YELLOW}Ubuntu version < 18.10 - skipping GNOME Software plugin installation${NC}"
        echo -e "${YELLOW}You can manage Flatpak apps via command line${NC}"
    fi
}

show_restart_instructions() {
    echo -e "\n${YELLOW}=== Flatpak Setup Complete ===${NC}"
    echo -e "To complete Flatpak setup:"
    echo -e "1. ${GREEN}RESTART YOUR SYSTEM${NC} for all changes to take effect"
    echo -e "2. After restart, you can install Flatpak apps via:"
    echo -e "   - ${GREEN}GNOME Software${NC} (GUI)"
    echo -e "   - ${GREEN}flatpak install flathub <app-id>${NC} (command line)"
    echo -e ""
    echo -e "${YELLOW}Common Flatpak app examples:${NC}"
    echo -e "   flatpak install flathub com.spotify.Client"
    echo -e "   flatpak install flathub org.videolan.VLC"
    echo -e "   flatpak install flathub com.visualstudio.code"
}

verify_flatpak_setup() {
    echo -e "\n${YELLOW}=== Verifying Flatpak Setup ===${NC}"
    
    # Check Flatpak installation
    if command -v flatpak &> /dev/null; then
        local flatpak_version=$(flatpak --version)
        echo -e "${GREEN}✓ $flatpak_version${NC}"
    else
        echo -e "${RED}✗ Flatpak not installed${NC}"
        return 1
    fi
    
    # Check Flathub repository
    if flatpak remote-list | grep -q flathub; then
        echo -e "${GREEN}✓ Flathub repository configured${NC}"
    else
        echo -e "${RED}✗ Flathub repository missing${NC}"
        return 1
    fi
    
    # Check GNOME Software plugin
    if [[ $(get_ubuntu_version) > "18.10" ]]; then
        if dpkg -l | grep -q "gnome-software-plugin-flatpak"; then
            echo -e "${GREEN}✓ GNOME Software Flatpak plugin installed${NC}"
        else
            echo -e "${YELLOW}⚠ GNOME Software Flatpak plugin not installed${NC}"
        fi
    fi
    
    echo -e "\n${GREEN}✓ Flatpak setup verification complete${NC}"
    return 0
}

install_flatpak() {
    echo -e "\n${YELLOW}Installing Flatpak...${NC}"
    
    if command -v flatpak &> /dev/null; then
        echo -e "${YELLOW}Flatpak is already installed.${NC}"
        # Verify Flathub repo is added
        if ! flatpak remote-list | grep -q flathub; then
            echo "Adding Flathub repository..."
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        fi
        return 0
    fi

    # Install Flatpak
    echo "Installing Flatpak package..."
    sudo apt update
    sudo apt install flatpak -y

    # Wait for installation to complete
    sleep 2

    # Add Flathub repository
    echo "Adding Flathub repository..."
    if ! flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; then
        echo -e "${YELLOW}Retrying Flathub repository addition...${NC}"
        sleep 3
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi

    # Install GNOME Software Flatpak plugin based on Ubuntu version
    install_flatpak_plugin

    if command -v flatpak &> /dev/null; then
        echo -e "${GREEN}✓ Flatpak installed successfully!${NC}"
        
        # Verify installation
        if flatpak --version &> /dev/null && flatpak remote-list | grep -q flathub; then
            echo -e "${GREEN}✓ Flathub repository configured${NC}"
        else
            echo -e "${YELLOW}⚠ Flathub repository might need manual setup${NC}"
        fi
        
        show_restart_instructions
        return 0
    else
        echo -e "${RED}✗ Failed to install Flatpak${NC}"
        return 1
    fi
}

install_gnome_tweaks() {
    echo -e "\n${YELLOW}Installing GNOME Tweaks and Extensions...${NC}"
    
    if command -v gnome-tweaks &> /dev/null && command -v gnome-extensions &> /dev/null; then
        echo -e "${YELLOW}GNOME Tweaks and Extensions are already installed.${NC}"
        return 0
    fi

    sudo apt install gnome-tweaks gnome-shell-extensions -y

    if command -v gnome-tweaks &> /dev/null && command -v gnome-extensions &> /dev/null; then
        echo -e "${GREEN}✓ GNOME Tweaks and Extensions installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install GNOME Tweaks and Extensions${NC}"
        return 1
    fi
}

install_timeshift() {
    echo -e "\n${YELLOW}Installing Timeshift...${NC}"
    
    if command -v timeshift &> /dev/null; then
        echo -e "${YELLOW}Timeshift is already installed.${NC}"
        return 0
    fi

    sudo apt install timeshift -y

    if command -v timeshift &> /dev/null; then
        echo -e "${GREEN}✓ Timeshift installed successfully!${NC}"
        echo -e "${YELLOW}Remember to set up your backup schedule in Timeshift.${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Timeshift${NC}"
        return 1
    fi
}

install_proton_vpn() {
    echo -e "\n${YELLOW}Installing Proton VPN...${NC}"
    
    if command -v protonvpn &> /dev/null; then
        echo -e "${YELLOW}Proton VPN is already installed.${NC}"
        return 0
    fi

    # Install wget if not available
    if ! command -v wget &> /dev/null; then
        echo "Installing wget..."
        sudo apt install wget -y
    fi

    echo "Downloading Proton VPN repository package..."
    wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb -O /tmp/protonvpn-stable-release_1.0.8_all.deb

    if [ -f "/tmp/protonvpn-stable-release_1.0.8_all.deb" ]; then
        echo "Proton VPN repository package downloaded successfully!"
        
        # Verify checksum (optional but recommended)
        echo "Verifying package integrity..."
        if echo "0b14e71586b22e498eb20926c48c7b434b751149b1f2af9902ef1cfe6b03e180 /tmp/protonvpn-stable-release_1.0.8_all.deb" | sha256sum --check -; then
            echo -e "${GREEN}✓ Package integrity verified${NC}"
        else
            echo -e "${YELLOW}⚠ Package integrity check failed, but continuing installation...${NC}"
        fi
        
        # Install the repository
        echo "Installing Proton VPN repository..."
        sudo dpkg -i /tmp/protonvpn-stable-release_1.0.8_all.deb
        sudo apt update
        
        # Install Proton VPN
        echo "Installing Proton VPN app..."
        sudo apt install proton-vpn-gnome-desktop -y
        
        # Clean up
        rm /tmp/protonvpn-stable-release_1.0.8_all.deb

        if command -v protonvpn &> /dev/null; then
            echo -e "${GREEN}✓ Proton VPN installed successfully!${NC}"
            echo -e "${YELLOW}You can launch Proton VPN from your applications menu.${NC}"
            return 0
        else
            echo -e "${YELLOW}Proton VPN installation completed but command not found immediately${NC}"
            echo -e "${YELLOW}Try launching from applications menu or restart your session${NC}"
            return 0
        fi
    else
        echo -e "${RED}✗ Failed to download Proton VPN repository package${NC}"
        return 1
    fi
}

confirm_installation() {
    local selections=()
    [ "$INSTALL_FLATPAK" = true ] && selections+=("Flatpak Package Manager")
    [ "$INSTALL_GNOME_TWEAKS" = true ] && selections+=("GNOME Tweaks & Extensions")
    [ "$INSTALL_TIMESHIFT" = true ] && selections+=("Timeshift System Backup")
    [ "$INSTALL_PROTON_VPN" = true ] && selections+=("Proton VPN")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No system tools selected for installation.${NC}"
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
    sudo apt install wget -y
    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

install_selected_system() {
    local success=true
    
    # Install system dependencies first
    install_dependencies
    
    # Install in logical order
    if [ "$INSTALL_FLATPAK" = true ]; then
        install_flatpak
        local flatpak_result=$?
        [ $flatpak_result -ne 0 ] && success=false
        
        # Verify installation if successful
        if [ $flatpak_result -eq 0 ]; then
            verify_flatpak_setup
        fi
    fi
    
    if [ "$INSTALL_GNOME_TWEAKS" = true ]; then
        install_gnome_tweaks
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_TIMESHIFT" = true ]; then
        install_timeshift
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_PROTON_VPN" = true ]; then
        install_proton_vpn
        [ $? -ne 0 ] && success=false
    fi
    
    # Verify installations
    echo -e "\n${YELLOW}Verifying installations...${NC}"
    
    if [ "$INSTALL_FLATPAK" = true ]; then
        if command -v flatpak &> /dev/null; then
            echo -e "${GREEN}✓ Flatpak: Installed${NC}"
        else
            echo -e "${RED}✗ Flatpak: Not found${NC}"
        fi
    fi
    
    if [ "$INSTALL_GNOME_TWEAKS" = true ]; then
        if command -v gnome-tweaks &> /dev/null; then
            echo -e "${GREEN}✓ GNOME Tweaks: Installed${NC}"
        else
            echo -e "${RED}✗ GNOME Tweaks: Not found${NC}"
        fi
    fi
    
    if [ "$INSTALL_TIMESHIFT" = true ]; then
        if command -v timeshift &> /dev/null; then
            echo -e "${GREEN}✓ Timeshift: Installed${NC}"
        else
            echo -e "${RED}✗ Timeshift: Not found${NC}"
        fi
    fi
    
    if [ "$INSTALL_PROTON_VPN" = true ]; then
        if command -v protonvpn &> /dev/null; then
            echo -e "${GREEN}✓ Proton VPN: Installed${NC}"
        else
            echo -e "${YELLOW}⚠ Proton VPN: May need restart (check applications menu)${NC}"
        fi
    fi
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ System tools installation completed!${NC}"
        if [ "$INSTALL_FLATPAK" = true ]; then
            echo -e "${YELLOW}⚠ REMEMBER: Restart your system to complete Flatpak setup${NC}"
            echo -e "${YELLOW}After restart, you can install Flatpak apps via GNOME Software or command line${NC}"
        fi
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main system tools installation logic
echo -e "${YELLOW}System & Package Management Setup${NC}"

while true; do
    show_system_menu
    read -p "Choose an option (0-2): " main_choice
    
    case $main_choice in
        1)
            # Install all system tools
            INSTALL_FLATPAK=true
            INSTALL_GNOME_TWEAKS=true
            INSTALL_TIMESHIFT=true
            INSTALL_PROTON_VPN=true
            if confirm_installation; then
                install_selected_system
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Custom selection
            while true; do
                show_custom_system_menu
                read -p "Choose an option (0-5): " custom_choice
                
                case $custom_choice in
                    1)
                        INSTALL_FLATPAK=$([ "$INSTALL_FLATPAK" = true ] && echo false || echo true)
                        ;;
                    2)
                        INSTALL_GNOME_TWEAKS=$([ "$INSTALL_GNOME_TWEAKS" = true ] && echo false || echo true)
                        ;;
                    3)
                        INSTALL_TIMESHIFT=$([ "$INSTALL_TIMESHIFT" = true ] && echo false || echo true)
                        ;;
                    4)
                        INSTALL_PROTON_VPN=$([ "$INSTALL_PROTON_VPN" = true ] && echo false || echo true)
                        ;;
                    5)
                        if confirm_installation; then
                            install_selected_system
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