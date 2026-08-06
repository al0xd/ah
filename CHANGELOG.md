# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-07-03

### Added
- Initial release of AH (Awesome Helper) plugin
- Docker Compose aliases (dcu, dc, dce, dcb, dcd, dcrs)
- Docker interactive functions (dceb, dclog, dcr)
- Docker image management functions (dimages, dsearch, drmi, drmino, drmiun)
- Docker container management functions (dpsrun, drmcon, drmkey)
- Cloudflare tunnel alias (clr)
- Fly.io aliases (fssh, fsshc, flog)
- Comprehensive help system with `ah` command
- Safety confirmations for destructive operations
- Emoji indicators for better UX
- Complete documentation and installation guides

### Features
- 🐳 Docker workflow optimization
- ☁️ Cloud platform integration
- 📖 Self-documenting help system
- 🛡️ Safe operations with confirmations
- 🎨 User-friendly interface with emojis

## [Unreleased]

### Added
- `dstopkey <keyword>` — stop running containers by name keyword (lists names + confirm)
- `drmkey` now lists container names explicitly before remove
- `ah search <keyword>` — semantic search across AH commands (synonyms + ranked suggestions)
- `ah` is now a dispatcher: `ah help|search|version|update` (shortcuts: `s`, `v`, `u`)

### Planned
- Git workflow aliases
- Kubernetes support
- AWS CLI shortcuts
- Additional cloud platform integrations
- Performance optimizations
