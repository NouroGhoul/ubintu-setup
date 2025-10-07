# Ubuntu Setup Automation Scripts

![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%2B-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripts-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Automation](https://img.shields.io/badge/Automation-Setup-FF6B6B?style=for-the-badge)

A comprehensive collection of modular bash scripts designed to automate the setup and configuration of a fresh Ubuntu installation. This toolkit installs essential applications, development tools, system utilities, and enhances the desktop environment with a modern workflow.

## ✨ Features

- **🚀 One-Click Setup** - Complete system configuration with a single command
- **📱 Modular Design** - Install only what you need with interactive menu
- **🎨 Beautiful UI** - Colorful CLI interface with progress indicators
- **⚡ Production Ready** - Battle-tested scripts with error handling
- **🔧 Developer Focused** - Optimized for development workflows
- **🎯 Customizable** - Easy to modify and extend for your needs

## 📁 Project Structure

```
ubuntu-setup-scripts/
├── 📄 README.md                 # This documentation
├── 🚀 quick-setup.sh            # One-click setup launcher
├── 🎮 setup-menu.sh             # Main interactive menu
└── 📂 bash-resources/           # Category-specific scripts
    ├── 🔧 system-setup.sh       # System tools & package management
    ├── 🎨 theme-setup.sh        # Graphite theme installation
    ├── 🌐 browsers-setup.sh     # Web browsers (Brave, Chrome)
    ├── 💬 communication-setup.sh # Communication apps
    ├── 🎵 media-setup.sh        # Media & entertainment
    ├── 💻 dev-setup.sh          # Development tools
    └── 🐚 shell-setup.sh        # Terminal & shell enhancements
```

## 📦 What Gets Installed

### 🛠️ System & Core
| Category | Applications |
|----------|--------------|
| **Package Management** | Flatpak, Flathub repository, Synaptic |
| **System Tools** | Timeshift (backups), GNOME Tweaks, GNOME Extensions |
| **Desktop** | Graphite GTK Theme, customization tools |

### 🌐 Web & Communication
| Category | Applications |
|----------|--------------|
| **Browsers** | Brave, Google Chrome |
| **Communication** | Discord, Telegram |
| **Productivity** | LocalSend (file sharing) |

### 🎵 Media & Entertainment
| Category | Applications |
|----------|--------------|
| **Media Players** | VLC Media Player |
| **Content Creation** | OBS Studio, GIMP, Inkscape |
| **Gaming** | Steam |
| **Utilities** | qBittorrent |

### 💻 Development Stack
| Category | Tools |
|----------|-------|
| **Editors & IDE** | VS Code, Vim |
| **Version Control** | Git |
| **Languages** | Node.js, Python3, pip |
| **Terminal** | Tmux, Zsh, Oh My Zsh, Powerlevel10k |

## 🚀 Quick Start

### Prerequisites
- Ubuntu 22.04 LTS or newer
- Internet connection
- sudo privileges

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/NouroGhoul/ubintu-setup.git
   cd ubuntu-setup-scripts
   ```

2. **Run the quick setup:**
   ```bash
   chmod +x quick-setup.sh
   ./quick-setup.sh
   ```

3. **Follow the interactive menu** to select which components to install.

## 🎯 Usage

### Interactive Menu (Recommended)
```bash
./setup-menu.sh
```

You'll see this interactive menu:
```
╔══════════════════════════════════════╗
║        UBUNTU SETUP MENU             ║
╠══════════════════════════════════════╣
║  1  System & Package Management    ║
║  2  Theme Installation             ║
║  3  Web Browsers                   ║
║  4  Communication Apps             ║
║  5  Media & Entertainment          ║
║  6  Development Tools              ║
║  7  Terminal & Shell               ║
║  8  Run ALL Setup Scripts          ║
║  0  Exit                           ║
╚══════════════════════════════════════╝
```

### Individual Script Execution
You can also run scripts directly from the `bash-resources/` folder:

```bash
# Install only development tools
./bash-resources/dev-setup.sh

# Install only media applications
./bash-resources/media-setup.sh

# Run complete setup (all scripts)
./setup-menu.sh
# Then choose option 8
```

### Quick Setup
For the fastest setup, use the quick launcher:
```bash
./quick-setup.sh
```

## 📋 Script Documentation

### Main Control Scripts (Root Directory)

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-menu.sh` | **Interactive CLI Menu** | Primary interface for all installations |
| `quick-setup.sh` | **One-Click Launcher** | Makes scripts executable and starts menu |

### Category Scripts (bash-resources/)

| Script | Installs | Estimated Time |
|--------|----------|----------------|
| `system-setup.sh` | Flatpak, GNOME tools, Timeshift | 2-3 minutes |
| `theme-setup.sh` | Graphite GTK Theme | 1-2 minutes |
| `browsers-setup.sh` | Brave, Google Chrome | 2-3 minutes |
| `communication-setup.sh` | Discord, Telegram | 1-2 minutes |
| `media-setup.sh` | VLC, OBS, Steam, qBittorrent, LocalSend | 3-5 minutes |
| `dev-setup.sh` | Git, Node.js, Python, VS Code, Tmux, Vim | 4-6 minutes |
| `shell-setup.sh` | Zsh, Oh My Zsh, Powerlevel10k, plugins | 3-5 minutes |

## ⚙️ Configuration Details

### System Configuration
- **Flatpak** configured with Flathub repository
- **GNOME Shell Extensions** enabled for customization
- **Timeshift** set up for system snapshots

### Theme & Appearance
- **Graphite GTK Theme** - Modern dark theme
- Can be activated via GNOME Tweaks after installation

### Development Environment
- **Node.js** LTS version from NodeSource
- **Python3** with pip package manager
- **VS Code** with official Microsoft repository
- **Git** configured with standard settings
- **Build Essentials** for native module compilation

### Shell Enhancement
- **Zsh** as default shell with Oh My Zsh framework
- **Powerlevel10k** theme for beautiful prompts
- **zsh-autosuggestions** for command suggestions
- **zsh-syntax-highlighting** for better command visibility
- **Tmux** for terminal multiplexing
- Enhanced terminal experience with plugins

## 🔧 Customization Guide

### Adding New Packages
Edit the respective script file in `bash-resources/`:

```bash
# Example: Add to bash-resources/dev-setup.sh
echo "Installing additional development tools..."
sudo apt install postman docker -y
```

### Modifying Themes
Edit `bash-resources/theme-setup.sh` to change themes:

```bash
# Replace Graphite with another theme
git clone https://github.com/author/another-theme.git
cd another-theme
./install.sh
```

### Customizing Shell Setup
After running `shell-setup.sh`, customize your shell:

```bash
# Configure Powerlevel10k
p10k configure

# Edit Zsh configuration
nano ~/.zshrc

# Add Oh My Zsh plugins
# Edit plugins=(git docker node npm python zsh-autosuggestions zsh-syntax-highlighting)
```

### Adding Oh My Zsh Plugins
The shell setup automatically installs useful plugins. To add more:

```bash
# Install additional plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions

# Add to plugins in ~/.zshrc
plugins=(... zsh-completions)
```

## 🐛 Troubleshooting

### Common Issues

**Script Permission Denied**
```bash
chmod +x *.sh
chmod +x bash-resources/*.sh
```

**Script Not Found**
```bash
# Make sure you're in the correct directory
cd ubuntu-setup-scripts
```

**Oh My Zsh Installation Failed**
```bash
# Manual installation if git clone fails
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
```

**Zsh Not Default Shell**
```bash
chsh -s $(which zsh)
# Log out and log back in
```

**Powerlevel10k Prompt Not Appearing**
```bash
# Restart terminal or run:
exec zsh
p10k configure
```

**Flatpak Apps Not Showing**
```bash
# Restart session or run:
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

**Node.js Installation Failed**
```bash
# Manual installation
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

**Theme Not Applying**
```bash
# Install GNOME Tweaks and apply manually
sudo apt install gnome-tweaks
# Open Tweaks > Appearance > Themes
```

### Debug Mode
Run scripts with debug output:
```bash
bash -x setup-menu.sh
bash -x bash-resources/shell-setup.sh
```

### Log Files
Check system logs for package manager issues:
```bash
# APT logs
tail -f /var/log/apt/term.log

# Check Zsh configuration
cat ~/.zshrc
```

## 📋 Pre-Installation Checklist

- [ ] Backup important data
- [ ] Ensure stable internet connection
- [ ] Verify sudo privileges
- [ ] Check available disk space (minimum 10GB free)
- [ ] Update existing system: `sudo apt update && sudo apt upgrade`

## 🚨 Post-Installation Steps

### Required Actions
1. **Log out and log back in** for Zsh and theme changes to take effect
2. **Configure Powerlevel10k**: Run `p10k configure` after first Zsh launch
3. **Set up Timeshift** for automatic backups
4. **Configure GNOME Extensions** via browser extension

### Recommended Actions
1. **Customize VS Code** with your preferred extensions
2. **Set up Git credentials**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
3. **Configure Brave/Chrome** with your accounts and extensions
4. **Set up development environments** for your projects
5. **Explore Oh My Zsh plugins** and enable ones you need
6. **Customize Powerlevel10k** prompt to your preference

### Shell Customization Examples
```bash
# Enable Oh My Zsh plugins
nano ~/.zshrc
# Add: plugins=(git node npm python docker tmux zsh-autosuggestions zsh-syntax-highlighting)

# Set favorite aliases
echo "alias ll='ls -la'" >> ~/.zshrc
echo "alias update='sudo apt update && sudo apt upgrade'" >> ~/.zshrc

# Reload configuration
source ~/.zshrc
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Report Bugs** - Open an issue with detailed description
2. **Suggest Features** - Share your ideas for improvements
3. **Submit Pull Requests** - Add new scripts or enhance existing ones

### Development Guidelines
- Keep scripts modular and focused
- Include error handling and user feedback
- Test scripts on fresh Ubuntu installations
- Document new features in README
- Maintain the folder structure (scripts in `bash-resources/`)
- Use proper git cloning for external resources

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Graphite Theme** by [vinceliuice](https://github.com/vinceliuice/Graphite-gtk-theme)
- **Oh My Zsh** community for amazing shell plugins and framework
- **Powerlevel10k** for the beautiful prompt theme
- **zsh-users** for essential plugins (autosuggestions, syntax-highlighting)
- **Ubuntu** team for an excellent Linux distribution

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Troubleshooting](#-troubleshooting) section above
2. Search existing [Issues](../../issues)
3. Create a new issue with detailed information including:
   - Ubuntu version
   - Script that failed
   - Error messages
   - Steps to reproduce

---

**Happy Ubuntu Setup!** 🐧✨

*Automate your workflow, focus on what matters.*