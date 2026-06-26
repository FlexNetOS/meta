#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$repo_root"

fail() {
  echo "VIOLATION: $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "$path" ] || fail "required file missing: $path"
}

require_grep() {
  local pattern="$1"
  local path="$2"
  local label="$3"
  grep -Eq "$pattern" "$path" || fail "$label missing in $path"
}

require_file .codex/config.toml
require_file .codex/hooks.json
require_file .codex/prompts/kb-note.md
require_file .agents/skills/gitkb/SKILL.md
require_file .kb/.gitignore

require_grep '^\[mcp_servers\.gitkb\]' .codex/config.toml 'Codex gitkb MCP server stanza'
require_grep 'command[[:space:]]*=[[:space:]]*"git"' .codex/config.toml 'Codex gitkb MCP command'
require_grep 'args[[:space:]]*=[[:space:]]*\[[[:space:]]*"kb"[[:space:]]*,[[:space:]]*"mcp"[[:space:]]*\]' .codex/config.toml 'Codex gitkb MCP args'

require_grep 'git kb service' .codex/hooks.json 'Codex git-kb service hook'
require_grep 'service[[:space:]]+(start|serve)' .codex/hooks.json 'Codex git-kb service start hook'

require_grep 'git kb create note' .codex/prompts/kb-note.md 'Codex note prompt create-note command'
require_grep 'notes/' .codex/prompts/kb-note.md 'Codex note prompt notes namespace'
require_grep 'git kb commit' .codex/prompts/kb-note.md 'Codex note prompt KB commit step'
require_grep '\.kb/store' .codex/prompts/kb-note.md 'Codex note prompt durable store check'

require_grep 'git kb create note' .agents/skills/gitkb/SKILL.md 'agent gitkb skill note command'
require_grep 'notes/<slug>|notes/' .agents/skills/gitkb/SKILL.md 'agent gitkb skill notes namespace'
require_grep 'kb-note' .agents/skills/gitkb/SKILL.md 'agent gitkb skill Codex prompt reference'

if git check-ignore -q .kb/store/documents 2>/dev/null || git check-ignore -q .kb/store 2>/dev/null; then
  fail '.kb/store is ignored; durable git-kb text store must be trackable'
fi

echo 'ok: Codex git-kb note wiring is complete'
