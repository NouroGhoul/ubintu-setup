#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Scripts directory
SCRIPTS_DIR="bash-resources"

# Tracking file
TRACKING_FILE="$HOME/.ubuntu-setup-track"

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
    echo -e "║  ${GREEN}9${BLUE}  View Installation Report       ║"
    echo -e "║  ${GREEN}0${BLUE}  Exit                           ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to track installation
track_installation() {
    local category=$1
    local app_name=$2
    local status=$3
    local notes=$4
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp|$category|$app_name|$status|$notes" >> "$TRACKING_FILE"
}

# Function to show installation report
show_installation_report() {
    if [ ! -f "$TRACKING_FILE" ]; then
        echo -e "${YELLOW}No installation tracking data found.${NC}"
        return
    fi
    
    echo -e "\n${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║               INSTALLATION REPORT                    ║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════════════════════════╣${NC}"
    
    # Count successes, failures, and restarts needed
    local total=$(wc -l < "$TRACKING_FILE")
    local success=$(grep -c "|SUCCESS|" "$TRACKING_FILE")
    local failed=$(grep -c "|FAILED|" "$TRACKING_FILE")
    local restart=$(grep -c "RESTART" "$TRACKING_FILE")
    
    echo -e "${BLUE}║${NC} Total installations: $total | ${GREEN}Success: $success${NC} | ${RED}Failed: $failed${NC} ${BLUE}║${NC}"
    
    if [ $restart -gt 0 ]; then
        echo -e "${BLUE}║${NC} ${YELLOW}⚠ $restart app(s) may need restart${NC}                    ${BLUE}║${NC}"
    fi
    
    echo -e "${BLUE}╠══════════════════════════════════════════════════════╣${NC}"
    
    # Show recent installations
    echo -e "${BLUE}║${NC} ${YELLOW}Recent installations:${NC}                           ${BLUE}║${NC}"
    tail -10 "$TRACKING_FILE" | while IFS='|' read timestamp category app status notes; do
        local status_color=$GREEN
        [ "$status" = "FAILED" ] && status_color=$RED
        [ "$status" = "RESTART_NEEDED" ] && status_color=$YELLOW
        
        printf "${BLUE}║${NC} %-15s %-20s ${status_color}%-12s${NC} ${BLUE}║${NC}\n" \
            "$category" "$app" "$status"
    done
    
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    
    # Show apps that need restart
    if grep -q "RESTART" "$TRACKING_FILE"; then
        echo -e "\n${YELLOW}Apps that may need restart:${NC}"
        grep "RESTART" "$TRACKING_FILE" | while IFS='|' read timestamp category app status notes; do
            echo -e "  ${YELLOW}•${NC} $app ($category)"
        done
        echo -e "\n${YELLOW}Consider restarting your system for these apps to work properly.${NC}"
    fi
}

# Function to run script with error handling and tracking
run_script() {
    local script_name=$1
    local description=$2
    local script_path="$SCRIPTS_DIR/$script_name"
    
    echo -e "\n${YELLOW}Running: $description...${NC}"
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        # Create tracking file if it doesn't exist
        if [ ! -f "$TRACKING_FILE" ]; then
            echo "# Ubuntu Setup Tracking - $(date)" > "$TRACKING_FILE"
            echo "# Format: timestamp|category|app_name|status|notes" >> "$TRACKING_FILE"
        fi
        
        # Track script start
        track_installation "SCRIPT" "$description" "STARTED" ""
        
        ./"$script_path"
        local exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}✓ $description completed successfully!${NC}"
            track_installation "SCRIPT" "$description" "SUCCESS" ""
        else
            echo -e "${RED}✗ $description failed!${NC}"
            track_installation "SCRIPT" "$description" "FAILED" "Exit code: $exit_code"
        fi
    else
        echo -e "${RED}✗ Script '$script_path' not found or not executable!${NC}"
        echo -e "${YELLOW}Make sure you're in the correct directory and scripts are executable.${NC}"
        track_installation "SCRIPT" "$description" "FAILED" "Script not found"
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
    read -p "Choose an option (0-9): " choice
    
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
        9)
            show_installation_report
            read -p "Press Enter to continue..."
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            if [ -f "$TRACKING_FILE" ] && grep -q "RESTART" "$TRACKING_FILE"; then
                echo -e "${YELLOW}Remember to restart your system for some apps to work properly.${NC}"
            fi
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option! Please choose 0-9.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done