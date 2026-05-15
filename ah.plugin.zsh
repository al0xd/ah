#!/bin/zsh

# ================================================================
# AH (Awesome Helper) Plugin for Oh-My-Zsh
# A comprehensive collection of Docker, Cloud, and utility aliases
# ================================================================

# =============
# Docker Aliases
# =============
alias dcu='docker compose up --remove-orphans'
alias dc='docker compose'
alias dce='docker compose exec'
alias dcb='docker compose build'
alias dcd='docker compose down'
alias dcrs='docker compose restart'
alias ds='docker restart'

# =============
# PNPM Aliases
# =============
alias p='pnpm'
alias pi='pnpm install'
alias pr='pnpm run'

# =============
# Cloudflare Aliases
# =============
alias clr='cloudflared tunnel --loglevel debug run'

# =============
# Fly.io Aliases
# =============
alias fssh='fly ssh console'
alias fsshc='fly ssh console --pty -C "bin/rails console"'
alias flog='fly logs'

# =============
# Docker Functions
# =============

# Execute bash in docker container
dceb() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dceb <service_name>"
    echo "   Example: dceb web"
    return 1
  fi
  echo "🐳 docker compose exec -it $1 bash"
  docker compose exec -it "$1" bash
}

# Show docker container logs with optional grep
dclog() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dclog <service_name> [-grep <pattern>]"
    echo "   Example: dclog web"
    echo "   Example: dclog web -grep ERROR"
    return 1
  fi
  
  if [[ "$2" == "-grep" && -n "$3" ]]; then
    echo "🐳 docker compose logs -f $1 | grep $3"
    docker compose logs -f "$1" | grep "$3"
  else
    echo "🐳 docker compose logs -f $1"
    docker compose logs -f "$1"
  fi
}

# Run command in new docker container
dcr() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dcr <service_name> [command]"
    echo "   Example: dcr web bash"
    echo "   Example: dcr web rails console"
    echo "   Example: dcr web npm install"
    echo "   Use --rm flag to auto-remove container after run"
    return 1
  fi
  
  local service="$1"
  shift # Remove first argument (service name)
  
  # Check if --rm flag should be used (default behavior)
  local rm_flag="--rm"
  
  if [[ $# -eq 0 ]]; then
    # No command specified, default to bash
    echo "🐳 docker compose run $rm_flag $service bash"
    docker compose run $rm_flag "$service" bash
  else
    # Command specified
    echo "🐳 docker compose run $rm_flag $service $@"
    docker compose run $rm_flag "$service" "$@"
  fi
}

# Execute command in running docker container
dex() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dex <container_name> <command>"
    echo "   Example: dex my-container bash"
    echo "   Example: dex my-container sh"
    echo "   Example: dex my-container ls -la"
    return 1
  fi
  
  if [[ -z "$2" ]]; then
    echo "❌ Usage: dex <container_name> <command>"
    echo "   Missing command parameter"
    return 1
  fi
  
  local container="$1"
  shift # Remove first argument (container name)
  
  echo "🐳 docker exec -it $container $@"
  docker exec -it "$container" "$@"
}

# Copy files between container and host
dcp() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "❌ Usage: dcp <source> <destination>"
    echo ""
    echo "📂 Copy from container to host:"
    echo "   dcp container:/path/to/file /local/path/"
    echo "   dcp container:/app/logs/ ./logs/"
    echo ""
    echo "📂 Copy from host to container:"
    echo "   dcp /local/file container:/path/to/"
    echo "   dcp ./config.json container:/app/config/"
    echo ""
    echo "💡 Tips:"
    echo "   - Use container:path for container paths"
    echo "   - Use ./path or /path for host paths"
    echo "   - Add / at end for directories"
    return 1
  fi
  
  local source="$1"
  local destination="$2"
  
  echo "📁 docker cp $source $destination"
  docker cp "$source" "$destination"
  
  if [[ $? -eq 0 ]]; then
    echo "✅ Copy completed successfully!"
  else
    echo "❌ Copy failed!"
    return 1
  fi
}

