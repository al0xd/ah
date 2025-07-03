#!/bin/bash

# Initial commit script for AH Plugin
echo "📝 Creating initial commit for al0xd/ah..."

cd /projects/zsh-plugin-ah

# Make setup script executable and run it
chmod +x git-setup.sh
./git-setup.sh

# Make all shell scripts executable
chmod +x *.sh

# Add all files to git
echo "📋 Staging all files..."
git add .

# Create initial commit
echo "💾 Creating initial commit..."
git commit -S -m "feat: initial release of AH plugin v1.0.0

- Add comprehensive Docker & Docker Compose aliases
- Add container management functions with safety confirmations
- Add image cleanup utilities
- Add Cloudflare tunnel and Fly.io integrations
- Add interactive help system with emoji indicators
- Include complete documentation and installation guides
- Add CI/CD workflows and testing infrastructure
- Add Makefile for development convenience"

# Show git status
echo "📊 Git status after commit:"
git status

# Show commit log
echo "📝 Commit log:"
git log --oneline -3

echo ""
echo "🎉 Initial commit created successfully!"
echo "📋 Next steps:"
echo "  1. Create repository on GitHub: https://github.com/al0xd/ah"
echo "  2. Push to GitHub: git push -u origin main"
echo "  3. Create release: git tag v1.0.0 && git push origin v1.0.0"
echo ""
echo "🔗 Repository URL: $(git remote get-url origin)"
