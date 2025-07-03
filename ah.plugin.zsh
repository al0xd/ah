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
  echo "  dps     - show running containers (alias for dpsrun)"
  echo ""
  echo "🐳 DOCKER FUNCTIONS:"
  echo "  dceb <service>                    - Execute bash in container"
  echo "  dclog <service> [-grep <pattern>] - Show container logs"
  echo "  dcr <service> [command]           - Run command in new container"
  echo "  dex <container> <command>          - Execute command in running container"
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
  echo "💡 Usage Examples:"
  echo "  dceb web                          # Enter web container bash"
  echo "  dclog api -grep ERROR             # Show API logs filtered by ERROR"
  echo "  dcr worker rails console          # Run Rails console in worker container"
  echo "  dsearch postgres                  # Search for postgres images"
  echo "  drmi <none>                       # Remove untagged images"
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

# Plugin version
ah-version() {
  echo "AH Plugin v1.0.0"
  echo "https://github.com/al0xd/ah"
}

# Print welcome message when plugin loads
if [[ -z "$AH_PLUGIN_LOADED" ]]; then
  export AH_PLUGIN_LOADED=1
  echo "🚀 AH Plugin loaded! Type 'ah' for help."
fi