# Login to docker container with bash
dlogin() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dlogin <container_name>"
    echo "   Example: dlogin my-container"
    echo "   Example: dlogin web-app"
    echo "   Example: dlogin postgres"
    echo ""
    echo "💡 This will execute: docker exec -it <container_name> bash"
    echo "   If bash is not available, it will try sh as fallback"
    return 1
  fi
  
  local container="$1"
  
  echo "🐳 docker exec -it $container bash"
  docker exec -it "$container" bash
  
  # If bash failed, try sh as fallback
  if [[ $? -ne 0 ]]; then
    echo "⚠️  bash not available, trying sh..."
    echo "🐳 docker exec -it $container sh"
    docker exec -it "$container" sh
  fi
}

# Show all docker images
dimages() {
  echo "🖼️  docker images"
  docker images
}

# Search docker images by keyword
dsearch() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dsearch <keyword>"
    echo "   Example: dsearch nginx"
    return 1
  fi
  echo "🔍 docker images | grep $1"
  docker images | grep "$1"
}

# Remove docker images by keyword (with confirmation)
drmi() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: drmi <keyword>"
    echo "   Example: drmi nginx"
    echo "   This will remove ALL images containing the keyword"
    return 1
  fi
  
  local images=$(docker images | grep "$1" | awk '{print $3}')
  if [[ -z "$images" ]]; then
    echo "ℹ️  No images found with keyword: $1"
    return 0
  fi
  
  echo "🗑️  Images to be removed:"
  docker images | grep "$1"
  echo ""
  echo "⚠️  Are you sure you want to remove these images? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🗑️  docker rmi $(echo $images | tr '\n' ' ')"
    echo $images | xargs docker rmi
  else
    echo "❌ Operation cancelled"
  fi
}

# Remove dangling images (no tag)
drmino() {
  local dangling=$(docker images -f "dangling=true" -q)
  if [[ -z "$dangling" ]]; then
    echo "ℹ️  No dangling images found"
    return 0
  fi
  
  echo "🗑️  Dangling images to be removed:"
  docker images -f "dangling=true"
  echo ""
  echo "⚠️  Remove all dangling images? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🗑️  docker image prune -f"
    docker image prune -f
  else
    echo "❌ Operation cancelled"
  fi
}

# Remove unused images
drmiun() {
  echo "🗑️  This will remove all unused images (not referenced by any container)"
  echo "⚠️  Are you sure? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🗑️  docker image prune -a -f"
    docker image prune -a -f
  else
    echo "❌ Operation cancelled"
  fi
}

# Show running containers
dpsrun() {
  echo "🏃 docker ps"
  docker ps
}

# Remove stopped containers
drmcon() {
  local stopped=$(docker ps -a -q --filter "status=exited")
  if [[ -z "$stopped" ]]; then
    echo "ℹ️  No stopped containers found"
    return 0
  fi
  
  echo "🗑️  Stopped containers to be removed:"
  docker ps -a --filter "status=exited"
  echo ""
  echo "⚠️  Remove all stopped containers? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🗑️  docker container prune -f"
    docker container prune -f
  else
    echo "❌ Operation cancelled"
  fi
}

# Remove containers by keyword
drmkey() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: drmkey <keyword>"
    echo "   Example: drmkey nginx"
    echo "   This will remove ALL containers containing the keyword"
    return 1
  fi
  
  local containers=$(docker ps -a | grep "$1" | awk '{print $1}')
  if [[ -z "$containers" ]]; then
    echo "ℹ️  No containers found with keyword: $1"
    return 0
  fi
  
  echo "🗑️  Containers to be removed:"
  docker ps -a | grep "$1"
  echo ""
  echo "⚠️  Are you sure you want to remove these containers? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🗑️  docker rm -f $(echo $containers | tr '\n' ' ')"
    echo $containers | xargs docker rm -f
  else
    echo "❌ Operation cancelled"
  fi
}

