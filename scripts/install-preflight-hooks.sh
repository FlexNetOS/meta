#!/usr/bin/env bash
# install-preflight-hooks.sh — install the meta-managed pre-push preflight gate
# into every Rust repo in the workspace, so no push can enter a state that blocks
# its own GitHub auto-merge (the silent-`Format`-failure trap).
#
# Idempotent + re-runnable. Wired into scripts/bootstrap.sh (phase 6) so fresh
# clones get it automatically. Safe by design:
#   - only touches repos with a top-level Cargo.toml (the ones with CI gates),
#   - installs where git actually looks (honors an existing core.hooksPath),
#   - refuses to overwrite a pre-push hook it didn't write (prints a warning),
#   - the hook itself never hard-fails a push when no gate is resolvable.
#
# Usage:  bash scripts/install-preflight-hooks.sh [--dry-run] [--list]
set -euo pipefail

META_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFLIGHT="$META_ROOT/scripts/preflight.sh"
TEMPLATE="$META_ROOT/scripts/git-hooks/pre-push"
MARKER="meta-managed preflight gate"   # identifies hooks we own (safe to overwrite)
DRY_RUN=0; LIST_ONLY=0

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --list)    LIST_ONLY=1 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

[ -f "$PREFLIGHT" ] || { echo "FATAL: $PREFLIGHT missing" >&2; exit 1; }
[ -f "$TEMPLATE" ]  || { echo "FATAL: $TEMPLATE missing" >&2; exit 1; }
chmod +x "$PREFLIGHT" "$TEMPLATE" 2>/dev/null || true

# Enumerate workspace repos from .meta.yaml (fall back to directory scan).
repos() {
  if command -v python3 >/dev/null 2>&1 && [ -f "$META_ROOT/.meta.yaml" ]; then
    python3 -c "import yaml,sys; d=yaml.safe_load(open('$META_ROOT/.meta.yaml')); [print(n) for n in d.get('projects',{})]" 2>/dev/null
  else
    find "$META_ROOT" -maxdepth 2 -name Cargo.toml -printf '%h\n' | sed "s#$META_ROOT/##" | sort -u
  fi
}

installed=0; skipped=0; warned=0
for repo in $(repos); do
  root="$META_ROOT/$repo"
  [ -f "$root/Cargo.toml" ] || { continue; }                       # Rust repos only
  git -C "$root" rev-parse --git-dir >/dev/null 2>&1 || { continue; } # real git repo

  if [ "$LIST_ONLY" = 1 ]; then echo "rust-repo: $repo"; installed=$((installed+1)); continue; fi

  # Install where git actually looks: honor an existing core.hooksPath, else .git/hooks.
  hp="$(git -C "$root" config core.hooksPath 2>/dev/null || true)"
  if [ -n "$hp" ]; then
    case "$hp" in /*) hooks_dir="$hp" ;; *) hooks_dir="$root/$hp" ;; esac
  else
    hooks_dir="$(git -C "$root" rev-parse --git-path hooks 2>/dev/null)"
    case "$hooks_dir" in /*) : ;; *) hooks_dir="$root/$hooks_dir" ;; esac
  fi
  target="$hooks_dir/pre-push"

  # Don't clobber a foreign pre-push (one we didn't write).
  if [ -f "$target" ] && ! grep -q "$MARKER" "$target" 2>/dev/null; then
    echo "WARN: $repo has a pre-existing pre-push hook ($target) — leaving it. Merge by hand." >&2
    warned=$((warned+1)); continue
  fi

  if [ "$DRY_RUN" = 1 ]; then
    echo "DRY: install $target -> $PREFLIGHT"
    installed=$((installed+1)); continue
  fi

  mkdir -p "$hooks_dir"
  sed "s#@PREFLIGHT@#$PREFLIGHT#" "$TEMPLATE" > "$target"
  chmod +x "$target"
  echo "ok: $repo -> $target"
  installed=$((installed+1))
done

echo ""
echo "preflight hooks: $installed installed, $warned pre-existing left alone."
[ "$LIST_ONLY" = 1 ] && echo "(--list mode: counted Rust repos, installed nothing)"
exit 0
