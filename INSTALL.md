# Installation Guide

This guide provides detailed installation instructions for the AH Plugin across different setups.

## 🛠️ Installation Methods

### Method 1: Oh-My-Zsh Plugin Directory (Recommended)

This is the standard way to install custom Oh-My-Zsh plugins:

```bash
# Clone into Oh-My-Zsh custom plugins directory
git clone https://github.com/al0xd/ah.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah

# Add to plugins in ~/.zshrc
plugins=(git docker ... ah)

# Reload configuration
source ~/.zshrc
```

### Method 2: Direct Installation

For users who want to install without Oh-My-Zsh:

```bash
# Clone the repository
git clone https://github.com/al0xd/ah.git ~/.zsh-plugins/ah

# Add to ~/.zshrc
echo 'source ~/.zsh-plugins/ah/ah.plugin.zsh' >> ~/.zshrc

# Reload configuration
source ~/.zshrc
```

### Method 3: Antigen

For [Antigen](https://github.com/zsh-users/antigen) users:

```bash
# Add to ~/.zshrc
antigen bundle al0xd/ah

# Apply changes
antigen apply
```

### Method 4: Zinit

For [Zinit](https://github.com/zdharma-continuum/zinit) users:

```bash
# Add to ~/.zshrc
zinit load al0xd/ah

# Reload configuration
exec zsh
```

### Method 5: Oh-My-Zsh Manual Plugin

If you prefer to manage the plugin manually:

```bash
# Create plugin directory
mkdir -p ~/.oh-my-zsh/custom/plugins/ah

# Download plugin file
curl -o ~/.oh-my-zsh/custom/plugins/ah/ah.plugin.zsh \
  https://raw.githubusercontent.com/your-username/zsh-plugin-ah/main/ah.plugin.zsh

# Add to plugins in ~/.zshrc
plugins=(... ah)

# Reload
source ~/.zshrc
```

## 🔧 Dependencies

### Required
- **Zsh** 4.3.9+ (5.0.8+ recommended)
- **Basic Unix tools** (grep, awk, etc.)

### Optional (for specific features)
- **Docker & Docker Compose** - for Docker-related aliases
- **Cloudflared** - for Cloudflare tunnel commands
- **Fly CLI** - for Fly.io commands
- **Oh-My-Zsh** - for best integration experience

## ✅ Verification

After installation, verify the plugin is working:

```bash
# Check if plugin is loaded
ah

# Test a simple alias
echo $ZSH_CUSTOM

# Check Docker aliases (if Docker is installed)
dc --version
```

You should see the AH plugin help message when running `ah`.

## 🐛 Troubleshooting

### Plugin Not Loading

1. **Check plugins array in ~/.zshrc:**
   ```bash
   plugins=(git docker ah)  # Make sure 'ah' is included
   ```

2. **Verify plugin file exists:**
   ```bash
   ls -la ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah/
   ```

3. **Check for syntax errors:**
   ```bash
   zsh -n ~/.oh-my-zsh/custom/plugins/ah/ah.plugin.zsh
   ```

### Commands Not Found

1. **Reload your shell configuration:**
   ```bash
   source ~/.zshrc
   # or
   exec zsh
   ```

2. **Check if functions are loaded:**
   ```bash
   type dceb
   type ah-help
   ```

### Permission Issues

1. **Make plugin executable:**
   ```bash
   chmod +x ~/.oh-my-zsh/custom/plugins/ah/ah.plugin.zsh
   ```

2. **Check file ownership:**
   ```bash
   ls -la ~/.oh-my-zsh/custom/plugins/ah/
   ```

## 🔄 Updating

### Git-based Installation
```bash
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah
git pull origin main
source ~/.zshrc
```

### Manual Installation
```bash
# Re-download the latest version
curl -o ~/.oh-my-zsh/custom/plugins/ah/ah.plugin.zsh \
  https://raw.githubusercontent.com/your-username/zsh-plugin-ah/main/ah.plugin.zsh
source ~/.zshrc
```

## 🗑️ Uninstallation

### Oh-My-Zsh Plugin
```bash
# Remove from plugins array in ~/.zshrc
# plugins=(git docker)  # Remove 'ah' from the list

# Remove plugin directory
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah

# Reload configuration
source ~/.zshrc
```

### Direct Installation
```bash
# Remove source line from ~/.zshrc
# Remove plugin directory
rm -rf ~/.zsh-plugins/ah

# Reload configuration
source ~/.zshrc
```

## 💡 Tips

1. **Backup your ~/.zshrc** before making changes
2. **Use `oh-my-zsh` themes** that show plugin information
3. **Check compatibility** with other plugins
4. **Use tab completion** with Docker commands
5. **Customize aliases** by creating your own plugin that sources this one

## 🎯 Next Steps

After successful installation:

1. **Read the documentation:** `ah` command shows all available functions
2. **Try basic commands:** Start with `dcu`, `dceb web`, etc.
3. **Customize:** Add your own aliases to complement the plugin
4. **Share feedback:** Report issues or suggest improvements

---

**Need help?** Open an issue on [GitHub](https://github.com/your-username/zsh-plugin-ah/issues)