# =============
# Help Command
# =============
ah-help() {
  echo ""
  echo "🚀 AH (Awesome Helper) Plugin - Command Reference"
  echo "================================================"
  echo ""
  echo "📦 DOCKER ALIASES:"
  echo "  dcu     - docker compose up --remove-orphans"
  echo "  dc      - docker compose"
  echo "  dce     - docker compose exec"
  echo "  dcb     - docker compose build"
  echo "  dcd     - docker compose down"
  echo "  dcrs    - docker compose restart"
  echo "  ds      - docker restart"
  echo "  dps     - show running containers (alias for dpsrun)"
  echo ""
  echo "📘 PNPM ALIASES:"
  echo "  p       - pnpm"
  echo "  pi      - pnpm install"
  echo "  pr      - pnpm run"
  echo ""
  echo "🐳 DOCKER FUNCTIONS:"
  echo "  dceb <service>                    - Execute bash in container"
  echo "  dclog <service> [-grep <pattern>] - Show container logs"
  echo "  dcr <service> [command]           - Run command in new container"
  echo "  dex <container> <command>          - Execute command in running container"
  echo "  dcp <source> <destination>        - Copy files between container and host"
  echo "  dlogin <container>                - Login to container with bash"
  echo ""
  echo "🖼️  IMAGE MANAGEMENT:"
  echo "  dimages                           - Show all docker images"
  echo "  dsearch <keyword>                 - Search images by keyword"
  echo "  drmi <keyword>                    - Remove images by keyword"
  echo "  drmino                            - Remove dangling images"
  echo "  drmiun                            - Remove unused images"
  echo ""
  echo "📋 CONTAINER MANAGEMENT:"
  echo "  dpsrun                            - Show running containers"
  echo "  drmcon                            - Remove stopped containers"
  echo "  drmkey <keyword>                  - Remove containers by keyword"
  echo ""
  echo "☁️  CLOUDFLARE ALIASES:"
  echo "  clr     - cloudflared tunnel --loglevel debug run"
  echo ""
  echo "✈️  FLY.IO ALIASES:"
  echo "  fssh    - fly ssh console"
  echo "  fsshc   - fly ssh console --pty -C 'bin/rails console'"
  echo "  flog    - fly logs"
  echo ""
  echo "🔧 PLUGIN MANAGEMENT:"
  echo "  ah-update                         - Update plugin to latest version"
  echo "  ah-version                        - Show plugin version"
  echo "  ahu                               - Alias for ah-update"
  echo ""
  echo "🔁 AUTO-UPDATE (when plugin loads):"
  echo "  Set AH_AUTO_UPDATE=0 to disable."
  echo "  AH_AUTO_UPDATE_INTERVAL (seconds, default 86400) — min time between checks."
  echo ""
  echo "💡 Usage Examples:"
  echo "  dceb web                          # Enter web container bash"
  echo "  dclog api -grep ERROR             # Show API logs filtered by ERROR"
  echo "  dcr worker rails console          # Run Rails console in worker container"
  echo "  dex my-container bash             # Execute bash in running container"
  echo "  dcp web:/app/logs/ ./logs/        # Copy logs from container to host"
  echo "  dcp ./config.json web:/app/       # Copy config from host to container"
  echo "  dlogin my-container               # Login to container with bash"
  echo "  p add axios                       # Install package using pnpm"
  echo "  pi                                # Install dependencies"
  echo "  pr dev                            # Run pnpm script 'dev'"
  echo "  dsearch postgres                  # Search for postgres images"
  echo "  drmi <none>                       # Remove untagged images"
  echo "  ah-update                         # Update plugin to latest version"
  echo ""
  echo "For more help, visit: https://github.com/al0xd/ah"
}

# =============
# Plugin Aliases
# =============

# Main help command
alias ah='ah-help'

# Additional convenience aliases
alias dps='dpsrun'
alias ahu='ah-update'

# Absolute path to this plugin's directory (for git / auto-update)
_ah-plugin-root() {
  print -r -- "${${(%):-%x}:A:h}"
}

