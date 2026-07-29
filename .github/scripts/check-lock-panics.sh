#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

if ! command -v rg >/dev/null 2>&1; then
  echo "ERROR: ripgrep (rg) is required to run lock-panic checks."
  exit 1
fi

collect_repo_roots() {
  local -n _repos="$1"
  _repos=("$ROOT")

  # Include peer workspaces declared in .meta.yaml when they exist.
  while IFS= read -r entry; do
    if [ -z "$entry" ]; then
      continue
    fi

    local slug path
    slug="$(printf '%s' "$entry" | awk '{print $1}')"
    path="$(printf '%s' "$entry" | awk '{print $2}')"

    if [ -z "$slug" ]; then
      continue
    fi

    local candidate_path="$ROOT/$slug"
    if [ -n "$path" ]; then
      candidate_path="$ROOT/$path"
    fi

    _repos+=("$candidate_path")
  done < <(
  awk '
      /^projects:/ { in_projects=1; next }
      in_projects {
        if ($0 ~ /^[[:space:]]{2}[A-Za-z0-9_-]+:$/) {
          if (key != "" && path == "") {
            print key
          }
          key=substr($0,3,length($0)-3)
          path=""
          print key
          next
        }
        if ($0 ~ /^[[:space:]]+path:[[:space:]]+/) {
          sub(/^[[:space:]]+path:[[:space:]]*/, "", $0)
          print key " " $0
          key=""
          path=""
          next
        }
        if (key != "" && $0 ~ /^[^[:space:]]/) {
          print key
          key=""
        }
      }
      END {
        if (key != "" && path == "") {
          print key
        }
      }
    ' "$ROOT/.meta.yaml" | sort -u
  )

  # Deduplicate and filter to existing, valid git worktrees.
  local -A seen
  local unique=()
  for path in "${_repos[@]}"; do
    if [ -z "${seen["$path"]+x}" ]; then
      seen["$path"]=1
      if [ -d "$path" ] \
          && [ "$(git -C "$path" rev-parse --is-inside-work-tree 2>/dev/null || echo false)" = "true" ] \
          && [ "$(git -C "$path" rev-parse --is-bare-repository 2>/dev/null || echo false)" != "true" ]; then
        unique+=("$path")
      fi
    fi
  done
  _repos=("${unique[@]}")
}

scan_repo_for_panics() {
  local repo_path="$1"
  local file
  while IFS= read -r -d '' file; do
    if [ -f "$repo_path/$file" ]; then
      rg -n -H -U -P '(\.(lock|read|write|try_lock|try_read|try_write)\(\)\s*\.\s*(?:unwrap|expect)\()' "$repo_path/$file" || true
    fi
  done < <(git -C "$repo_path" ls-files -z -- '*.rs' 2>/dev/null)
}

echo "Checking for lock/read/write/try_lock/try_read/try_write panic handlers..."
REPO_ROOTS=()
if [ "${META_CHECK_PEER_REPOS:-0}" = "1" ]; then
  collect_repo_roots REPO_ROOTS
else
  REPO_ROOTS=("$ROOT")
fi

matches=""
for repo in "${REPO_ROOTS[@]}"; do
  if ! (cd "$repo" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    continue
  fi

  repo_matches="$(scan_repo_for_panics "$repo")"
  if [ -n "$repo_matches" ]; then
    if [ -n "$matches" ]; then
      matches+=$'\n'
    fi
    matches+="$repo_matches"
  fi
done

if [ -n "$matches" ]; then
  echo "ERROR: found lock/read/write/try_lock/try_read/try_write calls using unwrap/expect:"
  echo "$matches"
  exit 1
fi

echo "No lock/read/write/try_lock/try_read/try_write unwrap/expect patterns found."
exit 0
