#!/bin/bash

# Direct git commands for AH Plugin setup
cd /projects/zsh-plugin-ah

# Initialize and setup git
git init
git checkout -b main
git remote add origin git@github.com:al0xd/ah.git
git config commit.gpgsign true

# Stage and commit
chmod +x *.sh
git add .
git commit -S -m "feat: initial release of AH plugin v1.0.0

- Add comprehensive Docker & Docker Compose aliases
- Add container management functions with safety confirmations  
- Add image cleanup utilities
- Add Cloudflare tunnel and Fly.io integrations
- Add interactive help system with emoji indicators
- Include complete documentation and installation guides
- Add CI/CD workflows and testing infrastructure
- Add Makefile for development convenience"

# Show status
git status
git log --oneline -1
git remote -v

echo "✅ Repository ready! Create https://github.com/al0xd/ah then: git push -u origin main"
