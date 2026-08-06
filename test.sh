#!/bin/bash

# Test script for AH Plugin
# This script tests the basic functionality of the plugin

echo "🧪 Testing AH Plugin..."
echo "=========================="

# Source the plugin
source "$(dirname "$0")/ah.plugin.zsh"

echo ""
echo "✅ Plugin loaded successfully!"
echo ""

# Test help command
echo "📖 Testing help command:"
echo "------------------------"
ah-help

echo ""
echo "🔍 Testing function definitions:"
echo "--------------------------------"

# Check if functions are defined
functions_to_test=(
    "dceb"
    "dclog" 
    "dcr"
    "dimages"
    "dsearch"
    "drmi"
    "drmino"
    "drmiun"
    "dpsrun"
    "drmcon"
    "dstopkey"
    "drmkey"
    "ah"
    "ah-help"
    "ah-search"
    "ah-version"
)

for func in "${functions_to_test[@]}"; do
    if type "$func" >/dev/null 2>&1; then
        echo "✅ $func - defined"
    else
        echo "❌ $func - missing"
    fi
done

echo ""
echo "🏷️ Testing aliases:"
echo "------------------"

# Check if aliases are defined
aliases_to_test=(
    "dcu"
    "dc"
    "dce"
    "dcb"
    "dcd"
    "dcrs"
    "ds"
    "clr"
    "fssh"
    "fsshc"
    "flog"
    "dps"
    "ahu"
)

for alias_name in "${aliases_to_test[@]}"; do
    if alias "$alias_name" >/dev/null 2>&1; then
        echo "✅ $alias_name - $(alias "$alias_name")"
    else
        echo "❌ $alias_name - not found"
    fi
done

echo ""
echo "🔎 Testing ah search:"
echo "--------------------"
ah search stop
if [ $? -eq 0 ]; then
    echo "✅ ah search works"
else
    echo "❌ ah search failed"
fi

echo ""
echo "🎯 Testing error handling:"
echo "-------------------------"

# Test functions with no arguments (should show usage)
echo "Testing dceb with no arguments:"
dceb 2>/dev/null
if [ $? -eq 1 ]; then
    echo "✅ dceb error handling works"
else
    echo "❌ dceb error handling failed"
fi

echo ""
echo "Testing dclog with no arguments:"
dclog 2>/dev/null
if [ $? -eq 1 ]; then
    echo "✅ dclog error handling works"
else
    echo "❌ dclog error handling failed"
fi

echo ""
echo "🎉 Test completed!"
echo ""
echo "💡 To test manually:"
echo "   1. Add plugin to Oh-My-Zsh: plugins=(... ah)"
echo "   2. Restart terminal or run: source ~/.zshrc"
echo "   3. Run: ah"
echo "   4. Try commands like: dcu, dceb web, etc."
