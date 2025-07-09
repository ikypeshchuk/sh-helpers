#!/usr/bin/env bash
#
# docker-nuke.sh — небезпечний скрипт для повного очищення Docker-середовища
# Використання:
#   ./docker-nuke.sh        # запитає підтвердження
#   ./docker-nuke.sh -y     # знищить усе без запитань
#
# Потрібні залежності: docker CLI в $PATH

set -euo pipefail

# ────────────────────────── функції ──────────────────────────
confirm() {
  if [[ "${1:-}" == "-y" ]]; then
    return            # опція -y → без запитань
  fi
  read -rp $'⚠️  Це назавжди видалить ВСІ контейнери, образи, томи й мережі Docker!\nПродовжити? [y/N] ' ans
  [[ "$ans" =~ ^([yY]|yes|YES)$ ]] || { echo "Скасовано."; exit 0; }
}

run_safe() {
  local cmd="$1"
  # xargs -r → не виконує команду, якщо вхід порожній
  eval "$cmd" || true # не валитися, якщо нічого не знайдено
}

# ────────────────────────── виконання ──────────────────────────
confirm "${1:-}"

echo "⏹  Зупинка та видалення контейнерів..."
run_safe 'docker ps -aq | xargs -r docker rm -f'

echo "🗑  Видалення образів..."
run_safe 'docker images -q | xargs -r docker rmi -f'

echo "🧹  Видалення томів..."
run_safe 'docker volume ls -q | xargs -r docker volume rm -f'

echo "🌐  Видалення кастомних мереж..."
run_safe 'docker network ls -q --filter type=custom | xargs -r docker network rm'

echo "🚿  Завершальне очищення (docker system prune)..."
docker system prune -af --volumes

echo "✅  Docker-середовище повністю очищено."

