# AH (Awesome Helper) Plugin

An Oh-My-Zsh plugin that provides a comprehensive collection of Docker, Cloud, and utility aliases to boost your productivity in the terminal.

## 🚀 Features

### 📦 Docker Aliases
- **dcu** - `docker compose up --remove-orphans`
- **dc** - `docker compose`
- **dce** - `docker compose exec`
- **dcb** - `docker compose build`
- **dcd** - `docker compose down`
- **dcrs** - `docker compose restart`
- **dps** - Show running containers

### 🐳 Docker Functions
- **dceb** `<service>` - Execute bash in container
- **dclog** `<service>` `[-grep <pattern>]` - Show container logs with optional filtering
- **dcr** `<service>` `[command]` - Run command in new container

### 🖼️ Image Management
- **dimages** - Show all docker images
- **dsearch** `<keyword>` - Search images by keyword
- **drmi** `<keyword>` - Remove images by keyword (with confirmation)
- **drmino** - Remove dangling images
- **drmiun** - Remove unused images

### 📋 Container Management
- **dpsrun** - Show running containers
- **drmcon** - Remove stopped containers
- **drmkey** `<keyword>` - Remove containers by keyword

### ☁️ Cloudflare
- **clr** - `cloudflared tunnel --loglevel debug run`

### ✈️ Fly.io
- **fssh** - `fly ssh console`
- **fsshc** - `fly ssh console --pty -C "bin/rails console"`
- **flog** - `fly logs`

## 📚 Usage Examples

```bash
# Docker container operations
dceb web                    # Enter web container bash
dclog api -grep ERROR       # Show API logs filtered by ERROR
dcr worker rails console    # Run Rails console in worker container

# Image management
dsearch postgres           # Search for postgres images
drmi <none>               # Remove untagged images
drmino                    # Clean up dangling images

# Container cleanup
drmcon                    # Remove all stopped containers
drmkey nginx              # Remove containers with 'nginx' in name
```

## 🛠️ Installation

### Method 1: Oh-My-Zsh Plugin (Recommended)

1. Clone this repository into your Oh-My-Zsh custom plugins directory:
```bash
git clone https://github.com/al0xd/ah.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ah
```

2. Add the plugin to your `.zshrc` file:
```bash
plugins=(... ah)
```

3. Restart your terminal or run:
```bash
source ~/.zshrc
```

### Method 2: Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/al0xd/ah.git
```

2. Source the plugin in your `.zshrc`:
```bash
source /path/to/zsh-plugin-ah/ah.plugin.zsh
```

### Method 3: Antigen

Add this line to your `.zshrc`:
```bash
antigen bundle al0xd/ah
```

### Method 4: Zinit

Add this line to your `.zshrc`:
```bash
zinit load al0xd/ah
```

## 🎯 Quick Start

After installation, type `ah` in your terminal to see the complete command reference:

```bash
ah
```

This will display all available commands with descriptions and usage examples.

## 🔧 Requirements

- **Zsh** 4.3.9+ (5.0.8+ recommended)
- **Oh-My-Zsh** (optional but recommended)
- **Docker** and **Docker Compose** (for Docker-related functions)
- **Cloudflared** (for Cloudflare tunnel aliases)
- **Fly CLI** (for Fly.io aliases)

## 🌟 Key Benefits

- **⚡ Productivity Boost**: Reduce typing with smart aliases
- **🛡️ Safety First**: Confirmation prompts for destructive operations
- **📖 Self-Documenting**: Built-in help system with `ah` command
- **🎨 User-Friendly**: Emoji indicators and clear error messages
- **🔄 Consistent**: Follows Oh-My-Zsh plugin conventions

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/awesome-feature`)
3. Commit your changes (`git commit -m 'feat: add awesome feature'`)
4. Push to the branch (`git push origin feature/awesome-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh-My-Zsh](https://ohmyz.sh/) community for the amazing framework
- Docker community for making containerization accessible
- All contributors who help improve this plugin

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/your-username/zsh-plugin-ah/issues) page
2. Create a new issue if your problem isn't already reported
3. Provide as much detail as possible about your environment and the issue

## 🎉 Star This Repository

If this plugin helps you, please consider giving it a ⭐ on GitHub!

---

**Made with ❤️ for the developer community**
