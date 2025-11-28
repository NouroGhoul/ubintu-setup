<div align="center">

![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%2B-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripts-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Automation](https://img.shields.io/badge/🚀-Fully_Automated-orange?style=for-the-badge)

*an automated ubuntu early setup comands to start working.*

**One command to kick start**

</div>

## ⚡ Quick Start

```bash
git clone https://github.com/NouroGhoul/ubintu-setup.git
cd ubuntu-setup
chmod +x quick-setup.sh
./quick-setup.sh
```
## 📁 Project Structure
```
ubuntu-setup/
├── quick-setup.sh          # One-click launcher
├── setup-menu.sh           # Main interactive menu
└── bash-resources/         # Modular scripts
    ├── system-setup.sh     # System tools & packages
    ├── theme-setup.sh      # Desktop customization
    ├── browsers-setup.sh   # Web browsers
    ├── communication-setup.sh # Chat apps
    ├── media-setup.sh      # Media & entertainment
    ├── dev-setup.sh        # Development tools
    └── shell-setup.sh      # Terminal enhancements
```

## ✨ Features

- **🎮 Interactive Menus** - Beautiful terminal UI with color-coded options
- **🔧 Custom Selection** - Pick individual apps or install everything
- **📦 Auto Dependencies** - Automatic dependency resolution
- **🛡️ Fallback Methods** - Multiple installation sources
- **✅ Verification** - Comprehensive installation checks
- **🎨 Visual Feedback** - Real-time progress indicators

## 🎯 What's Included

### 🛠️ System Tools
- **📦 Flatpak** + Flathub repository
- **🎛️ GNOME Tweaks** & Extensions
- **💾 Timeshift** System backup
- **🔒 Proton VPN** Secure VPN

### 🎨 Desktop Customization
- **🎭 Graphite GTK Theme** - Dark, modern theme
- **🎪 Tela Circle Icons** - Beautiful icon pack
- **🖥️ GNOME Shell** customization
- **🎨 GDM Theme** - Login screen theming

### 🌐 Web Browsers
- **🦁 Brave Browser** (official repo)
- **🔴 Google Chrome** (.deb download)
- **🔵 Chromium Browser** (Ubuntu repos)

### 💬 Communication
- **🎮 Discord** (.deb + Snap fallback)
- **📱 Telegram** (Snap + APT fallback)

### 🎵 Media & Entertainment
- **🎬 VLC Media Player**
- **🎥 OBS Studio**
- **🎮 Steam**
- **📥 qBittorrent**
- **📲 LocalSend**

### 💻 Development
- **⚡ Visual Studio Code** (Snap + .deb fallback)
- **🟢 Node.js** + nvm + npm/yarn/pnpm
- **🐍 Python3** + pip
- **📝 Git, Tmux, Vim**

### 🐚 Shell Enhancement
- **🐚 Zsh** + Oh My Zsh
- **🚀 Powerlevel10k** theme
- **💡 Auto-suggestions**
- **🎨 Syntax Highlighting**
- **🔧 Enhanced Completions**

## 🎮 Usage

### 🚀 Quick Setup (Recommended)
```bash
./quick-setup.sh
```

### 🏠 Interactive Menu
```bash
./setup-menu.sh
```

### 🔧 Individual Categories
```bash
./bash-resources/dev-setup.sh
./bash-resources/browsers-setup.sh
./bash-resources/theme-setup.sh
```

## 📋 Requirements

- **🖥️ OS**: Ubuntu 22.04 LTS or newer
- **🌐 Internet**: Active connection
- **🔐 Permissions**: sudo privileges
- **💾 Storage**: 2GB+ free space

## 🛠️ Technical Features

- **Multiple Installation Methods**: APT, Snap, Flatpak, Direct Download
- **Comprehensive Error Handling**: Fallback methods for failed installations
- **Dependency Management**: Automatic prerequisite installation
- **Cleanup Operations**: Temporary file removal

## 📄 License

MIT License

---

<div align="center">

**Automate. Customize. Enjoy.** 🐧

*Transform your Ubuntu experience with one command!*

</div>
