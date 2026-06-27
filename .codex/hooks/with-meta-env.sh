#!/usr/bin/env bash
set -euo pipefail

find_meta_root() {
  local start="${META_ROOT:-${PWD}}"
  if [ -f "$start" ]; then
    start="$(dirname "$start")"
  fi
  local dir
  dir="$(cd "$start" 2>/dev/null && pwd -P)" || return 1
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.meta.yaml" ] || [ -f "$dir/.meta.yml" ] || [ -f "$dir/.meta" ]; then
      printf '%s\n' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

META_ROOT="$(find_meta_root)"
export META_ROOT
export META_FILE=""
for candidate in "$META_ROOT/.meta.yaml" "$META_ROOT/.meta.yml" "$META_ROOT/.meta"; do
  if [ -f "$candidate" ]; then
    META_FILE="$candidate"
    break
  fi
done
export META_FILE
export CODEX_HOME="${CODEX_HOME:-$META_ROOT/.local/share/codex}"
export CODEX_SQLITE_HOME="${CODEX_SQLITE_HOME:-$META_ROOT/.local/state/codex}"
# Codex must resolve to the Rust CLI, never the legacy Bun-installed JS shim.
export CODEX_BIN_PATH="${CODEX_BIN_PATH:-$META_ROOT/.toolchains/openai-codex/current/bin/codex}"
export CODEX_CLI_BIN="$CODEX_BIN_PATH"
# Keep meta shims first.  The Bun tool-bin directory remains available for non-Codex
# tools such as gemini/vite, but the old @openai/codex Bun package is not on this path.
export PATH="$META_ROOT/usr/bin:$META_ROOT/.local/bin:$META_ROOT/.toolchains/cargo/bin:$META_ROOT/.toolchains/.bun/bin:$PATH"
umask 077
mkdir -p "$CODEX_HOME" "$CODEX_SQLITE_HOME"

exec "$@"
