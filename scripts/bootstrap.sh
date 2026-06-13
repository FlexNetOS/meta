#!/usr/bin/env bash
# bootstrap.sh — materialize the full FlexNetOS environment from a meta clone (ADR-0006).
#
# Thin sequencer over the real engines:
#   envctl  = OS/toolchain/box layer (TOML components, idempotent, content-locked)
#   kasetto = agent layer (skills/MCP baseline)
#   meta    = repo/workspace layer
#
# Usage:  git clone git@github.com:FlexNetOS/meta.git ~/Desktop/meta
#         cd ~/Desktop/meta && bash scripts/bootstrap.sh [--phase N] [--dry-run]
#
# Idempotent: every phase converges; re-running is safe. Sudo phases are flagged and
# skippable. Collisions are archived by the envctl link components, never overwritten.
set -euo pipefail

META_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0
ONLY_PHASE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --phase) ONLY_PHASE="$2"; shift ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

say()  { printf '\n=== [bootstrap] %s ===\n' "$*"; }
run()  { if [ "$DRY_RUN" = 1 ]; then echo "DRY: $*"; else "$@"; fi; }
phase(){ [ -z "$ONLY_PHASE" ] || [ "$ONLY_PHASE" = "$1" ]; }

# ---- phase 0: rust toolchain ------------------------------------------------------
if phase 0; then
  say "phase 0: rustup + stable toolchain"
  if ! command -v cargo >/dev/null 2>&1; then
    run bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable"
    # shellcheck disable=SC1091
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  fi
  cargo --version
fi

# ---- phase 1: clone the fleet -----------------------------------------------------
if phase 1; then
  say "phase 1: meta CLI + child repos"
  if ! command -v meta >/dev/null 2>&1; then
    say "building meta from the workspace (first run)"
    run cargo build --release -p meta
    export PATH="$META_ROOT/target/release:$PATH"
  fi
  run meta git update            # clones every .meta.yaml project incl. nested meta repos
fi

# ---- phase 2: build the tool crates -----------------------------------------------
if phase 2; then
  say "phase 2: release builds (workspace + standalone tool repos)"
  run cargo build --release      # root workspace: meta*, loop, rtk, teri, shimmy, ...
  for repo in envctl vox icm kasetto grit lane weave meta_dashboard_cli; do
    if [ -f "$META_ROOT/$repo/Cargo.toml" ]; then
      say "build: $repo"
      run cargo build --release --manifest-path "$META_ROOT/$repo/Cargo.toml" || \
        echo "WARN: $repo build failed — fix and re-run (bootstrap continues)"
    fi
  done
fi

# ---- phase 3: box materialization (envctl) -----------------------------------------
if phase 3; then
  say "phase 3: envctl install (OS/toolchain components + portability links)"
  ENVCTL="$META_ROOT/envctl/target/release/envctl"
  [ -x "$ENVCTL" ] || ENVCTL="envctl"
  ( cd "$META_ROOT/envctl" && run "$ENVCTL" auto-detect )
  # NOTE: some components need sudo (nix install, /usr/local/bin, update-alternatives).
  ( cd "$META_ROOT/envctl" && run "$ENVCTL" install ) || \
    echo "WARN: envctl install reported failures — run 'envctl doctor' and re-run"
fi

# ---- phase 4: agent layer (kasetto) ------------------------------------------------
if phase 4; then
  say "phase 4: kasetto sync --locked (agent skills + MCP baseline)"
  if command -v kasetto >/dev/null 2>&1 || [ -x "$META_ROOT/kasetto/target/release/kasetto" ]; then
    KASETTO="$(command -v kasetto || echo "$META_ROOT/kasetto/target/release/kasetto")"
    # Global sync manages the global MCP destination — keep it additive (see the safety
    # note inside envctl/home/.config/kasetto/kasetto.yaml). Dry-run first, always.
    run "$KASETTO" sync --global --dry-run || true
    run "$KASETTO" sync --locked || echo "WARN: kasetto sync drift — review kasetto.yaml/kasetto.lock"
  else
    echo "WARN: kasetto not built — phase 2 should produce it"
  fi
fi

# ---- phase 5: verify ---------------------------------------------------------------
if phase 5; then
  say "phase 5: green gate"
  ENVCTL="$META_ROOT/envctl/target/release/envctl"; [ -x "$ENVCTL" ] || ENVCTL="envctl"
  ( cd "$META_ROOT/envctl" && run "$ENVCTL" doctor ) || true
  ( cd "$META_ROOT/envctl" && run "$ENVCTL" lock --check ) || \
    echo "WARN: envctl.lock drift — review before committing"
  run meta git status || true
  say "done. Portability contract: real file in meta, symlink outside. See PORTABILITY-AUDIT.md"
fi

# ---- phase 6: pre-push preflight gates --------------------------------------------
if phase 6; then
  say "phase 6: install pre-push preflight hooks (auto-merge guard) across Rust repos"
  if [ "$DRY_RUN" = 1 ]; then
    run bash "$META_ROOT/scripts/install-preflight-hooks.sh" --dry-run
  else
    run bash "$META_ROOT/scripts/install-preflight-hooks.sh" || \
      echo "WARN: preflight hook install reported issues — re-run scripts/install-preflight-hooks.sh"
  fi
fi
