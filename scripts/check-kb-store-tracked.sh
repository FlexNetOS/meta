#!/usr/bin/env bash
# check-kb-store-tracked.sh — META-ORG-POLICY P5.23a conformance check.
#
# A repo's git-kb document store (.kb/store/) must be git-TRACKED text (the durable
# source of truth), not gitignored. `git-kb init`'s tool default ignores .kb/store/
# wholesale, which makes the KB non-durable (nothing committed/pushed; docs lost on
# clone). This reports any repo whose .kb exists but whose store would be ignored.
#
# Usage:
#   scripts/check-kb-store-tracked.sh [REPO ...]   # default: this repo (toplevel)
#   STRICT=1 scripts/check-kb-store-tracked.sh ...  # exit 1 on any violation
#
# Rollout is fleet-wide (like the P7 .handoff rollout): advisory by default so it
# does not break CI for members still carrying the git-kb tool default. Flip STRICT=1
# per-repo (or in that repo's own gate) once it has been corrected.
set -euo pipefail

violations=0
checked=0

check_repo() {
  local repo="$1"
  [ -d "$repo/.kb" ] || return 0          # no KB → nothing to enforce
  checked=$((checked + 1))
  # A representative store path; -C runs check-ignore in the repo's gitdir context.
  if git -C "$repo" check-ignore -q .kb/store/documents 2>/dev/null \
     || git -C "$repo" check-ignore -q .kb/store 2>/dev/null; then
    echo "VIOLATION: $repo ignores .kb/store/ (KB is non-durable — see META-ORG-POLICY P5.23a)"
    violations=$((violations + 1))
  else
    echo "ok: $repo tracks .kb/store/"
  fi
}

if [ "$#" -gt 0 ]; then
  for r in "$@"; do check_repo "$r"; done
else
  check_repo "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
fi

echo "--- checked $checked repo(s) with a .kb/, $violations violation(s) ---"
if [ "$violations" -gt 0 ] && [ "${STRICT:-0}" = "1" ]; then
  exit 1
fi
exit 0
