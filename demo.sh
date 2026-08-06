#!/bin/bash

# Demo script for AH Plugin
# This script demonstrates the key features of the plugin

echo "🚀 AH Plugin Demo"
echo "================="
echo ""

echo "Welcome to the AH (Awesome Helper) Plugin demonstration!"
echo "This plugin provides powerful aliases and functions for Docker, Cloud platforms, and more."
echo ""

# Source the plugin
source "$(dirname "$0")/ah.plugin.zsh"

echo "📖 Main Help Command:"
echo "--------------------"
echo "Type 'ah' to see all available commands:"
echo ""
ah
echo ""

echo "🐳 Docker Aliases Demo:"
echo "----------------------"
echo "# Basic Docker Compose commands:"
echo "dcu    # docker compose up --remove-orphans"
echo "dcb    # docker compose build"
echo "dcd    # docker compose down"
echo "dcrs   # docker compose restart"
echo ""

echo "🔧 Docker Functions Demo:"
echo "------------------------"
echo "# Interactive container access:"
echo "dceb web                    # Enter web container with bash"
echo "dcr worker rails console    # Run Rails console in worker container"
echo "dclog api -grep ERROR       # Show API logs filtered by ERROR"
echo ""

echo "🖼️  Image Management Demo:"
echo "-------------------------"
echo "dimages                     # List all Docker images"
echo "dsearch postgres           # Search for postgres images"
echo "drmi <none>                # Remove untagged images (with confirmation)"
echo "drmino                     # Remove dangling images"
echo ""

echo "📋 Container Management Demo:"
echo "----------------------------"
echo "dps                        # Show running containers"
echo "drmcon                     # Remove stopped containers"
echo "dstopkey nginx            # Stop containers with 'nginx' in name"
echo "drmkey nginx              # Remove containers with 'nginx' in name"
echo ""

echo "☁️  Cloud Platform Aliases:"
echo "---------------------------"
echo "# Cloudflare:"
echo "clr                        # cloudflared tunnel --loglevel debug run"
echo ""
echo "# Fly.io:"
echo "fssh                       # fly ssh console"
echo "fsshc                      # fly ssh console with Rails console"
echo "flog                       # fly logs"
echo ""

echo "🛡️  Safety Features:"
echo "-------------------"
echo "✅ All destructive operations require confirmation"
echo "✅ Clear error messages with emoji indicators"
echo "✅ Usage examples for all functions"
echo "✅ Comprehensive help system"
echo ""

echo "🎯 Installation:"
echo "---------------"
echo "git clone https://github.com/your-username/zsh-plugin-ah.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah"
echo ""
echo "Add 'ah' to your plugins in ~/.zshrc:"
echo "plugins=(git docker ... ah)"
echo ""
echo "Then run: source ~/.zshrc"
echo ""

echo "🎉 Try it now!"
echo "Type 'ah' to see the help, or try any of the commands above."
echo ""
echo "Happy coding! 🚀"
