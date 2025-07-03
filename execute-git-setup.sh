#!/bin/bash

# Execute git setup for AH Plugin with SSH remote
echo "🔧 Setting up Git repository for al0xd/ah with SSH remote..."

cd /projects/zsh-plugin-ah

# Initialize git repository
echo "📝 Initializing Git repository..."
git init

# Set default branch to main
echo "🌿 Setting default branch to main..."
git checkout -b main

# Add remote origin with SSH
echo "🔗 Adding SSH remote origin..."
git remote add origin git@github.com:al0xd/ah.git

# Set up git config for signed commits
echo "⚙️ Configuring Git for signed commits..."
git config commit.gpgsign true

# Make all shell scripts executable
echo "🔧 Making scripts executable..."
chmod +x *.sh

# Add all files to git
echo "📋 Staging all files..."
git add .

# Create initial commit with signed flag
echo "💾 Creating signed initial commit..."
git commit -S -m "feat: initial release of AH plugin v1.0.0

- Add comprehensive Docker & Docker Compose aliases (dcu, dc, dce, dcb, dcd, dcrs)
- Add interactive container functions (dceb, dclog, dcr)
- Add image management utilities (dimages, dsearch, drmi, drmino, drmiun)
- Add container cleanup functions (dpsrun, drmcon, drmkey)
- Add Cloudflare tunnel alias (clr)
- Add Fly.io integrations (fssh, fsshc, flog)
- Add interactive help system with emoji indicators (ah command)
- Include safety confirmations for destructive operations
- Add complete documentation suite (README, INSTALL, CONTRIBUTING, SECURITY)
- Add CI/CD workflows for GitHub Actions
- Add development utilities (Makefile, test scripts, demo)
- Add GitHub templates for issues and PRs"

# Show git status and log
echo ""
echo "📊 Git status:"
git status

echo ""
echo "📝 Recent commits:"
git log --oneline -3

echo ""
echo "🔗 Remote configuration:"
git remote -v

echo ""
echo "✅ Git repository setup completed successfully!"
echo ""
echo "📋 Ready for GitHub! Next steps:"
echo "  1. Create repository at: https://github.com/al0xd/ah"
echo "  2. Push: git push -u origin main"
echo "  3. Create release: git tag v1.0.0 && git push origin v1.0.0"
echo ""
echo "🎯 Installation command for users:"
echo "  git clone git@github.com:al0xd/ah.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah"