# Optional auto-sync with origin when the plugin is sourced.
# AH_AUTO_UPDATE=0 disables. AH_AUTO_UPDATE_INTERVAL is seconds between checks (default 86400).
_ah-auto-update-on-load() {
  (( ${AH_AUTO_UPDATE:-1} )) || return 0

  local plugin_dir
  plugin_dir="$(_ah-plugin-root)"
  [[ -d "$plugin_dir/.git" ]] || return 0

  if [[ -n "$(git -C "$plugin_dir" status --porcelain 2>/dev/null)" ]]; then
    return 0
  fi

  local branch
  branch=$(git -C "$plugin_dir" branch --show-current 2>/dev/null) || return 0
  [[ -n "$branch" ]] || return 0

  local interval="${AH_AUTO_UPDATE_INTERVAL:-86400}"
  local stamp="$plugin_dir/.ah-auto-update-stamp"
  local now
  now=$(date +%s) || return 0
  if [[ -f "$stamp" ]]; then
    local last=0
    read last <"$stamp" 2>/dev/null || last=0
    [[ "$last" != <-> ]] && last=0
    (( now - last < interval )) && return 0
  fi

  if ! git -C "$plugin_dir" fetch -q origin 2>/dev/null; then
    return 0
  fi

  local local_commit remote_commit
  local_commit=$(git -C "$plugin_dir" rev-parse HEAD 2>/dev/null) || return 0
  remote_commit=$(git -C "$plugin_dir" rev-parse "origin/$branch" 2>/dev/null) || return 0

  if [[ "$local_commit" == "$remote_commit" ]]; then
    print -r -- "$now" >"$stamp" 2>/dev/null || true
    return 0
  fi

  if ! git -C "$plugin_dir" pull -q origin "$branch" 2>/dev/null; then
    return 0
  fi

  print -r -- "$now" >"$stamp" 2>/dev/null || true
  echo "🔄 AH plugin auto-updated. Reloading..."
  unset AH_PLUGIN_LOADED
  source "$plugin_dir/ah.plugin.zsh"
  return 2
}

# Plugin version
ah-version() {
  echo "AH Plugin v1.0.0"
  echo "https://github.com/al0xd/ah"
}

# Update plugin to latest version
ah-update() {
  echo "🔄 Updating AH Plugin..."
  
  local plugin_dir
  plugin_dir="$(_ah-plugin-root)"
  
  # Change to plugin directory
  cd "$plugin_dir"
  
  # Check if it's a git repository
  if [[ ! -d .git ]]; then
    echo "❌ Plugin directory is not a git repository"
    echo "   Please reinstall the plugin from: https://github.com/al0xd/ah"
    return 1
  fi
  
  # Get current branch
  local current_branch=$(git branch --show-current)
  
  # Fetch latest changes
  echo "📡 Fetching latest changes..."
  git fetch origin
  
  # Check if there are updates
  local local_commit=$(git rev-parse HEAD)
  local remote_commit=$(git rev-parse "origin/$current_branch")
  
  if [[ "$local_commit" == "$remote_commit" ]]; then
    echo "✅ Plugin is already up to date!"
    return 0
  fi
  
  # Pull latest changes
  echo "⬇️  Pulling latest changes..."
  if git pull origin "$current_branch"; then
    echo "✅ Plugin updated successfully!"
    echo "🔄 Reloading plugin..."
    
    # Reload the plugin
    unset AH_PLUGIN_LOADED
    source "$plugin_dir/ah.plugin.zsh"
    
    echo "🎉 Plugin reloaded! Type 'ah' for help."
  else
    echo "❌ Failed to update plugin"
    echo "   Please check for conflicts or update manually"
    return 1
  fi
}

# Print welcome message when plugin loads (auto-update is throttled; see ah-help)
if [[ -z "$AH_PLUGIN_LOADED" ]]; then
  _ah-auto-update-on-load
  local _ah_au=$?
  if (( _ah_au == 2 )); then
    return 0
  fi
  export AH_PLUGIN_LOADED=1
  echo "🚀 AH Plugin loaded! Type 'ah' for help."
fi
