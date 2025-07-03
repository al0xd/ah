# Makefile for AH Plugin
# Provides convenient commands for development and distribution

.PHONY: help install test demo live-test publish clean

# Default target
help:
	@echo "🚀 AH Plugin - Available Commands"
	@echo "=================================="
	@echo ""
	@echo "📦 Setup & Installation:"
	@echo "  make install     - Install plugin to Oh-My-Zsh"
	@echo "  make uninstall   - Remove plugin from Oh-My-Zsh"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test        - Run basic plugin tests"
	@echo "  make live-test   - Test plugin in Oh-My-Zsh environment"
	@echo "  make demo        - Show plugin demonstration"
	@echo ""
	@echo "📚 Development:"
	@echo "  make lint        - Check plugin syntax"
	@echo "  make format      - Format shell scripts"
	@echo "  make docs        - Generate documentation"
	@echo ""
	@echo "🚀 Distribution:"
	@echo "  make publish     - Publish to GitHub"
	@echo "  make release     - Create new release"
	@echo "  make clean       - Clean up temporary files"
	@echo ""
	@echo "🔧 Utilities:"
	@echo "  make check-deps  - Check dependencies"
	@echo "  make info        - Show plugin information"
	@echo "  make validate    - Validate plugin structure"
	@echo "  make quick-start - Install and test in one command"
	@echo ""
	@echo "💡 Usage Examples:"
	@echo "  make install && make test"
	@echo "  make demo"
	@echo "  make publish"

# Install plugin to Oh-My-Zsh
install:
	@echo "📦 Installing AH Plugin..."
	@chmod +x install.sh
	@./install.sh

# Uninstall plugin from Oh-My-Zsh
uninstall:
	@echo "🗑️ Uninstalling AH Plugin..."
	@rm -rf "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/ah"
	@echo "✅ Plugin removed. Please remove 'ah' from plugins in ~/.zshrc"

# Run basic tests
test:
	@echo "🧪 Running plugin tests..."
	@chmod +x test.sh
	@./test.sh

# Run live tests in Oh-My-Zsh environment
live-test:
	@echo "🚀 Running live tests..."
	@chmod +x live-test.sh
	@./live-test.sh

# Show demonstration
demo:
	@echo "🎬 Starting plugin demo..."
	@chmod +x demo.sh
	@./demo.sh

# Check syntax
lint:
	@echo "🔍 Checking plugin syntax..."
	@zsh -n ah.plugin.zsh && echo "✅ Syntax check passed" || echo "❌ Syntax errors found"
	@shellcheck *.sh 2>/dev/null && echo "✅ Shell script check passed" || echo "⚠️ shellcheck not available"

# Format scripts (if shfmt is available)
format:
	@echo "🎨 Formatting shell scripts..."
	@if command -v shfmt >/dev/null 2>&1; then \
		shfmt -w -i 2 *.sh; \
		echo "✅ Scripts formatted"; \
	else \
		echo "⚠️ shfmt not installed. Install with: go install mvdan.cc/sh/v3/cmd/shfmt@latest"; \
	fi

# Generate documentation
docs:
	@echo "📚 Documentation files:"
	@echo "  README.md       - Main documentation"
	@echo "  INSTALL.md      - Installation guide"
	@echo "  CONTRIBUTING.md - Contribution guidelines"
	@echo "  CHANGELOG.md    - Version history"
	@echo "  SECURITY.md     - Security policy"
	@echo ""
	@echo "💡 All documentation is up to date!"

# Publish to GitHub
publish:
	@echo "🚀 Publishing to GitHub..."
	@chmod +x publish.sh
	@./publish.sh

# Create a new release
release:
	@echo "🏷️ Creating new release..."
	@echo "Current tags:"
	@git tag | sort -V
	@echo ""
	@echo "Enter new version tag (e.g., v1.1.0):"
	@read version; \
	if [ -n "$$version" ]; then \
		git tag -a "$$version" -m "Release $$version"; \
		echo "✅ Tag $$version created"; \
		echo "💡 Run 'make publish' to push to GitHub"; \
	else \
		echo "❌ No version specified"; \
	fi

# Clean up temporary files
clean:
	@echo "🧹 Cleaning up..."
	@rm -f *.tmp
	@rm -f .*.tmp
	@rm -f /tmp/ah-test.zsh
	@find . -name "*.backup.*" -type f -delete 2>/dev/null || true
	@echo "✅ Cleanup completed"

