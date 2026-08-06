# Contributing to AH Plugin

Thank you for your interest in contributing to the AH Plugin! This document provides guidelines and instructions for contributing.

## 🤝 How to Contribute

### Reporting Issues

1. Check existing [issues](https://github.com/your-username/zsh-plugin-ah/issues) first
2. Create a new issue with:
   - Clear title and description
   - Steps to reproduce (if it's a bug)
   - Expected vs actual behavior
   - Your environment details (OS, Zsh version, Oh-My-Zsh version)

### Suggesting Features

1. Open an issue with the `enhancement` label
2. Describe the feature and its use case
3. Explain why it would be beneficial

### Code Contributions

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes following our coding standards
4. Test your changes thoroughly
5. Commit with conventional commit messages
6. Push to your fork and submit a Pull Request

## 📝 Coding Standards

### Adding a new command (REQUIRED checklist)
Khi thêm alias/function mới, **phải** làm đủ:

1. Implement trong `ah.plugin.zsh`
2. **Thêm entry vào `_AH_CMD_CATALOG`** (để `ah search` tìm được)
3. Bổ sung `_AH_SYNONYMS` nếu cần khái niệm mới
4. Cập nhật `ah-help`
5. Cập nhật `README.md` + `test.sh`

Format catalog: `name|usage|maps_to|description|keywords`

### Naming Conventions
- Use descriptive function names
- Prefix all functions with relevant namespace (e.g., `dc` for docker-compose)
- Use snake_case for internal variables
- Use kebab-case for file names

### Function Structure
```bash
# Function description
function_name() {
  # Validate inputs
  if [[ -z "$1" ]]; then
    echo "❌ Usage: function_name <param>"
    return 1
  fi
  
  # Main logic
  echo "🔄 Executing command..."
  
  # Error handling
  if ! command; then
    echo "❌ Command failed"
    return 1
  fi
}
```

### Documentation
- Add comments for complex logic
- Include usage examples in function help
- Update README.md for new features
- Add emoji indicators for better UX

## 🧪 Testing

Before submitting:
1. Test all new functions manually
2. Ensure no existing functionality is broken
3. Test on different environments if possible
4. Verify help messages are accurate

## 📋 Pull Request Checklist

- [ ] Code follows project conventions
- [ ] Functions include proper error handling
- [ ] Help messages are clear and helpful
- [ ] README.md updated if needed
- [ ] CHANGELOG.md updated
- [ ] Commits follow conventional commit format

## 🎯 Conventional Commits

Use these prefixes:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code formatting
- `refactor:` - Code restructuring
- `test:` - Testing changes
- `chore:` - Maintenance tasks

Example: `feat: add kubernetes aliases for pod management`

## 🏷️ Versioning

We follow [Semantic Versioning](https://semver.org/):
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes (backward compatible)

## 📞 Getting Help

- Open an issue for questions
- Check existing documentation
- Look at similar functions for patterns

Thank you for contributing! 🎉
