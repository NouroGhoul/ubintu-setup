#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Media apps options
VLC_INSTALLED=false
OBS_INSTALLED=false
STEAM_INSTALLED=false
QBITTORRENT_INSTALLED=false
LOCALSEND_INSTALLED=false

show_media_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║       MEDIA & ENTERTAINMENT SETUP    ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install All Media Apps         ║"
    echo -e "║  ${GREEN}2${BLUE}  Custom Selection               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_media_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║        CUSTOM MEDIA SELECTION        ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  VLC Media Player              ║"
    echo -e "║  ${GREEN}2${BLUE}  OBS Studio                    ║"
    echo -e "║  ${GREEN}3${BLUE}  Steam                         ║"
    echo -e "║  ${GREEN}4${BLUE}  qBittorrent                   ║"
    echo -e "║  ${GREEN}5${BLUE}  LocalSend                     ║"
    echo -e "║  ${GREEN}6${BLUE}  Install Selected               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  VLC: $([ "$VLC_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  OBS Studio: $([ "$OBS_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Steam: $([ "$STEAM_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  qBittorrent: $([ "$QBITTORRENT_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  LocalSend: $([ "$LOCALSEND_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
}

install_vlc() {
    echo -e "\n${YELLOW}Installing VLC Media Player...${NC}"
    
    if command -v vlc &> /dev/null; then
        echo -e "${YELLOW}VLC is already installed. Skipping...${NC}"
        return 0
    fi

    sudo apt install vlc -y

    if command -v vlc &> /dev/null; then
        echo -e "${GREEN}✓ VLC installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install VLC${NC}"
        return 1
    fi
}

install_obs() {
    echo -e "\n${YELLOW}Installing OBS Studio...${NC}"
    
    if command -v obs-studio &> /dev/null; then
        echo -e "${YELLOW}OBS Studio is already installed. Skipping...${NC}"
        return 0
    fi

    sudo apt install obs-studio -y

    if command -v obs-studio &> /dev/null; then
        echo -e "${GREEN}✓ OBS Studio installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install OBS Studio${NC}"
        return 1
    fi
}

install_steam() {
    echo -e "\n${YELLOW}Installing Steam...${NC}"
    
    if command -v steam &> /dev/null; then
        echo -e "${YELLOW}Steam is already installed. Skipping...${NC}"
        return 0
    fi

    sudo apt install steam -y

    if command -v steam &> /dev/null; then
        echo -e "${GREEN}✓ Steam installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Steam${NC}"
        return 1
    fi
}

install_qbittorrent() {
    echo -e "\n${YELLOW}Installing qBittorrent...${NC}"
    
    if command -v qbittorrent &> /dev/null; then
        echo -e "${YELLOW}qBittorrent is already installed. Skipping...${NC}"
        return 0
    fi

    sudo apt install qbittorrent -y

    if command -v qbittorrent &> /dev/null; then
        echo -e "${GREEN}✓ qBittorrent installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install qBittorrent${NC}"
        return 1
    fi
}

install_localsend() {
    echo -e "\n${YELLOW}Installing LocalSend...${NC}"
    
    if command -v localsend &> /dev/null || snap list localsend &> /dev/null; then
        echo -e "${YELLOW}LocalSend is already installed. Skipping...${NC}"
        return 0
    fi

    # Try Snap installation (recommended for LocalSend)
    echo "Attempting Snap installation..."
    if sudo snap install localsend; then
        if snap list localsend &> /dev/null; then
            echo -e "${GREEN}✓ LocalSend installed successfully via Snap!${NC}"
            return 0
        fi
    fi

    echo -e "${YELLOW}Snap installation failed, falling back to APT...${NC}"
    
    # Fallback to APT installation
    sudo apt install localsend -y

    if command -v localsend &> /dev/null; then
        echo -e "${GREEN}✓ LocalSend installed successfully via APT!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install LocalSend${NC}"
        return 1
    fi
}

confirm_installation() {
    local selections=()
    [ "$VLC_INSTALLED" = true ] && selections+=("VLC Media Player")
    [ "$OBS_INSTALLED" = true ] && selections+=("OBS Studio")
    [ "$STEAM_INSTALLED" = true ] && selections+=("Steam")
    [ "$QBITTORRENT_INSTALLED" = true ] && selections+=("qBittorrent")
    [ "$LOCALSEND_INSTALLED" = true ] && selections+=("LocalSend")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No apps selected for installation.${NC}"
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

install_selected_media() {
    local success=true
    
    if [ "$VLC_INSTALLED" = true ]; then
        install_vlc
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$OBS_INSTALLED" = true ]; then
        install_obs
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$STEAM_INSTALLED" = true ]; then
        install_steam
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$QBITTORRENT_INSTALLED" = true ]; then
        install_qbittorrent
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$LOCALSEND_INSTALLED" = true ]; then
        install_localsend
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ Media apps installation completed!${NC}"
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main media apps installation logic
echo -e "${YELLOW}Media & Entertainment Setup${NC}"

while true; do
    show_media_menu
    read -p "Choose an option (0-2): " main_choice
    
    case $main_choice in
        1)
            # Install all apps
            VLC_INSTALLED=true
            OBS_INSTALLED=true
            STEAM_INSTALLED=true
            QBITTORRENT_INSTALLED=true
            LOCALSEND_INSTALLED=true
            if confirm_installation; then
                install_selected_media
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Custom selection
            while true; do
                show_custom_media_menu
                read -p "Choose an option (0-6): " custom_choice
                
                case $custom_choice in
                    1)
                        VLC_INSTALLED=$([ "$VLC_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    2)
                        OBS_INSTALLED=$([ "$OBS_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    3)
                        STEAM_INSTALLED=$([ "$STEAM_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    4)
                        QBITTORRENT_INSTALLED=$([ "$QBITTORRENT_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    5)
                        LOCALSEND_INSTALLED=$([ "$LOCALSEND_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    6)
                        if confirm_installation; then
                            install_selected_media
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