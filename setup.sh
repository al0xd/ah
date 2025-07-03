#!/bin/bash

# Setup script to make all files executable and ready for use

echo "🔧 Setting up AH Plugin..."
echo "=========================="

# Make scripts executable
chmod +x *.sh
echo "✅ Made shell scripts executable"

# Make Makefile available
if [ -f Makefile ]; then
    echo "✅ Makefile ready"
fi

# Check if plugin file exists and is readable
if [ -f ah.plugin.zsh ]; then
    echo "✅ Plugin file ready"
else
    echo "❌ Plugin file not found!"
    exit 1
fi

echo ""
echo "📋 Available commands:"
echo "  make help        - Show all available commands"
echo "  make install     - Install plugin to Oh-My-Zsh"
echo "  make test        - Test plugin functionality"
echo "  make demo        - Show plugin demo"
echo "  ./install.sh     - Quick install script"
echo ""
echo "🎉 Setup completed! Plugin is ready to use."
