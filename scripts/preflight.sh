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

# 1) Format (required check 'Format'): cheap, the usual silent auto-merge blocker.
echo "preflight[$name]: cargo fmt --all --check"
cargo fmt --all -- --check >/dev/null 2>&1 \
  || fail "Format" "cargo fmt --all"

# 2) Clippy (required checks 'Clippy' + 'Check'): clippy compiles, so it covers both.
#    Mirror CI EXACTLY (`cargo clippy --workspace --all-features -- -D warnings`) — do NOT
#    add --all-targets here: a preflight stricter than CI would false-block pushes that CI
#    would actually pass. The gate must be a subset of CI, never stricter (test/bench
#    compilation is the Test job's concern, which runs in CI).
echo "preflight[$name]: cargo clippy --workspace --all-features -- -D warnings"
if ! cargo clippy --workspace --all-features -- -D warnings >/tmp/preflight-clippy-$$.log 2>&1; then
  grep -E "^(error|warning)" /tmp/preflight-clippy-$$.log | head -15 >&2
  rm -f /tmp/preflight-clippy-$$.log
  fail "Clippy" "cargo clippy --workspace --all-features --fix  (then resolve remaining -D warnings)"
fi
rm -f /tmp/preflight-clippy-$$.log

echo "preflight[$name]: OK — required fast gates green (tests/audit/deny run in CI)."
exit 0
