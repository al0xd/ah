#!/bin/bash

# Quick install script for AH Plugin
# This script installs the plugin directly into Oh-My-Zsh

set -e

echo "🚀 AH Plugin Quick Installer"
echo "============================"
echo ""

# Check if Oh-My-Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "❌ Oh-My-Zsh not found. Please install Oh-My-Zsh first:"
    echo "   sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    exit 1
fi

# Set plugin directory
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ah"

echo "📁 Plugin will be installed to: $PLUGIN_DIR"
echo ""

# Check if plugin already exists
if [ -d "$PLUGIN_DIR" ]; then
    echo "⚠️  Plugin directory already exists. Do you want to update? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled."
        exit 1
    fi
    echo "🔄 Updating existing installation..."
    rm -rf "$PLUGIN_DIR"
fi

# Create plugin directory
mkdir -p "$PLUGIN_DIR"

# Copy plugin files
echo "📦 Installing plugin files..."
cp "$(dirname "$0")/ah.plugin.zsh" "$PLUGIN_DIR/"
cp "$(dirname "$0")/README.md" "$PLUGIN_DIR/"
cp "$(dirname "$0")/LICENSE" "$PLUGIN_DIR/"

echo "✅ Plugin files installed successfully!"
echo ""

# Check if plugin is already in .zshrc
ZSHRC="$HOME/.zshrc"
if grep -q "plugins=.*ah" "$ZSHRC"; then
    echo "✅ Plugin already configured in .zshrc"
else
    echo "⚙️  Configuring plugin in .zshrc..."
    
    # Backup .zshrc
    cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📋 Backup created: $ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Add plugin to plugins array
    if grep -q "plugins=(" "$ZSHRC"; then
        # Replace existing plugins line
        sed -i.tmp 's/plugins=(\([^)]*\))/plugins=(\1 ah)/' "$ZSHRC"
        rm "$ZSHRC.tmp" 2>/dev/null || true
        echo "✅ Added 'ah' to existing plugins list"
    else
        # Add new plugins line
        echo "" >> "$ZSHRC"
        echo "# AH Plugin" >> "$ZSHRC"
        echo "plugins=(ah)" >> "$ZSHRC"
        echo "✅ Added plugins configuration with 'ah'"
    fi
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Type 'ah' to see all available commands"
echo "3. Try commands like: dcu, dceb web, dimages"
echo ""
echo "📚 Documentation: https://github.com/your-username/zsh-plugin-ah"
echo ""
echo "Happy coding! 🚀"
