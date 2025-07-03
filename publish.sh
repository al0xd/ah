#!/bin/bash

# GitHub publishing script for AH Plugin
# This script helps prepare and publish the plugin to GitHub

echo "📦 AH Plugin GitHub Publisher"
echo "============================="
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "🔧 Initializing Git repository..."
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository found"
fi

# Check if remote origin exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo ""
    echo "🔗 Setting up GitHub remote..."
    echo "Please enter your GitHub repository URL:"
    echo "Example: https://github.com/username/zsh-plugin-ah.git"
    read -r repo_url
    
    if [ -n "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo "✅ Remote origin added: $repo_url"
    else
        echo "❌ No repository URL provided. Please set it manually:"
        echo "   git remote add origin <your-repo-url>"
        exit 1
    fi
else
    echo "✅ Remote origin already configured: $(git remote get-url origin)"
fi

echo ""
echo "📋 Preparing files for publication..."

# Make scripts executable
chmod +x install.sh demo.sh test.sh live-test.sh

# Check if all required files exist
required_files=(
    "ah.plugin.zsh"
    "README.md"
    "LICENSE"
    "CHANGELOG.md"
    "CONTRIBUTING.md"
    "SECURITY.md"
    "INSTALL.md"
    ".gitignore"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo "❌ Missing required files:"
    printf '   %s\n' "${missing_files[@]}"
    echo ""
    echo "Please ensure all files are present before publishing."
    exit 1
fi

echo "✅ All required files present"

# Stage all files
echo ""
echo "📝 Staging files for commit..."
git add .

# Check git status
echo ""
echo "📊 Git status:"
git status --short

# Commit if there are changes
if git diff --cached --quiet; then
    echo ""
    echo "ℹ️  No changes to commit"
else
    echo ""
    echo "💾 Creating commit..."
    echo "Enter commit message (or press Enter for default):"
    read -r commit_message
    
    if [ -z "$commit_message" ]; then
        commit_message="feat: initial release of AH plugin v1.0.0"
    fi
    
    git commit -S -m "$commit_message"
    echo "✅ Commit created: $commit_message"
fi

# Create tags
echo ""
echo "🏷️  Creating release tag..."
if git tag | grep -q "v1.0.0"; then
    echo "ℹ️  Tag v1.0.0 already exists"
else
    git tag -a v1.0.0 -m "Initial release v1.0.0"
    echo "✅ Tag v1.0.0 created"
fi

# Push to GitHub
echo ""
echo "🚀 Publishing to GitHub..."
echo "This will push the code and tags to GitHub. Continue? (y/N)"
read -r confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "📤 Pushing to origin..."
    git push -u origin main
    
    echo "📤 Pushing tags..."
    git push origin --tags
    
    echo ""
    echo "🎉 Successfully published to GitHub!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Visit your GitHub repository"
    echo "2. Create a release from the v1.0.0 tag"
    echo "3. Add release notes and description"
    echo "4. Share your plugin with the community!"
    echo ""
    echo "📚 Installation command for users:"
    echo "git clone $(git remote get-url origin) \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah"
    
else
    echo "❌ Publishing cancelled"
    echo ""
    echo "💡 To publish manually:"
    echo "   git push -u origin main"
    echo "   git push origin --tags"
fi

echo ""
echo "🔗 Repository URL: $(git remote get-url origin)"
echo ""
echo "Happy coding! 🚀"
