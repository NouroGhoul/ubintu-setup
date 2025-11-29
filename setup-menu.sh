#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Scripts directory
SCRIPTS_DIR="bash-resources"

# Function to display menu
show_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║        UBUNTU SETUP MENU             ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  System & Package Management    ║"
    echo -e "║  ${GREEN}2${BLUE}  Theme Installation             ║"
    echo -e "║  ${GREEN}3${BLUE}  Web Browsers                   ║"
    echo -e "║  ${GREEN}4${BLUE}  Communication Apps             ║"
    echo -e "║  ${GREEN}5${BLUE}  Media & Entertainment          ║"
    echo -e "║  ${GREEN}6${BLUE}  Development Tools              ║"
    echo -e "║  ${GREEN}7${BLUE}  Terminal & Shell               ║"
    echo -e "║  ${GREEN}8${BLUE}  Run ALL Setup Scripts          ║"
    echo -e "║  ${GREEN}9${BLUE}  🚀 FULLY AUTOMATED SETUP       ║"
    echo -e "║  ${GREEN}0${BLUE}  Exit                           ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to run script with error handling
run_script() {
    local script_name=$1
    local description=$2
    local auto_mode=$3
    
    echo -e "\n${YELLOW}Running: $description...${NC}"
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        if [ "$auto_mode" = true ]; then
            # For automated mode, we'll handle each script specially
            run_automated_script "$script_name" "$description"
        else
            ./"$script_path"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ $description completed successfully!${NC}"
            else
                echo -e "${RED}✗ $description failed!${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ Script '$script_path' not found or not executable!${NC}"
        echo -e "${YELLOW}Make sure you're in the correct directory and scripts are executable.${NC}"
    fi
    
    if [ "$auto_mode" != true ]; then
        read -p "Press Enter to continue..."
    fi
}

# Function to run scripts in automated mode
run_automated_script() {
    local script_name=$1
    local description=$2
    local script_path="$SCRIPTS_DIR/$script_name"
    
    case $script_name in
        "system-setup.sh")
            echo -e "${YELLOW}Installing all system tools automatically...${NC}"
            # Run system setup with all options selected
            echo "1" | ./"$script_path" > /dev/null 2>&1
            ;;
        "theme-setup.sh")
            echo -e "${YELLOW}Installing theme automatically...${NC}"
            # Run theme setup automatically
            ./"$script_path" > /dev/null 2>&1
            ;;
        "browsers-setup.sh")
            echo -e "${YELLOW}Installing all browsers automatically...${NC}"
            # Run browsers setup with all options selected
            echo "1" | ./"$script_path" > /dev/null 2>&1
            ;;
        "communication-setup.sh")
            echo -e "${YELLOW}Installing communication apps automatically...${NC}"
            # Run communication setup with all options selected
            echo "1" | ./"$script_path" > /dev/null 2>&1
            ;;
        "media-setup.sh")
            echo -e "${YELLOW}Installing media apps automatically...${NC}"
            # Run media setup with all options selected
            echo "1" | ./"$script_path" > /dev/null 2>&1
            ;;
        "dev-setup.sh")
            echo -e "${YELLOW}Installing development tools automatically...${NC}"
            # Run dev setup with all options selected
            echo "1" | ./"$script_path" > /dev/null 2>&1
            ;;
        "shell-setup.sh")
            echo -e "${YELLOW}Installing shell enhancements automatically...${NC}"
            # Run shell setup with all options selected
            echo "1" | ./"$script_path" > /dev/null 2>&1
            ;;
        *)
            # Default fallback
            ./"$script_path" > /dev/null 2>&1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $description completed successfully!${NC}"
    else
        echo -e "${RED}✗ $description failed!${NC}"
    fi
}