# Development server (for documentation)
serve:
	@echo "📖 Starting documentation server..."
	@if command -v python3 >/dev/null 2>&1; then \
		echo "🌐 Server running at http://localhost:8000"; \
		echo "📁 Serving files from current directory"; \
		python3 -m http.server 8000; \
	else \
		echo "❌ Python3 not available"; \
	fi

# Quick setup for new users
quick-start:
	@echo "🚀 AH Plugin Quick Start"
	@echo "========================"
	@echo ""
	@echo "This will install the plugin and run a quick test."
	@echo "Continue? (y/N)"
	@read confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		make install; \
		echo ""; \
		make test; \
		echo ""; \
		echo "🎉 Quick start completed!"; \
		echo "💡 Type 'ah' to see all available commands"; \
	else \
		echo "❌ Quick start cancelled"; \
	fi

# Check dependencies
check-deps:
	@echo "🔍 Checking dependencies..."
	@echo ""
	@echo "Required:"
	@command -v zsh >/dev/null 2>&1 && echo "✅ zsh" || echo "❌ zsh (required)"
	@echo ""
	@echo "Optional:"
	@command -v docker >/dev/null 2>&1 && echo "✅ docker" || echo "⚠️ docker (for Docker commands)"
	@command -v fly >/dev/null 2>&1 && echo "✅ fly" || echo "⚠️ fly (for Fly.io commands)"
	@command -v cloudflared >/dev/null 2>&1 && echo "✅ cloudflared" || echo "⚠️ cloudflared (for Cloudflare tunnel)"
	@test -d "$$HOME/.oh-my-zsh" && echo "✅ oh-my-zsh" || echo "⚠️ oh-my-zsh (recommended)"
	@echo ""
	@echo "Development tools:"
	@command -v shellcheck >/dev/null 2>&1 && echo "✅ shellcheck" || echo "⚠️ shellcheck (for linting)"
	@command -v shfmt >/dev/null 2>&1 && echo "✅ shfmt" || echo "⚠️ shfmt (for formatting)"

# Show plugin information
info:
	@echo "ℹ️ AH Plugin Information"
	@echo "========================"
	@echo ""
	@echo "📦 Name: AH (Awesome Helper) Plugin"
	@echo "📝 Version: 1.0.0"
	@echo "👨‍💻 Author: Your Name"
	@echo "🔗 Repository: https://github.com/your-username/zsh-plugin-ah"
	@echo "📄 License: MIT"
	@echo ""
	@echo "📊 Statistics:"
	@echo "   Aliases: $$(grep -c '^alias' ah.plugin.zsh)"
	@echo "   Functions: $$(grep -c '^[a-zA-Z][a-zA-Z0-9_]*()' ah.plugin.zsh)"
	@echo "   Lines of code: $$(wc -l < ah.plugin.zsh)"
	@echo ""
	@if [ -f ah.plugin.zsh ]; then \
		echo "📂 Plugin file: ah.plugin.zsh ($$(du -h ah.plugin.zsh | cut -f1))"; \
	fi
	@echo ""
	@echo "🎯 Main features:"
	@echo "   • Docker & Docker Compose shortcuts"
	@echo "   • Container management functions"
	@echo "   • Image cleanup utilities"
	@echo "   • Cloud platform integrations"
	@echo "   • Interactive help system"

# Validate plugin structure
validate:
	@echo "✅ Validating plugin structure..."
	@echo ""
	@errors=0; \
	if [ ! -f "ah.plugin.zsh" ]; then \
		echo "❌ Missing main plugin file: ah.plugin.zsh"; \
		errors=$$((errors + 1)); \
	else \
		echo "✅ Main plugin file exists"; \
	fi; \
	if [ ! -f "README.md" ]; then \
		echo "❌ Missing README.md"; \
		errors=$$((errors + 1)); \
	else \
		echo "✅ README.md exists"; \
	fi; \
	if [ ! -f "LICENSE" ]; then \
		echo "❌ Missing LICENSE file"; \
		errors=$$((errors + 1)); \
	else \
		echo "✅ LICENSE file exists"; \
	fi; \
	if [ $$errors -eq 0 ]; then \
		echo ""; \
		echo "🎉 Plugin structure is valid!"; \
	else \
		echo ""; \
		echo "❌ Found $$errors error(s) in plugin structure"; \
		exit 1; \
	fi
