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
#
#    PER-REPO CI MIRROR: the gate mirrors THIS repo's OWN CI clippy flags so it is an exact
#    SUBSET of that repo's CI — never stricter (won't false-block), never weaker (won't miss
#    what CI catches). We detect the repo's CI clippy invocation in .github/workflows/*.yml:
#      * if a CI clippy line uses --all-targets → we add --all-targets too. This LINTS TEST
#        CODE. Repos like handoff use it; without mirroring it, a test-code lint (e.g. a
#        needless &borrow in a #[cfg(test)] assert) passes preflight but FAILS CI (PR #30).
#      * if a CI clippy line uses --all-features → we keep our --all-features axis (default).
#        If no CI clippy line is found (or no .github/workflows), we keep current behavior
#        (--all-features) so repos without detectable CI never regress.
#
#    Feature strategy (the --all-features axis only): try --all-features first (the strictest
#    useful combo, and what repos like prompt_hub require in CI). But --all-features can enable
#    feature combos a repo's CI NEVER uses and that don't even compile — mutually-exclusive
#    backends (weave's sqlite + libsql → E0255/compile_error!) or deprecated empty features
#    whose cfg'd code references removed modules (shimmy's `llama` → E0433). Those are
#    feature-combo artifacts, not real lint failures. So: if --all-features fails, retry with
#    DEFAULT features (always a valid combo). If default passes, the failure was an
#    --all-features artifact → don't block (genuine --all-features-only issues are CI's job).
#    The --all-targets axis is NOT subject to this fallback: an --all-targets failure is a real
#    test-code lint that IS in CI and SHOULD block. --all-targets is always carried into both
#    the --all-features attempt and the default-features retry.
#
#    Detect this repo's CI clippy flags. ROBUST DETECTION: scan EVERY real `cargo clippy`
#    RUN STEP across ALL .github/workflows/*.yml and OR the flag across them — a flag is
#    mirrored if ANY clippy run-step in ANY workflow uses it.
#      * ANCHOR TO `run:` STEPS: match only `^\s*(- )?run:.*cargo clippy`. A bare
#        `grep 'cargo clippy'` OVER-detects: it matches NON-command text — e.g. a JS string
#        literal `` `cargo clippy --all-targets` `` inside a github.rest.issues.createComment
#        body (prompt_hub/.github/workflows/external-ai-apis.yml:205, PROSE not a step).
#        prompt_hub's ONLY real clippy step is ci.yml:79 `run: cargo clippy --workspace
#        --all-features` (NO --all-targets). The bare grep would mirror --all-targets onto
#        prompt_hub → a gate STRICTER than its CI → a latent false-block (fires on the first
#        #[cfg(test)]-only lint) on shared infra gating ~28 Rust repos. Anchoring to `run:`
#        command lines fixes this WITHOUT losing any real clippy step.
#      * A naive `head -1` also UNDER-detects: the first match can be a YAML
#        `name: cargo clippy ...` label (ruflo) or a non-all-targets run line while a sibling
#        workflow DOES use --all-targets (RuVector ci/clippy-fmt/release). OR-across-all-run-
#        steps is conservative on the catch axis and still never adds a flag NO CI uses (no
#        false-block) — neither over-detect (prompt_hub) nor under-detect (ruflo/RuVector).
ci_clippy_lines="$(grep -hE '^[[:space:]]*(- )?run:.*cargo clippy' "$repo_root"/.github/workflows/*.yml 2>/dev/null)"
targets_flag=""
case "$ci_clippy_lines" in
  *--all-targets*) targets_flag="--all-targets" ;;
esac
if [ -n "$targets_flag" ]; then
  echo "preflight[$name]: CI uses --all-targets (lints test code) → mirroring it."
fi

log="$(mktemp -t preflight-clippy.XXXXXX)"
# shellcheck disable=SC2086  # $targets_flag is "" or "--all-targets" (intentional word-split).
run_clippy() { cargo clippy $pkgs $targets_flag "$@" -- -D warnings >"$log" 2>&1; }

echo "preflight[$name]: cargo clippy $pkgs $targets_flag --all-features -- -D warnings"
if ! run_clippy --all-features; then
  echo "preflight[$name]: --all-features clippy failed; retrying with default features (feature-combo issues are CI's job — the gate is a strict subset of CI)." >&2
  echo "preflight[$name]: cargo clippy $pkgs $targets_flag -- -D warnings"
  if ! run_clippy; then
    grep -E "^(error|warning)" "$log" | head -15 >&2
    rm -f "$log"
    fail "Clippy" "cargo clippy $pkgs $targets_flag --fix  (then resolve remaining -D warnings)"
  fi
fi
rm -f "$log"

echo "preflight[$name]: OK — required fast gates green (tests/audit/deny run in CI)."
exit 0
