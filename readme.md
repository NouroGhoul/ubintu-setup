# Ubuntu Setup Automation

![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%2B-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripts-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)

A minimal, interactive bash script collection for automating Ubuntu setup and application installation.

## 🚀 Quick Start

```bash
git clone https://github.com/NouroGhoul/ubintu-setup.git
cd ubuntu-setup
chmod +x quick-setup.sh
./quick-setup.sh
```

## 📁 Structure

```
ubuntu-setup/
├── quick-setup.sh          # One-click launcher
├── setup-menu.sh           # Main interactive menu
└── bash-resources/         # Category scripts
    ├── system-setup.sh     # System tools & packages
    ├── theme-setup.sh      # Desktop themes
    ├── browsers-setup.sh   # Web browsers  
    ├── communication-setup.sh # Chat apps
    ├── media-setup.sh      # Media & entertainment
    ├── dev-setup.sh        # Development tools
    └── shell-setup.sh      # Terminal enhancements
```

## 🎯 Features

- **Interactive Menus** - Choose what to install
- **Custom Selection** - Pick individual apps
- **Auto Dependencies** - Handles prerequisites
- **Fallback Methods** - Multiple installation sources
- **Verification** - Checks successful installation

## 📦 What's Available

### System Tools
- Flatpak + Flathub
- GNOME Tweaks & Extensions  
- Timeshift Backup
- Proton VPN

### Desktop
- Graphite GTK Theme
- Tela Circle Icons (optional)
- GNOME Shell customization

### Browsers
- Brave (official repo)
- Google Chrome (.deb)

### Communication  
- Discord (.deb + Snap fallback)
- Telegram

### Media
- VLC Media Player
- OBS Studio
- Steam
- qBittorrent
- LocalSend

### Development
- VS Code (Snap + .deb fallback)
- Node.js + nvm + npm/yarn/pnpm
- Python3 + pip
- Git, Tmux, Vim

### Shell
- Zsh + Oh My Zsh
- Powerlevel10k theme
- Auto-suggestions & syntax highlighting
- Enhanced completions

## 🛠️ Usage

### Interactive Menu
```bash
./setup-menu.sh
```

### Individual Categories
```bash
./bash-resources/dev-setup.sh
./bash-resources/browsers-setup.sh
```

### Quick Setup (All)
```bash
./quick-setup.sh
```

## ⚡ Requirements

- Ubuntu 22.04+
- Internet connection
- sudo privileges

## 📄 License

MIT License

---

**Automate. Customize. Enjoy.** 🐧