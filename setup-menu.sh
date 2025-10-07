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
    echo "║  ${GREEN}1${BLUE}  System & Package Management    ║"
    echo "║  ${GREEN}2${BLUE}  Theme Installation             ║"
    echo "║  ${GREEN}3${BLUE}  Web Browsers                   ║"
    echo "║  ${GREEN}4${BLUE}  Communication Apps             ║"
    echo "║  ${GREEN}5${BLUE}  Media & Entertainment          ║"
    echo "║  ${GREEN}6${BLUE}  Development Tools              ║"
    echo "║  ${GREEN}7${BLUE}  Terminal & Shell               ║"
    echo "║  ${GREEN}8${BLUE}  Run ALL Setup Scripts          ║"
    echo "║  ${GREEN}0${BLUE}  Exit                           ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to run script with error handling
run_script() {
    local script_name=$1
    local description=$2
    local script_path="$SCRIPTS_DIR/$script_name"
    
    echo -e "\n${YELLOW}Running: $description...${NC}"
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        ./$script_path
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ $description completed successfully!${NC}"
        else
            echo -e "${RED}✗ $description failed!${NC}"
        fi
    else
        echo -e "${RED}✗ Script '$script_path' not found or not executable!${NC}"
        echo -e "${YELLOW}Make sure you're in the correct directory and scripts are executable.${NC}"
    fi
    
    read -p "Press Enter to continue..."
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
    read -p "Choose an option (0-8): " choice
    
    case $choice in
        1)
            run_script "system-setup.sh" "System & Package Management"
            ;;
        2)
            run_script "theme-setup.sh" "Theme Installation"
            ;;
        3)
            run_script "browsers-setup.sh" "Web Browsers"
            ;;
        4)
            run_script "communication-setup.sh" "Communication Apps"
            ;;
        5)
            run_script "media-setup.sh" "Media & Entertainment"
            ;;
        6)
            run_script "dev-setup.sh" "Development Tools"
            ;;
        7)
            run_script "shell-setup.sh" "Terminal & Shell"
            ;;
        8)
            echo -e "\n${YELLOW}Running ALL setup scripts...${NC}"
            echo -e "${YELLOW}This will take a while. Please wait...${NC}"
            
            run_script "system-setup.sh" "System & Package Management"
            run_script "theme-setup.sh" "Theme Installation"
            run_script "browsers-setup.sh" "Web Browsers"
            run_script "communication-setup.sh" "Communication Apps"
            run_script "media-setup.sh" "Media & Entertainment"
            run_script "dev-setup.sh" "Development Tools"
            run_script "shell-setup.sh" "Terminal & Shell"
            
            echo -e "${GREEN}✓ All setup scripts completed!${NC}"
            read -p "Press Enter to continue..."
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option! Please choose 0-8.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done