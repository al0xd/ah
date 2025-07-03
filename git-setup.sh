#!/bin/bash

# Git setup script for AH Plugin
echo "🔧 Setting up Git repository for al0xd/ah..."

cd /projects/zsh-plugin-ah

# Initialize git repository
echo "📝 Initializing Git repository..."
git init

# Set default branch to main
echo "🌿 Setting default branch to main..."
git branch -m main

# Add remote origin
echo "🔗 Adding remote origin..."
git remote add origin https://github.com/al0xd/ah.git

# Set up git config for signed commits
echo "⚙️ Configuring Git..."
git config user.name "al0xd"
git config user.email "your-email@example.com"
git config commit.gpgsign true

echo "✅ Git repository setup completed!"
echo "📋 Remote URL: $(git remote get-url origin)"
