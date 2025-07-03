#!/bin/bash

# Live test script - installs and tests the plugin in Oh-My-Zsh
# Use this to test the plugin in a real Oh-My-Zsh environment

echo "🧪 AH Plugin Live Test"
echo "======================"
echo ""

# Check if Oh-My-Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "❌ Oh-My-Zsh not found. Please install it first."
    exit 1
fi

# Set plugin directory
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ah-test"

echo "📁 Installing test plugin to: $PLUGIN_DIR"

# Create test plugin directory
mkdir -p "$PLUGIN_DIR"

# Copy plugin file
cp "$(dirname "$0")/ah.plugin.zsh" "$PLUGIN_DIR/"

echo "✅ Test plugin installed!"
echo ""

# Create a test script to run in a new zsh session
cat > /tmp/ah-test.zsh << 'EOF'
#!/bin/zsh

# Load Oh-My-Zsh with test plugin
export ZSH="$HOME/.oh-my-zsh"
plugins=(ah-test)
source $ZSH/oh-my-zsh.sh

echo "🧪 Testing AH Plugin in Oh-My-Zsh environment..."
echo ""

# Test help command
echo "📖 Testing help command:"
ah

echo ""
echo "🏷️ Testing aliases:"
echo "dc: $(alias dc 2>/dev/null || echo 'not found')"
echo "dcu: $(alias dcu 2>/dev/null || echo 'not found')"
echo "fssh: $(alias fssh 2>/dev/null || echo 'not found')"

echo ""
echo "🔧 Testing functions:"
if type dceb >/dev/null 2>&1; then
    echo "✅ dceb function is defined"
    echo "Testing dceb (should show usage):"
    dceb
else
    echo "❌ dceb function not found"
fi

echo ""
echo "🎯 Testing ah-version:"
if type ah-version >/dev/null 2>&1; then
    ah-version
else
    echo "❌ ah-version function not found"
fi

echo ""
echo "✅ Live test completed!"
EOF

# Run the test in a new zsh session
echo "🚀 Running live test..."
echo ""
zsh /tmp/ah-test.zsh

# Cleanup
echo ""
echo "🧹 Cleaning up test files..."
rm -rf "$PLUGIN_DIR"
rm -f /tmp/ah-test.zsh

echo "✅ Live test finished!"
echo ""
echo "💡 To install permanently:"
echo "   ./install.sh"
