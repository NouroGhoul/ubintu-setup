#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
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
    echo -e "║  ${GREEN}8${BLUE}  Docker Setup                   ║"
    echo -e "║  ${GREEN}9${BLUE}  Run ALL Setup Scripts          ║"
    echo -e "║  ${GREEN}10${BLUE} 🚀 FULLY AUTOMATED SETUP       ║"
    echo -e "║  ${GREEN}0${BLUE}  Exit                           ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to get download method for a specific app
get_download_method() {
    local app_name="$1"
    local current_script="$2"
    
    case $app_name in
        # System Tools
        "Flatpak Package Manager"|"GNOME Tweaks & Extensions"|"Timeshift System Backup"|"Pavucontrol Audio Control")
            echo "apt"
            ;;
        "Proton VPN")
            echo "deb"
            ;;
        
        # Browsers
        "Brave Browser")
            echo "apt (official repo)"
            ;;
        "Google Chrome")
            echo "deb"
            ;;
        "Chromium Browser"|"Browser Utilities")
            echo "apt"
            ;;
        
        # Communication
        "Discord")
            echo "deb (with snap fallback)"
            ;;
        "Telegram")
            echo "snap (with apt fallback)"
            ;;
        
        # Media
        "VLC Media Player"|"OBS Studio"|"Steam"|"qBittorrent")
            echo "apt"
            ;;
        "LocalSend")
            echo "snap (with apt fallback)"
            ;;
        
        # Development
        "Visual Studio Code")
            echo "snap (with deb fallback)"
            ;;
        "Node.js + nvm")
            echo "curl + nvm"
            ;;
        "Python3 + pip"|"Git"|"Tmux"|"Vim")
            echo "apt"
            ;;
        
        # Docker
        "Docker Engine")
            echo "apt (official Docker repo)"
            ;;
        "Docker Desktop")
            echo "deb (GUI app)"
            ;;
        "Docker Compose")
            echo "apt (plugin)"
            ;;
        
        # Themes
        "Graphite GTK Theme"|"Tela Circle Icons"|"GDM Theme"|"GNOME Shell Customization")
            echo "git + script"
            ;;
        "Graphite Wallpapers")
            echo "git + copy"
            ;;
        
        # Shell
        "Zsh Shell"|"Oh My Zsh Framework"|"Powerlevel10k Theme"|"Auto Suggestions"|"Syntax Highlighting"|"Auto Completions")
            echo "git + script"
            ;;
        
        *)
            case $current_script in
                "System & Package Management")
                    echo "apt/deb"
                    ;;
                "Theme Installation")
                    echo "git + script"
                    ;;
                "Web Browsers")
                    echo "apt/deb"
                    ;;
                "Communication Apps")
                    echo "deb/snap"
                    ;;
                "Media & Entertainment")
                    echo "apt/snap"
                    ;;
                "Development Tools")
                    echo "snap/curl/apt"
                    ;;
                "Terminal & Shell")
                    echo "git + script"
                    ;;
                "Docker Setup")
                    echo "apt/deb"
                    ;;
                *)
                    echo "various"
                    ;;
            esac
            ;;
    esac
}

# Function to get download method color
get_method_color() {
    local method="$1"
    case $method in
        "apt"|"apt (official repo)"|"apt (official Docker repo)")
            echo "${GREEN}"
            ;;
        "snap"|"snap (with apt fallback)"|"snap (with deb fallback)")
            echo "${PURPLE}"
            ;;
        "deb"|"deb (with snap fallback)"|"deb (GUI app)")
            echo "${BLUE}"
            ;;
        "git + script"|"git + copy")
            echo "${ORANGE}"
            ;;
        "curl + nvm"|"apt (plugin)")
            echo "${CYAN}"
            ;;
        *)
            echo "${YELLOW}"
            ;;
    esac
}

