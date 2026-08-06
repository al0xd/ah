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

# Search running containers by keyword (name, image, ports, status, ...)
dpsearch() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dpsearch <keyword>"
    echo "   Example: dpsearch nginx"
    echo "   Example: dpsearch 5432"
    return 1
  fi

  local header results
  header=$(docker ps | head -n 1)
  results=$(docker ps | tail -n +2 | grep -- "$1")
  if [[ -z "$results" ]]; then
    echo "ℹ️  No running containers found with keyword: $1"
    return 0
  fi

  echo "🔍 Searching running containers for: $1"
  print -r -- "$header"
  print -r -- "$results"
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

# Stop containers by keyword (shows names before stopping)
dstopkey() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dstopkey <keyword>"
    echo "   Example: dstopkey nginx"
    echo "   This will stop ALL running containers whose name contains the keyword"
    return 1
  fi

  local -a names
  names=(${(f)"$(docker ps --format '{{.Names}}' | grep -- "$1")"})
  if [[ ${#names[@]} -eq 0 ]]; then
    echo "ℹ️  No running containers found with keyword: $1"
    return 0
  fi

  echo "🛑 Containers to be stopped:"
  printf '  - %s\n' "${names[@]}"
  echo ""
  docker ps --filter "name=$1"
  echo ""
  echo "⚠️  Stop these containers? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🛑 docker stop ${names[*]}"
    docker stop "${names[@]}"
  else
    echo "❌ Operation cancelled"
  fi
}

# Remove containers by keyword (shows names before removing)
drmkey() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: drmkey <keyword>"
    echo "   Example: drmkey nginx"
    echo "   This will remove ALL containers whose name contains the keyword"
    return 1
  fi

  local -a names
  names=(${(f)"$(docker ps -a --format '{{.Names}}' | grep -- "$1")"})
  if [[ ${#names[@]} -eq 0 ]]; then
    echo "ℹ️  No containers found with keyword: $1"
    return 0
  fi

  echo "🗑️  Containers to be removed:"
  printf '  - %s\n' "${names[@]}"
  echo ""
  docker ps -a --filter "name=$1"
  echo ""
  echo "⚠️  Are you sure you want to remove these containers? (y/N)"
  read confirmation
  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    echo "🗑️  docker rm -f ${names[*]}"
    docker rm -f "${names[@]}"
  else
    echo "❌ Operation cancelled"
  fi
}

# =============
# Command Catalog (for semantic search)
# Format: name|usage|maps_to|description|keywords
#
# ⚠️  MANDATORY: every new alias/function/command MUST be added here
#     (and to _AH_SYNONYMS if it introduces a new concept).
#     Also update ah-help, README, and test.sh.
#     `ah search` only knows what is listed in this catalog.
# =============
typeset -ga _AH_CMD_CATALOG
_AH_CMD_CATALOG=(
  'dcu|dcu|docker compose up --remove-orphans|Start compose stack (remove orphans)|up start run launch compose orphan'
  'dc|dc|docker compose|Docker compose shorthand|compose docker'
  'dce|dce <service> [cmd]|docker compose exec|Exec into a compose service|exec enter shell compose'
  'dcb|dcb|docker compose build|Build compose images|build compile image compose'
  'dcd|dcd|docker compose down|Stop and remove compose stack|down stop remove compose teardown'
  'dcrs|dcrs|docker compose restart|Restart compose services|restart reboot stop start compose'
  'ds|ds <container>|docker restart|Restart a docker container|restart reboot stop start container'
  'dps|dps|docker ps|Show running containers|ps list running status container process'
  'dpsrun|dpsrun|docker ps|Show running containers|ps list running status container process'
  'dpsearch|dpsearch <keyword>|docker ps grep|Search running containers by keyword|search find ps running container filter grep keyword name image port'
  'p|p|pnpm|pnpm shorthand|pnpm node package npm'
  'pi|pi|pnpm install|Install pnpm dependencies|pnpm install deps dependency node'
  'pr|pr <script>|pnpm run|Run a pnpm script|pnpm run script node'
  'dceb|dceb <service>|docker compose exec -it <service> bash|Bash into compose service|bash shell exec enter login compose'
  'dclog|dclog <service> [-grep <pattern>]|docker compose logs -f|Follow compose service logs|log logs tail follow grep compose'
  'dcr|dcr <service> [command]|docker compose run --rm|Run one-off command in new container|run one-off ephemeral compose'
  'dex|dex <container> <command>|docker exec -it|Exec command in running container|exec run command shell container'
  'dcp|dcp <src> <dst>|docker cp|Copy files between host and container|copy cp file transfer container host'
  'dlogin|dlogin <container>|docker exec -it <container> bash|Login to container (bash/sh)|login bash shell enter ssh container'
  'dimages|dimages|docker images|List all docker images|image images list show'
  'dsearch|dsearch <keyword>|docker images grep|Search docker images by keyword|search find image filter grep'
  'drmi|drmi <keyword>|docker rmi|Remove images by keyword|remove delete rmi image clean'
  'drmino|drmino|docker image prune -f|Remove dangling/untagged images|remove prune dangling none untagged image'
  'drmiun|drmiun|docker image prune -a -f|Remove unused images|remove prune unused image clean'
  'drmcon|drmcon|docker container prune -f|Remove stopped containers|remove prune stopped exited container clean'
  'dstopkey|dstopkey <keyword>|docker stop|Stop running containers by name keyword|stop halt kill terminate shutdown container keyword name'
  'drmkey|drmkey <keyword>|docker rm -f|Remove containers by name keyword|remove delete rm destroy container keyword name force'
  'clr|clr|cloudflared tunnel run|Run Cloudflare tunnel|cloudflare tunnel cloudflared'
  'fssh|fssh|fly ssh console|SSH into Fly.io app|fly ssh console remote'
  'fsshc|fsshc|fly ssh console --pty -C bin/rails console|Rails console on Fly.io|fly rails console ssh'
  'flog|flog|fly logs|Tail Fly.io logs|fly logs tail'
  'ah|ah help / ah search / ah version / ah update|ah dispatcher|AH plugin entrypoint|help search version update plugin'
  'ah-search|ah search <keyword>|semantic command search|Search AH commands by keyword|search find semantic help discover suggest'
  'ah-update|ah update / ahu|git pull plugin|Update AH plugin to latest|update upgrade pull sync plugin'
  'ahu|ahu|ah-update|Alias for ah-update|update upgrade plugin'
  'ah-version|ah version|show plugin version|Show AH plugin version|version info about'
  'ah-help|ah / ah help|show command reference|Show full AH help|help docs manual reference'
)

# Synonym groups — expand query for semantic matching
typeset -gA _AH_SYNONYMS
typeset -ga _AH_QTERMS
_AH_SYNONYMS=(
  stop 'stop halt kill terminate shutdown pause down exit exited'
  start 'start up run launch boot'
  restart 'restart reboot reload recycle'
  remove 'remove rm delete destroy prune clean erase drop'
  delete 'delete remove rm destroy prune clean'
  list 'list show ps ls display status'
  show 'show list display ls status'
  log 'log logs logging tail follow'
  image 'image images img'
  container 'container containers box service'
  exec 'exec execute run shell enter'
  bash 'bash sh shell login enter'
  copy 'copy cp transfer file'
  build 'build compile make'
  install 'install deps dependency add'
  search 'search find lookup discover grep filter'
  update 'update upgrade pull sync reload'
  help 'help docs manual reference usage'
  compose 'compose docker-compose stack'
  fly 'fly flyio fly.io'
  cloudflare 'cloudflare cloudflared tunnel'
  pnpm 'pnpm npm node package'
)

# Expand a query token into related terms (self + synonym group)
_ah-expand-query() {
  local q="${1:l}"
  local -a terms
  terms=("$q")

  local key group
  for key group in ${(kv)_AH_SYNONYMS}; do
    if [[ "$q" == "$key" || " $group " == *" $q "* ]]; then
      terms+=(${=group})
      terms+=("$key")
    fi
  done

  print -l -- ${(u)terms}
}

# Score how well a catalog entry matches expanded query terms.
# Reads global _AH_QTERMS; writes score to stdout.
_ah-score-entry() {
  local name="$1" usage="$2" maps_to="$3" desc="$4" keywords="$5"
  local name_l="${name:l}" usage_l="${usage:l}" maps_l="${maps_to:l}"
  local desc_l="${desc:l}" keys_l="${keywords:l}"
  local score=0
  local term t

  for term in "${_AH_QTERMS[@]}"; do
    [[ -z "$term" ]] && continue
    t="${term:l}"

    # Exact command name
    if [[ "$name_l" == "$t" ]]; then
      (( score += 100 ))
      continue
    fi

    # Keyword / tag exact token
    if [[ " $keys_l " == *" $t "* ]]; then
      (( score += 35 ))
    fi

    # Underlying docker/cli: whole-word-ish (space-padded)
    if [[ " $maps_l " == *" $t "* || "$maps_l" == "$t"* || "$maps_l" == *" $t" ]]; then
      (( score += 40 ))
    fi

    # Name contains term — only for longer tokens (avoid log⊂dlogin)
    if (( ${#t} >= 4 )) && [[ "$name_l" == *"$t"* ]]; then
      (( score += 55 ))
    fi

    # Description / usage — whole word for short terms
    if (( ${#t} < 4 )); then
      if [[ " $desc_l " == *" $t "* || " $usage_l " == *" $t "* ]]; then
        (( score += 15 ))
      fi
    else
      if [[ "$desc_l" == *"$t"* || "$usage_l" == *"$t"* ]]; then
        (( score += 15 ))
      fi
    fi
  done

  print -r -- "$score"
}

# Semantic search across AH commands
# Usage: ah-search <keyword>
#        ah search "stop"
ah-search() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: ah search <keyword>"
    echo "   Example: ah search stop"
    echo "   Example: ah search \"remove image\""
    echo "   Example: ah search logs"
    return 1
  fi

  local query="$*"
  local -a raw_tokens expanded
  raw_tokens=(${(s: :)query:l})
  # strip surrounding quotes if user passed them literally
  raw_tokens=("${(@)raw_tokens//[\"\']/}")

  local tok
  _AH_QTERMS=()
  for tok in "${raw_tokens[@]}"; do
    [[ -z "$tok" ]] && continue
    expanded=(${(f)"$(_ah-expand-query "$tok")"})
    _AH_QTERMS+=("${expanded[@]}")
  done
  _AH_QTERMS=(${(u)_AH_QTERMS})

  echo ""
  echo "🔍 AH search: \"$query\""
  echo "═══════════════════════════════════════"
  if (( ${#_AH_QTERMS[@]} > 1 )); then
    echo "   related terms: ${_AH_QTERMS[*]}"
    echo ""
  fi

  local -a scored
  local entry name usage maps_to desc keywords score rest

  for entry in "${_AH_CMD_CATALOG[@]}"; do
    name="${entry%%|*}"
    rest="${entry#*|}"
    usage="${rest%%|*}"
    rest="${rest#*|}"
    maps_to="${rest%%|*}"
    rest="${rest#*|}"
    desc="${rest%%|*}"
    keywords="${rest#*|}"

    score=$(_ah-score-entry "$name" "$usage" "$maps_to" "$desc" "$keywords")
    (( score > 0 )) || continue
    # Zero-pad score so string sort (On) ranks numerically
    scored+=("$(printf '%04d' "$score")|${name}|${usage}|${maps_to}|${desc}")
  done

  if (( ${#scored[@]} == 0 )); then
    echo "ℹ️  No commands matched \"$query\""
    echo "💡 Try: ah search docker | ah search remove | ah search help"
    echo "   Or:  ah help"
    return 0
  fi

  # Sort by score descending
  scored=(${(On)scored})

  local line shown=0
  local max_results="${AH_SEARCH_LIMIT:-12}"
  for line in "${scored[@]}"; do
    (( shown >= max_results )) && break
    score="${line%%|*}"
    # strip leading zeros for display (optional — we don't show score by default)
    rest="${line#*|}"
    name="${rest%%|*}"
    rest="${rest#*|}"
    usage="${rest%%|*}"
    rest="${rest#*|}"
    maps_to="${rest%%|*}"
    desc="${rest#*|}"

    echo ""
    printf '  \033[1m%s\033[0m\n' "$usage"
    echo "    $desc"
    echo "    → $maps_to"
    (( shown++ ))
  done

  echo ""
  echo "───────────────────────────────────────"
  echo "✅ Found $shown related command(s). Run with the name above, or: ah help"
  echo ""
}

# =============
# Help Command
# =============
ah-help() {
  echo ""
  echo "🚀 AH (Awesome Helper) Plugin - Command Reference"
  echo "================================================"
  echo ""
  echo "🔎 QUICK SEARCH:"
  echo "  ah search <keyword>               - Semantic search AH commands"
  echo "  ah s stop                         - Shortcut for ah search"
  echo "  Example: ah search \"stop\""
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
  echo "  dpsearch <keyword>                - Search running containers by keyword"
  echo "  drmcon                            - Remove stopped containers"
  echo "  dstopkey <keyword>                - Stop containers by keyword"
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
  echo "  ah help                           - Show this help"
  echo "  ah search <keyword>               - Search commands by meaning"
  echo "  ah-update / ah update / ahu       - Update plugin to latest version"
  echo "  ah-version / ah version           - Show plugin version"
  echo ""
  echo "🔁 AUTO-UPDATE (when plugin loads):"
  echo "  Set AH_AUTO_UPDATE=0 to disable."
  echo "  AH_AUTO_UPDATE_INTERVAL (seconds, default 86400) — min time between checks."
  echo ""
  echo "💡 Usage Examples:"
  echo "  ah search stop                    # Find stop-related commands"
  echo "  ah search \"remove image\"         # Find image cleanup commands"
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
  echo "  dpsearch nginx                    # Search running containers for nginx"
  echo "  drmi <none>                       # Remove untagged images"
  echo "  ah-update                         # Update plugin to latest version"
  echo ""
  echo "For more help, visit: https://github.com/al0xd/ah"
}

# Main entry: ah | ah help | ah search <kw> | ah version | ah update
# unalias first — older plugin / personal aliases.zsh may have left `alias ah`
unalias ah 2>/dev/null
ah() {
  local cmd="${1:-help}"
  case "$cmd" in
    help|h|-h|--help)
      ah-help
      ;;
    search|s|find|f)
      shift
      ah-search "$@"
      ;;
    version|v|--version)
      ah-version
      ;;
    update|u)
      ah-update
      ;;
    *)
      echo "❌ Unknown: ah $cmd"
      echo "   Usage: ah [help|search|version|update]"
      echo "   Tip:   ah search $cmd"
      return 1
      ;;
  esac
}

# =============
# Plugin Aliases
# =============

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
