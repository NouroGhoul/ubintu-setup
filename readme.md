
# Ubuntu Automated Setup Script

<div align="center">

![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%2B-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripts-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Automation](https://img.shields.io/badge/Automation-Fully_Automated-orange?style=for-the-badge)

**Automated Ubuntu Configuration Toolkit**

*A comprehensive setup script to configure fresh Ubuntu installations with essential tools and applications*

</div>

## Overview

This project provides an automated setup script for Ubuntu 22.04 and newer versions, designed for me to quickly configure a fresh Ubuntu installation with my perssonal tools , applications, and customizations through a single command.

## Quick Start

```bash
git clone https://github.com/NouroGhoul/ubuntu-setup.git
cd ubuntu-setup
chmod +x quick-setup.sh
./quick-setup.sh
```

## Project Structure

```
ubuntu-setup/
├── quick-setup.sh          # One-click launcher
├── setup-menu.sh           # Main interactive menu
└── bash-resources/         # Modular scripts
    ├── system-setup.sh     # System tools & packages
    ├── theme-setup.sh      # Desktop customization
    ├── browsers-setup.sh   # Web browsers
    ├── communication-setup.sh # Communication applications
    ├── media-setup.sh      # Media & entertainment
    ├── dev-setup.sh        # Development tools
    └── shell-setup.sh      # Terminal enhancements
```

## Features

- **Interactive Terminal Interface** - User-friendly terminal UI with color-coded selection options
- **Modular Design** - Install individual components or complete setups
- **Automatic Dependency Resolution** - Handles prerequisite packages automatically
- **Multiple Installation Methods** - Supports APT, Snap, Flatpak, and direct downloads
- **Comprehensive Verification** - Validates successful installations
- **Visual Progress Indicators** - Real-time feedback during installation

## Available Components

### System Utilities
- Flatpak package manager with Flathub repository
- GNOME Tweaks and extension management
- Timeshift system backup tool
- Proton VPN client

### Desktop Customization
- Graphite GTK Theme (dark modern theme)
- Tela Circle icon pack
- GNOME Shell customization tools
- GDM login screen theming

### Web Browsers
- Brave Browser (official repository)
- Google Chrome (direct .deb download)
- Chromium Browser (Ubuntu repositories)

### Communication Tools
- Discord (with Snap fallback)
- Telegram (with APT fallback)

### Media Applications
- VLC Media Player
- OBS Studio
- Steam gaming platform
- qBittorrent
- LocalSend file sharing

### Development Environment
- Docker and Docker Compose 
- Visual Studio Code (with .deb fallback)
- Node.js with nvm, npm, yarn, and pnpm
- Python3 with pip package manager
- Git, Tmux, and Vim

### Shell Configuration
- Zsh shell with Oh My Zsh framework
- Powerlevel10k theme
- Auto-suggestions and syntax highlighting
- Enhanced command completions

## Usage Instructions

### Complete Setup (Recommended)
```bash
./quick-setup.sh
```

### Interactive Menu
```bash
./setup-menu.sh
```

### Individual Component Installation
```bash
./bash-resources/dev-setup.sh
./bash-resources/browsers-setup.sh
./bash-resources/theme-setup.sh
```

## System Requirements

- **Operating System**: Ubuntu 22.04 LTS or newer
- **Internet Connection**: Active connection required for downloads
- **Permissions**: Sudo/administrative privileges
- **Storage**: Minimum 2GB free disk space

## Technical Implementation

- **Multiple Installation Methods**: Support for APT, Snap, Flatpak, and direct downloads
- **Error Handling**: Fallback methods for failed installations
- **Dependency Management**: Automatic installation of prerequisites
- **Cleanup Operations**: Removal of temporary files post-installation

## License

MIT License

<div align="center">

