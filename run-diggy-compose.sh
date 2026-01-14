#!/usr/bin/env bash
set -Eeuo pipefail

# Run and manage the services defined in diggy-docker-compose.yml
# Usage examples:
#   ./run-diggy-compose.sh            # default: up -d
#   ./run-diggy-compose.sh up --build
#   ./run-diggy-compose.sh down
#   ./run-diggy-compose.sh restart
#   ./run-diggy-compose.sh logs
#   ./run-diggy-compose.sh ps

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

COMPOSE_FILE="${COMPOSE_FILE:-diggy-docker-compose.yml}"

if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "Error: compose file '$COMPOSE_FILE' not found in: $SCRIPT_DIR" >&2
  exit 1
fi

# Prefer Docker Compose v2 ("docker compose"), fall back to v1 ("docker-compose")
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose -f "$COMPOSE_FILE")
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose -f "$COMPOSE_FILE")
else
  echo "Error: neither 'docker compose' nor 'docker-compose' found. Please install Docker (with Compose) first." >&2
  exit 1
fi

print_usage() {
  cat >&2 <<EOF
Usage: $0 {up|down|restart|logs|ps|pull|build} [-- additional args]

Commands:
  up [--build]     Start services in background (default)
  down             Stop and remove services
  restart          Recreate services (down + up -d)
  logs             Follow logs of all services
  ps               Show service status
  pull             Pull images
  build            Build images

Environment:
  COMPOSE_FILE     Override compose file (default: diggy-docker-compose.yml)
  .env             If present, Compose will auto-load environment variables
EOF
}

CMD="${1:-up}"
shift || true

case "$CMD" in
  up)
    "${COMPOSE_CMD[@]}" up -d "$@"
    ;;
  down)
    "${COMPOSE_CMD[@]}" down "$@"
    ;;
  restart)
    "${COMPOSE_CMD[@]}" down
    "${COMPOSE_CMD[@]}" up -d "$@"
    ;;
  logs)
    "${COMPOSE_CMD[@]}" logs -f "$@"
    ;;
  ps)
    "${COMPOSE_CMD[@]}" ps "$@"
    ;;
  pull)
    "${COMPOSE_CMD[@]}" pull "$@"
    ;;
  build)
    "${COMPOSE_CMD[@]}" build "$@"
    ;;
  -h|--help|help)
    print_usage
    ;;
  *)
    echo "Unknown command: $CMD" >&2
    print_usage
    exit 2
    ;;
esac

