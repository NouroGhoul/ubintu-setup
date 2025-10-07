#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Shell setup options
INSTALL_ZSH=false
INSTALL_OH_MY_ZSH=false
INSTALL_POWERLEVEL10K=false
INSTALL_AUTO_SUGGESTIONS=false
INSTALL_SYNTAX_HIGHLIGHTING=false
INSTALL_AUTOCOMPLETIONS=false
CHANGE_DEFAULT_SHELL=false

show_shell_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║         SHELL ENHANCEMENT SETUP      ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install All Shell Enhancements  ║"
    echo -e "║  ${GREEN}2${BLUE}  Custom Selection                ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_shell_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║        CUSTOM SHELL SELECTION        ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Zsh Shell                      ║"
    echo -e "║  ${GREEN}2${BLUE}  Oh My Zsh Framework            ║"
    echo -e "║  ${GREEN}3${BLUE}  Powerlevel10k Theme            ║"
    echo -e "║  ${GREEN}4${BLUE}  Zsh Auto Suggestions           ║"
    echo -e "║  ${GREEN}5${BLUE}  Zsh Syntax Highlighting        ║"
    echo -e "║  ${GREEN}6${BLUE}  Zsh Auto Completions           ║"
    echo -e "║  ${GREEN}7${BLUE}  Change Default Shell to Zsh    ║"
    echo -e "║  ${GREEN}8${BLUE}  Install Selected               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  Zsh: $([ "$INSTALL_ZSH" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Oh My Zsh: $([ "$INSTALL_OH_MY_ZSH" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Powerlevel10k: $([ "$INSTALL_POWERLEVEL10K" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Auto Suggestions: $([ "$INSTALL_AUTO_SUGGESTIONS" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Syntax Highlighting: $([ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Auto Completions: $([ "$INSTALL_AUTOCOMPLETIONS" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Change Default Shell: $([ "$CHANGE_DEFAULT_SHELL" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    
    # Show dependency warnings
    show_dependency_warnings
}