# Function to show loading screen
show_loading_screen() {
    local current_script="$1"
    local current_step="$2"
    local total_steps="$3"
    local completed_scripts="$4"
    local current_script_items="$5"
    local current_item="$6"
    
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                   🚀 AUTOMATED SETUP PROGRESS                      ║"
    echo "╠════════════════════════════════════════════════════════════════════╣"
    echo -e "║  ${CYAN}Progress:${NC} $current_step/$total_steps scripts completed                 ║"
    echo -e "║  ${CYAN}Current Script:${NC} ${YELLOW}$current_script${NC}                         ║"
    
    # Get download method for current item
    local download_method=$(get_download_method "$current_item" "$current_script")
    local method_color=$(get_method_color "$download_method")
    
    echo -e "║  ${CYAN}Installing:${NC} ${GREEN}$current_item${NC}                               ║"
    echo -e "║  ${CYAN}Method:${NC} ${method_color}$download_method${NC}                                   ║"
    echo "╠════════════════════════════════════════════════════════════════════╣"
    
    # Show current script items being installed with their methods
    if [ -n "$current_script_items" ]; then
        echo -e "║  ${PURPLE}Current Script Components:${NC}                                    ║"
        IFS='|' read -ra ITEMS <<< "$current_script_items"
        for item in "${ITEMS[@]}"; do
            local item_method=$(get_download_method "$item" "$current_script")
            local item_color=$(get_method_color "$item_method")
            
            if [[ "$item" == "$current_item"* ]] || [[ "$current_item" == "$item"* ]]; then
                echo -e "║    ${YELLOW}⏳ $item${NC}                                      ║"
                echo -e "║      ${item_color}↳ Method: $item_method${NC}                              ║"
            else
                echo -e "║    ${GREEN}✓ $item${NC}                                        ║"
            fi
        done
    fi
    
    echo "╠════════════════════════════════════════════════════════════════════╣"
    echo -e "║  ${GREEN}✅ Completed Scripts:${NC}                                             ║"
    IFS='|' read -ra COMPLETED <<< "$completed_scripts"
    for script in "${COMPLETED[@]}"; do
        if [ -n "$script" ]; then
            echo -e "║    ${GREEN}✓ $script${NC}                                              ║"
        fi
    done
    
    # Show remaining scripts
    local remaining_scripts=("System Tools" "Themes" "Browsers" "Communication" "Media" "Development" "Shell" "Docker")
    for completed in "${COMPLETED[@]}"; do
        for i in "${!remaining_scripts[@]}"; do
            if [[ " ${remaining_scripts[i]} " == *"$completed"* ]]; then
                unset 'remaining_scripts[i]'
            fi
        done
    done
    
    if [ ${#remaining_scripts[@]} -gt 0 ]; then
        echo "╠════════════════════════════════════════════════════════════════════╣"
        echo -e "║  ${YELLOW}📋 Remaining Scripts:${NC}                                           ║"
        for script in "${remaining_scripts[@]}"; do
            if [ -n "$script" ]; then
                echo -e "║    ${YELLOW}⏳ $script${NC}                                              ║"
            fi
        done
    fi
    
    # Show download method legend
    echo "╠════════════════════════════════════════════════════════════════════╣"
    echo -e "║  ${CYAN}📦 DOWNLOAD METHODS LEGEND:${NC}                                        ║"
    echo -e "║    ${GREEN}apt${NC} - Ubuntu package manager                                  ║"
    echo -e "║    ${PURPLE}snap${NC} - Snap packages                                         ║"
    echo -e "║    ${BLUE}deb${NC} - Direct .deb package download                            ║"
    echo -e "║    ${ORANGE}git${NC} - Git repository + installation script                  ║"
    echo -e "║    ${CYAN}curl${NC} - Direct download via curl                              ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to run scripts in automated mode with progress tracking
run_automated_script() {
    local script_name="$1"
    local description="$2"
    local current_step="$3"
    local total_steps="$4"
    local completed_scripts="$5"
    local script_path="$SCRIPTS_DIR/$script_name"
    
    # Define what each script installs
    case $script_name in
        "system-setup.sh")
            local items=("Flatpak Package Manager|GNOME Tweaks & Extensions|Timeshift System Backup|Proton VPN|Pavucontrol Audio Control")
            local current_item="Flatpak Package Manager"
            ;;
        "theme-setup.sh")
            local items=("Graphite GTK Theme|Tela Circle Icons|Graphite Wallpapers|GDM Theme|GNOME Shell Customization")
            local current_item="Graphite GTK Theme"
            ;;
        "browsers-setup.sh")
            local items=("Brave Browser|Google Chrome|Chromium Browser|Browser Utilities")
            local current_item="Brave Browser"
            ;;
        "communication-setup.sh")
            local items=("Discord|Telegram")
            local current_item="Discord"
            ;;
        "media-setup.sh")
            local items=("VLC Media Player|OBS Studio|Steam|qBittorrent|LocalSend")
            local current_item="VLC Media Player"
            ;;
        "dev-setup.sh")
            local items=("Visual Studio Code|Node.js + nvm|Python3 + pip|Git|Tmux|Vim")
            local current_item="Visual Studio Code"
            ;;
        "shell-setup.sh")
            local items=("Zsh Shell|Oh My Zsh Framework|Powerlevel10k Theme|Auto Suggestions|Syntax Highlighting|Auto Completions")
            local current_item="Zsh Shell"
            ;;
        "docker-setup.sh")
            local items=("Docker Engine|Docker Desktop|Docker Compose|Docker Group Permissions")
            local current_item="Docker Engine"
            ;;
        *)
            local items=("Various Components")
            local current_item="Various Components"
            ;;
    esac
    
    # Show initial loading screen
    show_loading_screen "$description" "$current_step" "$total_steps" "$completed_scripts" "$items" "$current_item"
    
    # Create a temporary file to capture output
    local temp_file=$(mktemp)
    
    # Run the script in background and capture output
    {
        case $script_name in
            "system-setup.sh")
                echo "1" | timeout 300 ./"$script_path" 2>&1
                ;;
            "theme-setup.sh")
                # For theme setup, we need to handle the interactive prompts
                {
                    echo "y"   # Yes to icons
                    echo "y"   # Yes to wallpapers
                    sleep 1
                } | timeout 300 ./"$script_path" 2>&1
                ;;
            "browsers-setup.sh")
                echo "1" | timeout 300 ./"$script_path" 2>&1
                ;;
            "communication-setup.sh")
                echo "1" | timeout 300 ./"$script_path" 2>&1
                ;;
            "media-setup.sh")
                echo "1" | timeout 300 ./"$script_path" 2>&1
                ;;
            "dev-setup.sh")
                echo "1" | timeout 300 ./"$script_path" 2>&1
                ;;
            "shell-setup.sh")
                echo "1" | timeout 300 ./"$script_path" 2>&1
                ;;
            "docker-setup.sh")
                echo "2" | timeout 300 ./"$script_path" 2>&1  # Install Docker Desktop for full experience
                ;;
            *)
                timeout 300 ./"$script_path" 2>&1
                ;;
        esac
    } > "$temp_file" 2>&1 &
    
    local pid=$!
    
    # Update progress while the script is running
    local item_index=0
    IFS='|' read -ra ITEM_ARRAY <<< "$items"
    
    while kill -0 "$pid" 2>/dev/null; do
        # Rotate through items to show progress
        current_item="${ITEM_ARRAY[$item_index]}"
        show_loading_screen "$description" "$current_step" "$total_steps" "$completed_scripts" "$items" "$current_item"
        
        # Move to next item, loop back to start
        ((item_index++))
        if [ $item_index -ge ${#ITEM_ARRAY[@]} ]; then
            item_index=0
        fi
        
        sleep 3
    done
    
    # Wait for the process to complete and get exit status
    wait "$pid"
    local exit_status=$?
    
    # Clean up temp file
    rm -f "$temp_file"
    
    if [ $exit_status -eq 0 ]; then
        echo -e "${GREEN}✓ $description completed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ $description failed or timed out!${NC}"
        return 1
    fi
}

# Function for fully automated setup
fully_automated_setup() {
    echo -e "\n${YELLOW}🚀 STARTING FULLY AUTOMATED SETUP...${NC}"
    echo -e "${YELLOW}This will install ALL components without any user interaction.${NC}"
    echo -e "${YELLOW}Please wait, this may take a while...${NC}"
    echo -e "${YELLOW}Estimated time: 20-40 minutes depending on your internet connection.${NC}"
    
    # Countdown
    for i in {5..1}; do
        echo -e "${YELLOW}Starting in $i seconds...${NC}"
        sleep 1
    done
    
    echo -e "\n${GREEN}=== BEGINNING AUTOMATED INSTALLATION ===${NC}"
    
    # Start installation timer
    local start_time=$(date +%s)
    
    # Define the installation order
    local scripts=(
        "system-setup.sh:System & Package Management"
        "theme-setup.sh:Theme Installation" 
        "browsers-setup.sh:Web Browsers"
        "communication-setup.sh:Communication Apps"
        "media-setup.sh:Media & Entertainment"
        "dev-setup.sh:Development Tools"
        "shell-setup.sh:Terminal & Shell"
        "docker-setup.sh:Docker Setup"
    )
    
    local total_steps=${#scripts[@]}
    local completed_scripts=""
    local success_count=0
    
    # Run each script in order
    for ((i=0; i<${#scripts[@]}; i++)); do
        IFS=':' read -ra SCRIPT_INFO <<< "${scripts[$i]}"
        local script_name="${SCRIPT_INFO[0]}"
        local description="${SCRIPT_INFO[1]}"
        local current_step=$((i + 1))
        
        echo -e "\n${BLUE}[$current_step/$total_steps] Installing $description...${NC}"
        
        # Run the script with progress tracking
        if run_automated_script "$script_name" "$description" "$current_step" "$total_steps" "$completed_scripts"; then
            ((success_count++))
            completed_scripts="${completed_scripts}|${description}"
        fi
        
        # Small delay between scripts
        sleep 2
    done
    
    # Calculate total time
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    local minutes=$((total_time / 60))
    local seconds=$((total_time % 60))
    
    # Show final results
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                   🎉 SETUP COMPLETED!                              ║"
    echo "╠════════════════════════════════════════════════════════════════════╣"
    echo -e "║  ${GREEN}Successfully installed: $success_count/$total_steps categories${NC}             ║"
    echo -e "║  ${YELLOW}Total time: ${minutes}m ${seconds}s${NC}                                      ║"
    echo "╠════════════════════════════════════════════════════════════════════╣"
    
    # Installation summary with methods
    echo -e "║  ${GREEN}✅ INSTALLED COMPONENTS:${NC}                                         ║"
    echo -e "║  ${GREEN}┌─ System Tools:${NC}                                                 ║"
    echo -e "║  ${GREEN}│  ${GREEN}• Flatpak${NC} (apt) | ${GREEN}• GNOME Tweaks${NC} (apt) | ${GREEN}• Timeshift${NC} (apt)        ║"
    echo -e "║  ${GREEN}│  ${BLUE}• Proton VPN${NC} (deb) | ${GREEN}• Pavucontrol${NC} (apt) + ${GREEN}Super+G${NC} shortcut ║"
    echo -e "║  ${GREEN}├─ Themes:${NC}                                                       ║"
    echo -e "║  ${GREEN}│  ${ORANGE}• Graphite GTK${NC} (git) | ${ORANGE}• Tela Icons${NC} (git) | ${ORANGE}• Wallpapers${NC} (git) ║"
    echo -e "║  ${GREEN}├─ Browsers:${NC}                                                     ║"
    echo -e "║  ${GREEN}│  ${GREEN}• Brave${NC} (apt) | ${BLUE}• Chrome${NC} (deb) | ${GREEN}• Chromium${NC} (apt)           ║"
    echo -e "║  ${GREEN}├─ Communication:${NC}                                                ║"
    echo -e "║  ${GREEN}│  ${BLUE}• Discord${NC} (deb+snap) | ${PURPLE}• Telegram${NC} (snap+apt)                     ║"
    echo -e "║  ${GREEN}├─ Media:${NC}                                                        ║"
    echo -e "║  ${GREEN}│  ${GREEN}• VLC${NC} (apt) | ${GREEN}• OBS Studio${NC} (apt) | ${GREEN}• Steam${NC} (apt)            ║"
    echo -e "║  ${GREEN}│  ${GREEN}• qBittorrent${NC} (apt) | ${PURPLE}• LocalSend${NC} (snap+apt)                      ║"
    echo -e "║  ${GREEN}├─ Development:${NC}                                                  ║"
    echo -e "║  ${GREEN}│  ${PURPLE}• VS Code${NC} (snap+deb) | ${CYAN}• Node.js${NC} (curl+nvm) | ${GREEN}• Python${NC} (apt) ║"
    echo -e "║  ${GREEN}│  ${GREEN}• Git${NC} (apt) | ${GREEN}• Tmux${NC} (apt) | ${GREEN}• Vim${NC} (apt)                      ║"
    echo -e "║  ${GREEN}├─ Shell:${NC}                                                        ║"
    echo -e "║  ${GREEN}│  ${ORANGE}• Zsh + Oh My Zsh + Powerlevel10k${NC} (git+script) + plugins        ║"
    echo -e "║  ${GREEN}└─ Docker:${NC}                                                       ║"
    echo -e "║  ${GREEN}   ${GREEN}• Docker Engine${NC} (apt) | ${BLUE}• Docker Desktop${NC} (deb)              ║"
    echo -e "║  ${GREEN}   ${CYAN}• Docker Compose${NC} (apt) | ${GREEN}• Docker Permissions${NC} (group)      ║"
    
    echo "╠════════════════════════════════════════════════════════════════════╣"
    echo -e "║  ${YELLOW}🚀 NEXT STEPS:${NC}                                                   ║"
    echo -e "║  ${YELLOW}1. Restart your computer${NC} to apply all changes                     ║"
    echo -e "║  ${YELLOW}2. Open GNOME Tweaks${NC} to customize your theme                      ║"
    echo -e "║  ${YELLOW}3. Run 'p10k configure'${NC} to customize shell prompt                 ║"
    echo -e "║  ${YELLOW}4. Use Super+G${NC} to open Pavucontrol audio mixer                    ║"
    echo -e "║  ${YELLOW}5. Launch Docker Desktop${NC} from app menu & accept terms             ║"
    echo -e "║  ${YELLOW}6. Logout/login to use docker without sudo${NC}                        ║"
    echo -e "║  ${YELLOW}7. Launch your new apps from the application menu!${NC}                ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ $success_count -eq $total_steps ]; then
        echo -e "${GREEN}🎉 All components installed successfully! Your system is ready!${NC}"
    else
        echo -e "${YELLOW}⚠ Some components may have issues. Check above for details.${NC}"
    fi
    
    read -p "Press Enter to return to main menu..."
}

# Function to run script with error handling (for non-automated mode)
run_script() {
    local script_name=$1
    local description=$2
    local script_path="$SCRIPTS_DIR/$script_name"
    
    echo -e "\n${YELLOW}Running: $description...${NC}"
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        ./"$script_path"
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
    read -p "Choose an option (0-10): " choice
    
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
            run_script "docker-setup.sh" "Docker Setup"
            ;;
        9)
            echo -e "\n${YELLOW}Running ALL setup scripts...${NC}"
            echo -e "${YELLOW}This will take a while. Please wait...${NC}"
            
            run_script "system-setup.sh" "System & Package Management"
            run_script "theme-setup.sh" "Theme Installation"
            run_script "browsers-setup.sh" "Web Browsers"
            run_script "communication-setup.sh" "Communication Apps"
            run_script "media-setup.sh" "Media & Entertainment"
            run_script "dev-setup.sh" "Development Tools"
            run_script "shell-setup.sh" "Terminal & Shell"
            run_script "docker-setup.sh" "Docker Setup"
            
            echo -e "${GREEN}✓ All setup scripts completed!${NC}"
            read -p "Press Enter to continue..."
            ;;
        10)
            fully_automated_setup
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option! Please choose 0-10.${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done