# Function for fully automated setup
fully_automated_setup() {
    echo -e "\n${YELLOW}🚀 STARTING FULLY AUTOMATED SETUP...${NC}"
    echo -e "${YELLOW}This will install ALL components without any user interaction.${NC}"
    echo -e "${YELLOW}Please wait, this may take a while...${NC}"
    echo -e "${YELLOW}Estimated time: 15-30 minutes depending on your internet connection.${NC}"
    
    # Countdown
    for i in {5..1}; do
        echo -e "${YELLOW}Starting in $i seconds...${NC}"
        sleep 1
    done
    
    echo -e "\n${GREEN}=== BEGINNING AUTOMATED INSTALLATION ===${NC}"
    
    # Start installation timer
    local start_time=$(date +%s)
    
    # 1. System & Package Management
    echo -e "\n${BLUE}[1/7] Installing System Tools...${NC}"
    run_automated_script "system-setup.sh" "System & Package Management"
    
    # 2. Theme Installation
    echo -e "\n${BLUE}[2/7] Installing Themes...${NC}"
    run_automated_script "theme-setup.sh" "Theme Installation"
    
    # 3. Web Browsers
    echo -e "\n${BLUE}[3/7] Installing Web Browsers...${NC}"
    run_automated_script "browsers-setup.sh" "Web Browsers"
    
    # 4. Communication Apps
    echo -e "\n${BLUE}[4/7] Installing Communication Apps...${NC}"
    run_automated_script "communication-setup.sh" "Communication Apps"
    
    # 5. Media & Entertainment
    echo -e "\n${BLUE}[5/7] Installing Media Apps...${NC}"
    run_automated_script "media-setup.sh" "Media & Entertainment"
    
    # 6. Development Tools
    echo -e "\n${BLUE}[6/7] Installing Development Tools...${NC}"
    run_automated_script "dev-setup.sh" "Development Tools"
    
    # 7. Terminal & Shell
    echo -e "\n${BLUE}[7/7] Installing Shell Enhancements...${NC}"
    run_automated_script "shell-setup.sh" "Terminal & Shell"
    
    # Calculate total time
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    local minutes=$((total_time / 60))
    local seconds=$((total_time % 60))
    
    echo -e "\n${GREEN}=== AUTOMATED SETUP COMPLETED ===${NC}"
    echo -e "${GREEN}✓ All components installed successfully!${NC}"
    echo -e "${YELLOW}Total time: ${minutes}m ${seconds}s${NC}"
    
    # Show summary
    echo -e "\n${BLUE}=== INSTALLATION SUMMARY ===${NC}"
    echo -e "${GREEN}✓ System Tools: Flatpak, GNOME Tweaks, Timeshift, Proton VPN, Pavucontrol${NC}"
    echo -e "${GREEN}✓ Themes: Graphite GTK Theme, Tela Circle Icons, Wallpapers${NC}"
    echo -e "${GREEN}✓ Browsers: Brave, Chrome, Chromium${NC}"
    echo -e "${GREEN}✓ Communication: Discord, Telegram${NC}"
    echo -e "${GREEN}✓ Media: VLC, OBS Studio, Steam, qBittorrent, LocalSend${NC}"
    echo -e "${GREEN}✓ Development: VS Code, Node.js, Python, Git, Tmux, Vim${NC}"
    echo -e "${GREEN}✓ Shell: Zsh, Oh My Zsh, Powerlevel10k, plugins${NC}"
    
    echo -e "\n${YELLOW}=== NEXT STEPS ===${NC}"
    echo -e "1. ${GREEN}Restart your computer${NC} to apply all changes"
    echo -e "2. ${GREEN}Open GNOME Tweaks${NC} to customize your theme"
    echo -e "3. ${GREEN}Run 'p10k configure'${NC} to customize your shell prompt"
    echo -e "4. ${GREEN}Use Super+G${NC} to open Pavucontrol audio mixer"
    
    echo -e "\n${GREEN}🎉 Your Ubuntu system is now fully set up and ready to use!${NC}"
    
    read -p "Press Enter to return to main menu..."
}

# Check if scripts directory exists
if [ ! -d "$SCRIPTS_DIR" ]; then
    echo -e "${RED}Error: '$SCRIPTS_DIR' directory not found!${NC}"
    echo -e "${YELLOW}Make sure you're in the correct project directory.${NC}"
    exit 1
fi

# Main loop
while true; do
    show_menu
    read -p "Choose an option (0-9): " choice
    
    case $choice in
        1)
            run_script "system-setup.sh" "System & Package Management" false
            ;;
        2)
            run_script "theme-setup.sh" "Theme Installation" false
            ;;
        3)
            run_script "browsers-setup.sh" "Web Browsers" false
            ;;
        4)
            run_script "communication-setup.sh" "Communication Apps" false
            ;;
        5)
            run_script "media-setup.sh" "Media & Entertainment" false
            ;;
        6)
            run_script "dev-setup.sh" "Development Tools" false
            ;;
        7)
            run_script "shell-setup.sh" "Terminal & Shell" false
            ;;
        8)
            echo -e "\n${YELLOW}Running ALL setup scripts...${NC}"
            echo -e "${YELLOW}This will take a while. Please wait...${NC}"
            
            run_script "system-setup.sh" "System & Package Management" false
            run_script "theme-setup.sh" "Theme Installation" false
            run_script "browsers-setup.sh" "Web Browsers" false
            run_script "communication-setup.sh" "Communication Apps" false
            run_script "media-setup.sh" "Media & Entertainment" false
            run_script "dev-setup.sh" "Development Tools" false
            run_script "shell-setup.sh" "Terminal & Shell" false
            
            echo -e "${GREEN}✓ All setup scripts completed!${NC}"
            read -p "Press Enter to continue..."
            ;;
        9)
            fully_automated_setup
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option! Please choose 0-9.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done