show_dependency_warnings() {
    local warnings=()
    
    if [ "$INSTALL_OH_MY_ZSH" = true ] && [ "$INSTALL_ZSH" = false ]; then
        warnings+=("Oh My Zsh requires Zsh to be installed")
    fi
    
    if [ "$INSTALL_POWERLEVEL10K" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        warnings+=("Powerlevel10k requires Oh My Zsh to be installed")
    fi
    
    if [ "$INSTALL_AUTO_SUGGESTIONS" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        warnings+=("Auto Suggestions require Oh My Zsh to be installed")
    fi
    
    if [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        warnings+=("Syntax Highlighting requires Oh My Zsh to be installed")
    fi
    
    if [ "$INSTALL_AUTOCOMPLETIONS" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        warnings+=("Auto Completions require Oh My Zsh to be installed")
    fi
    
    if [ "$CHANGE_DEFAULT_SHELL" = true ] && [ "$INSTALL_ZSH" = false ]; then
        warnings+=("Changing default shell requires Zsh to be installed")
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}Dependency warnings:${NC}"
        for warning in "${warnings[@]}"; do
            echo -e "  ${RED}⚠${NC} $warning"
        done
    fi
}

check_prerequisites() {
    local missing_deps=()
    
    # Check if Zsh is selected but Oh My Zsh dependencies require it
    if [ "$INSTALL_OH_MY_ZSH" = true ] && [ "$INSTALL_ZSH" = false ]; then
        if ! command -v zsh &> /dev/null; then
            echo -e "${YELLOW}Oh My Zsh requires Zsh. Enabling Zsh installation automatically.${NC}"
            INSTALL_ZSH=true
        fi
    fi
    
    # Check if Oh My Zsh is selected but Zsh is not installed/selected
    if [ "$INSTALL_POWERLEVEL10K" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            echo -e "${YELLOW}Powerlevel10k requires Oh My Zsh. Enabling Oh My Zsh installation automatically.${NC}"
            INSTALL_OH_MY_ZSH=true
            # Also enable Zsh if not already
            if [ "$INSTALL_ZSH" = false ] && ! command -v zsh &> /dev/null; then
                echo -e "${YELLOW}Oh My Zsh requires Zsh. Enabling Zsh installation automatically.${NC}"
                INSTALL_ZSH=true
            fi
        fi
    fi
    
    # Check plugins dependencies
    if [ "$INSTALL_AUTO_SUGGESTIONS" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            echo -e "${YELLOW}Auto Suggestions require Oh My Zsh. Enabling Oh My Zsh installation automatically.${NC}"
            INSTALL_OH_MY_ZSH=true
            if [ "$INSTALL_ZSH" = false ] && ! command -v zsh &> /dev/null; then
                echo -e "${YELLOW}Oh My Zsh requires Zsh. Enabling Zsh installation automatically.${NC}"
                INSTALL_ZSH=true
            fi
        fi
    fi
    
    if [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            echo -e "${YELLOW}Syntax Highlighting requires Oh My Zsh. Enabling Oh My Zsh installation automatically.${NC}"
            INSTALL_OH_MY_ZSH=true
            if [ "$INSTALL_ZSH" = false ] && ! command -v zsh &> /dev/null; then
                echo -e "${YELLOW}Oh My Zsh requires Zsh. Enabling Zsh installation automatically.${NC}"
                INSTALL_ZSH=true
            fi
        fi
    fi
    
    if [ "$INSTALL_AUTOCOMPLETIONS" = true ] && [ "$INSTALL_OH_MY_ZSH" = false ]; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            echo -e "${YELLOW}Auto Completions require Oh My Zsh. Enabling Oh My Zsh installation automatically.${NC}"
            INSTALL_OH_MY_ZSH=true
            if [ "$INSTALL_ZSH" = false ] && ! command -v zsh &> /dev/null; then
                echo -e "${YELLOW}Oh My Zsh requires Zsh. Enabling Zsh installation automatically.${NC}"
                INSTALL_ZSH=true
            fi
        fi
    fi
    
    # Check if changing default shell but Zsh is not installed/selected
    if [ "$CHANGE_DEFAULT_SHELL" = true ] && [ "$INSTALL_ZSH" = false ]; then
        if ! command -v zsh &> /dev/null; then
            echo -e "${YELLOW}Changing default shell requires Zsh. Enabling Zsh installation automatically.${NC}"
            INSTALL_ZSH=true
        fi
    fi
    
    # Check for system dependencies
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}The following dependencies will be installed: ${missing_deps[*]}${NC}"
    fi
    
    return 0
}

install_zsh() {
    echo -e "\n${YELLOW}Installing Zsh...${NC}"
    
    if command -v zsh &> /dev/null; then
        echo -e "${YELLOW}Zsh is already installed.${NC}"
        ZSH_VERSION=$(zsh --version | head -n1)
        echo -e "${GREEN}✓ $ZSH_VERSION${NC}"
        return 0
    fi

    sudo apt update
    sudo apt install zsh -y

    if command -v zsh &> /dev/null; then
        ZSH_VERSION=$(zsh --version | head -n1)
        echo -e "${GREEN}✓ $ZSH_VERSION installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Zsh${NC}"
        return 1
    fi
}

install_oh_my_zsh() {
    echo -e "\n${YELLOW}Installing Oh My Zsh...${NC}"
    
    # Check if Zsh is installed
    if ! command -v zsh &> /dev/null; then
        echo -e "${RED}✗ Zsh is not installed. Cannot install Oh My Zsh.${NC}"
        return 1
    fi
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${YELLOW}Oh My Zsh is already installed.${NC}"
        return 0
    fi

    # Install Oh My Zsh via official script
    echo -e "${YELLOW}Downloading and installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${GREEN}✓ Oh My Zsh installed successfully!${NC}"
        
        # Create a basic .zshrc if it doesn't exist
        if [ ! -f "$HOME/.zshrc" ]; then
            cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
            echo -e "${GREEN}✓ Created default .zshrc configuration${NC}"
        fi
        return 0
    else
        echo -e "${RED}✗ Failed to install Oh My Zsh${NC}"
        return 1
    fi
}

install_powerlevel10k() {
    echo -e "\n${YELLOW}Installing Powerlevel10k theme...${NC}"
    
    # Check if Oh My Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${RED}✗ Oh My Zsh is not installed. Cannot install Powerlevel10k.${NC}"
        return 1
    fi
    
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    if [ -d "$p10k_dir" ]; then
        echo -e "${YELLOW}Powerlevel10k is already installed.${NC}"
        return 0
    fi

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"

    if [ -d "$p10k_dir" ]; then
        echo -e "${GREEN}✓ Powerlevel10k installed successfully!${NC}"
        
        # Update .zshrc to use powerlevel10k theme
        if [ -f "$HOME/.zshrc" ]; then
            if grep -q "ZSH_THEME=" "$HOME/.zshrc"; then
                sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
            else
                echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
            fi
            echo -e "${GREEN}✓ Updated .zshrc to use Powerlevel10k theme${NC}"
        fi
        return 0
    else
        echo -e "${RED}✗ Failed to install Powerlevel10k${NC}"
        return 1
    fi
}

install_autosuggestions() {
    echo -e "\n${YELLOW}Installing Zsh Auto Suggestions...${NC}"
    
    # Check if Oh My Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${RED}✗ Oh My Zsh is not installed. Cannot install Auto Suggestions.${NC}"
        return 1
    fi
    
    local autosuggest_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    
    if [ -d "$autosuggest_dir" ]; then
        echo -e "${YELLOW}Zsh Auto Suggestions is already installed.${NC}"
        return 0
    fi

    git clone https://github.com/zsh-users/zsh-autosuggestions "$autosuggest_dir"

    if [ -d "$autosuggest_dir" ]; then
        echo -e "${GREEN}✓ Zsh Auto Suggestions installed successfully!${NC}"
        
        # Add to plugins in .zshrc
        update_zshrc_plugins "zsh-autosuggestions"
        return 0
    else
        echo -e "${RED}✗ Failed to install Zsh Auto Suggestions${NC}"
        return 1
    fi
}

install_syntax_highlighting() {
    echo -e "\n${YELLOW}Installing Zsh Syntax Highlighting...${NC}"
    
    # Check if Oh My Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${RED}✗ Oh My Zsh is not installed. Cannot install Syntax Highlighting.${NC}"
        return 1
    fi
    
    local syntax_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    
    if [ -d "$syntax_dir" ]; then
        echo -e "${YELLOW}Zsh Syntax Highlighting is already installed.${NC}"
        return 0
    fi

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax_dir"

    if [ -d "$syntax_dir" ]; then
        echo -e "${GREEN}✓ Zsh Syntax Highlighting installed successfully!${NC}"
        
        # Add to plugins in .zshrc
        update_zshrc_plugins "zsh-syntax-highlighting"
        return 0
    else
        echo -e "${RED}✗ Failed to install Zsh Syntax Highlighting${NC}"
        return 1
    fi
}

install_autocompletions() {
    echo -e "\n${YELLOW}Installing Zsh Auto Completions...${NC}"
    
    # Check if Oh My Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${RED}✗ Oh My Zsh is not installed. Cannot install Auto Completions.${NC}"
        return 1
    fi
    
    local completions_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions"
    
    if [ -d "$completions_dir" ]; then
        echo -e "${YELLOW}Zsh Auto Completions is already installed.${NC}"
        return 0
    fi

    git clone https://github.com/zsh-users/zsh-completions "$completions_dir"

    if [ -d "$completions_dir" ]; then
        echo -e "${GREEN}✓ Zsh Auto Completions installed successfully!${NC}"
        
        # Add to plugins in .zshrc
        update_zshrc_plugins "zsh-completions"
        
        # Add to fpath in .zshrc
        if [ -f "$HOME/.zshrc" ]; then
            if ! grep -q "fpath.*zsh-completions" "$HOME/.zshrc"; then
                echo 'fpath+=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions/src' >> "$HOME/.zshrc"
            fi
        fi
        return 0
    else
        echo -e "${RED}✗ Failed to install Zsh Auto Completions${NC}"
        return 1
    fi
}

change_default_shell() {
    echo -e "\n${YELLOW}Changing default shell to Zsh...${NC}"
    
    # Check if Zsh is installed
    if ! command -v zsh &> /dev/null; then
        echo -e "${RED}✗ Zsh is not installed. Cannot change default shell.${NC}"
        return 1
    fi

    local current_shell=$(basename "$SHELL")
    if [ "$current_shell" = "zsh" ]; then
        echo -e "${YELLOW}Zsh is already the default shell.${NC}"
        return 0
    fi

    # Change default shell
    chsh -s $(which zsh)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Default shell changed to Zsh successfully!${NC}"
        echo -e "${YELLOW}Note: This change will take effect after you log out and log back in.${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to change default shell to Zsh${NC}"
        echo -e "${YELLOW}You may need to run: chsh -s \$(which zsh)${NC}"
        return 1
    fi
}

update_zshrc_plugins() {
    local plugin=$1
    
    if [ ! -f "$HOME/.zshrc" ]; then
        return 1
    fi

    # Check if plugins line exists
    if grep -q "plugins=(" "$HOME/.zshrc"; then
        # Check if plugin is already in the list
        if ! grep -q "plugins=.*$plugin" "$HOME/.zshrc"; then
            # Add plugin to existing list
            sed -i "s/^plugins=(/plugins=($plugin /" "$HOME/.zshrc"
            echo -e "${GREEN}✓ Added $plugin to .zshrc plugins${NC}"
        fi
    else
        # Create plugins line if it doesn't exist
        echo "plugins=($plugin)" >> "$HOME/.zshrc"
        echo -e "${GREEN}✓ Created plugins line in .zshrc with $plugin${NC}"
    fi
}

configure_shell_environment() {
    echo -e "\n${YELLOW}Configuring shell environment...${NC}"
    
    # Add useful aliases to .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        # Add useful aliases if they don't exist
        if ! grep -q "alias ll=" "$HOME/.zshrc"; then
            echo '' >> "$HOME/.zshrc"
            echo '# Custom aliases' >> "$HOME/.zshrc"
            echo 'alias ll="ls -la"' >> "$HOME/.zshrc"
            echo 'alias la="ls -A"' >> "$HOME/.zshrc"
            echo 'alias l="ls -CF"' >> "$HOME/.zshrc"
            echo 'alias update="sudo apt update && sudo apt upgrade"' >> "$HOME/.zshrc"
            echo 'alias clean="sudo apt autoremove && sudo apt autoclean"' >> "$HOME/.zshrc"
            echo -e "${GREEN}✓ Added useful aliases to .zshrc${NC}"
        fi
    fi
}

install_dependencies() {
    echo -e "\n${YELLOW}Installing system dependencies...${NC}"
    local deps=()
    
    if ! command -v curl &> /dev/null; then
        deps+=("curl")
    fi
    
    if ! command -v git &> /dev/null; then
        deps+=("git")
    fi
    
    if [ ${#deps[@]} -gt 0 ]; then
        sudo apt update
        sudo apt install -y "${deps[@]}"
        echo -e "${GREEN}✓ Dependencies installed: ${deps[*]}${NC}"
    else
        echo -e "${YELLOW}All dependencies are already installed.${NC}"
    fi
}

confirm_installation() {
    local selections=()
    [ "$INSTALL_ZSH" = true ] && selections+=("Zsh Shell")
    [ "$INSTALL_OH_MY_ZSH" = true ] && selections+=("Oh My Zsh Framework")
    [ "$INSTALL_POWERLEVEL10K" = true ] && selections+=("Powerlevel10k Theme")
    [ "$INSTALL_AUTO_SUGGESTIONS" = true ] && selections+=("Zsh Auto Suggestions")
    [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ] && selections+=("Zsh Syntax Highlighting")
    [ "$INSTALL_AUTOCOMPLETIONS" = true ] && selections+=("Zsh Auto Completions")
    [ "$CHANGE_DEFAULT_SHELL" = true ] && selections+=("Change Default Shell to Zsh")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No shell enhancements selected for installation.${NC}"
        return 1
    fi

    echo -e "\n${YELLOW}The following will be installed/configured:${NC}"
    for item in "${selections[@]}"; do
        echo -e "  ${GREEN}✓${NC} $item"
    done
    
    # Show auto-added dependencies
    check_prerequisites > /dev/null  # Run silently to detect auto-adds
    local auto_added=()
    [ "$INSTALL_ZSH" = true ] && [[ "${selections[*]}" != *"Zsh Shell"* ]] && auto_added+=("Zsh Shell")
    [ "$INSTALL_OH_MY_ZSH" = true ] && [[ "${selections[*]}" != *"Oh My Zsh"* ]] && auto_added+=("Oh My Zsh Framework")
    
    if [ ${#auto_added[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}Automatically added dependencies:${NC}"
        for item in "${auto_added[@]}"; do
            echo -e "  ${BLUE}⚡${NC} $item (required)"
        done
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

install_selected_shell() {
    local success=true
    
    # Check and install prerequisites
    check_prerequisites
    
    # Install system dependencies
    install_dependencies
    
    # Install in correct order
    if [ "$INSTALL_ZSH" = true ]; then
        install_zsh
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_OH_MY_ZSH" = true ]; then
        install_oh_my_zsh
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_POWERLEVEL10K" = true ]; then
        install_powerlevel10k
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_AUTO_SUGGESTIONS" = true ]; then
        install_autosuggestions
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ]; then
        install_syntax_highlighting
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$INSTALL_AUTOCOMPLETIONS" = true ]; then
        install_autocompletions
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$CHANGE_DEFAULT_SHELL" = true ]; then
        change_default_shell
        [ $? -ne 0 ] && success=false
    fi
    
    # Configure shell environment
    configure_shell_environment
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ Shell enhancement installation completed!${NC}"
        echo -e "\n${YELLOW}Next steps:${NC}"
        echo -e "1. ${GREEN}Log out and log back in${NC} for shell changes to take effect"
        if [ "$INSTALL_POWERLEVEL10K" = true ]; then
            echo -e "2. Run ${GREEN}p10k configure${NC} to customize your Powerlevel10k prompt"
        fi
        echo -e "3. Explore your new shell with ${GREEN}enhanced autocomplete, suggestions, and syntax highlighting!${NC}"
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main shell installation logic
echo -e "${YELLOW}Shell Enhancement Setup${NC}"

while true; do
    show_shell_menu
    read -p "Choose an option (0-2): " main_choice
    
    case $main_choice in
        1)
            # Install all shell enhancements
            INSTALL_ZSH=true
            INSTALL_OH_MY_ZSH=true
            INSTALL_POWERLEVEL10K=true
            INSTALL_AUTO_SUGGESTIONS=true
            INSTALL_SYNTAX_HIGHLIGHTING=true
            INSTALL_AUTOCOMPLETIONS=true
            CHANGE_DEFAULT_SHELL=true
            if confirm_installation; then
                install_selected_shell
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Custom selection
            while true; do
                show_custom_shell_menu
                read -p "Choose an option (0-8): " custom_choice
                
                case $custom_choice in
                    1)
                        INSTALL_ZSH=$([ "$INSTALL_ZSH" = true ] && echo false || echo true)
                        ;;
                    2)
                        INSTALL_OH_MY_ZSH=$([ "$INSTALL_OH_MY_ZSH" = true ] && echo false || echo true)
                        ;;
                    3)
                        INSTALL_POWERLEVEL10K=$([ "$INSTALL_POWERLEVEL10K" = true ] && echo false || echo true)
                        ;;
                    4)
                        INSTALL_AUTO_SUGGESTIONS=$([ "$INSTALL_AUTO_SUGGESTIONS" = true ] && echo false || echo true)
                        ;;
                    5)
                        INSTALL_SYNTAX_HIGHLIGHTING=$([ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ] && echo false || echo true)
                        ;;
                    6)
                        INSTALL_AUTOCOMPLETIONS=$([ "$INSTALL_AUTOCOMPLETIONS" = true ] && echo false || echo true)
                        ;;
                    7)
                        CHANGE_DEFAULT_SHELL=$([ "$CHANGE_DEFAULT_SHELL" = true ] && echo false || echo true)
                        ;;
                    8)
                        if confirm_installation; then
                            install_selected_shell
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