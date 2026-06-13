#!/usr/bin/env bash
# preflight.sh — run a repo's fast *required* CI gates locally, before push.
#
# Why this exists: GitHub auto-merge stays BLOCKED when any *required* status
# check fails — and a clippy-clean change can still be rustfmt-dirty, so the
# required `Format` check fails silently while tests are green and the PR never
# lands. This gate runs the cheap required checks (fmt, then clippy — which also
# covers `Check`) so a push can't enter a state that blocks its own auto-merge.
# The slow/networked required checks (tests, Cargo Audit, Cargo Deny) stay in CI.
#
# Usage:   scripts/preflight.sh [REPO_ROOT]      # default: cwd
# Skip:    SKIP_PREFLIGHT=1 git push ...         # or: git push --no-verify
#
# Contract: exit 0 = clear to push (or nothing to check); non-zero = blocked,
# with the failing gate named and the one-line fix. Non-Rust repos pass through.
set -uo pipefail

repo_root="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
name="$(basename "$repo_root")"

if [ "${SKIP_PREFLIGHT:-0}" = "1" ]; then
  echo "preflight[$name]: SKIP_PREFLIGHT=1 — skipping local gates." >&2
  exit 0
fi

# Non-Rust repo → nothing this gate knows how to check; pass through.
if [ ! -f "$repo_root/Cargo.toml" ]; then
  exit 0
fi

if ! command -v cargo >/dev/null 2>&1; then
  echo "preflight[$name]: cargo not found — skipping (install rust toolchain)." >&2
  exit 0
fi

fail() {
  echo "" >&2
  echo "preflight[$name]: BLOCKED — required check '$1' would fail in CI." >&2
  echo "  fix:    $2" >&2
  echo "  bypass: SKIP_PREFLIGHT=1 git push   (or: git push --no-verify)" >&2
  exit 1
}

cd "$repo_root" || exit 0

# Scope to THIS repo's own packages. Cargo walks UP to the outermost workspace, so in the
# meta tree a member repo's `cargo fmt --all` / `clippy --workspace` would lint the *entire*
# meta workspace (other sibling repos) — far stricter than that repo's standalone CI, which
# clones it alone. We instead select only packages whose manifest belongs to this git repo
# (same `git rev-parse --show-toplevel`), which also excludes nested child repos.
PFLT_PY='
import json, os, subprocess, sys
repo = os.path.realpath(sys.argv[1])
try:
    pkgs = json.load(sys.stdin).get("packages", [])
except Exception:
    sys.exit(0)
own = []
for p in pkgs:
    md = os.path.dirname(p["manifest_path"])
    rmd = os.path.realpath(md)
    if rmd != repo and not rmd.startswith(repo + os.sep):
        continue  # sibling repo in the parent workspace
    try:
        top = subprocess.check_output(
            ["git", "-C", md, "rev-parse", "--show-toplevel"],
            stderr=subprocess.DEVNULL).decode().strip()
    except Exception:
        continue
    if os.path.realpath(top) == repo:  # not a nested child repo
        own.append(p["name"])
print(" ".join("-p " + n for n in sorted(set(own))))
'
pkgs="$(cargo metadata --format-version 1 --no-deps 2>/dev/null | python3 -c "$PFLT_PY" "$repo_root")"

# No own packages (virtual meta-root manifest whose members are all nested repos, or cargo
# metadata unavailable) → nothing this repo owns to lint; skip cleanly (CI gates the rest).
if [ -z "$pkgs" ]; then
  echo "preflight[$name]: no own cargo packages resolved — skipping fmt/clippy."
  exit 0
fi

# shellcheck disable=SC2086  # $pkgs is intentionally word-split into -p <name> args.

# 1) Format (required check 'Format'): cheap, the usual silent auto-merge blocker.
echo "preflight[$name]: cargo fmt $pkgs --check"
cargo fmt $pkgs -- --check >/dev/null 2>&1 \
  || fail "Format" "cargo fmt $pkgs"

# 2) Clippy (required checks 'Clippy' + 'Check'): clippy compiles, so it covers both.
#    No --all-targets: a gate stricter than CI would false-block pushes CI would pass.
#
#    Feature strategy: prefer --all-features (what repos like prompt_hub require), but some
#    repos define MUTUALLY-EXCLUSIVE features (e.g. weave's sqlite vs libsql backends, with a
#    compile_error! enforcing exactly one). --all-features turns both on → E0255/compile_error,
#    which is NOT a lint failure and NOT what that repo's CI runs. Detect that specific case
#    and fall back to DEFAULT features (always a valid combo). The gate must mirror CI, not
#    impose a feature set CI itself rejects.
log="$(mktemp -t preflight-clippy.XXXXXX)"
run_clippy() { cargo clippy $pkgs "$@" -- -D warnings >"$log" 2>&1; }

echo "preflight[$name]: cargo clippy $pkgs --all-features -- -D warnings"
if ! run_clippy --all-features; then
  if grep -qE "E0255|defined multiple times|compile_error|cannot be enabled|mutually exclusive" "$log"; then
    echo "preflight[$name]: --all-features enables mutually-exclusive features here; retrying with default features (matches this repo's CI)." >&2
    echo "preflight[$name]: cargo clippy $pkgs -- -D warnings"
    if ! run_clippy; then
      grep -E "^(error|warning)" "$log" | head -15 >&2
      rm -f "$log"
      fail "Clippy" "cargo clippy $pkgs --fix  (then resolve remaining -D warnings)"
    fi
  else
    grep -E "^(error|warning)" "$log" | head -15 >&2
    rm -f "$log"
    fail "Clippy" "cargo clippy $pkgs --all-features --fix  (then resolve remaining -D warnings)"
  fi
fi
rm -f "$log"

echo "preflight[$name]: OK — required fast gates green (tests/audit/deny run in CI)."
exit 0
