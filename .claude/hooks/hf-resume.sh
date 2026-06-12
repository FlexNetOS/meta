#!/usr/bin/env bash
# SessionStart hook — inject the latest handoff packet as session context (ADR-0004).
# The kernel is the source of resume truth: Git > .handoff/ledger.db > cards > prose.
# Graceful by design: a session must never fail to start because the kernel is
# unbuilt or a verb hasn't landed yet — exit 0 silently in every degraded case.
set -u
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"

HF=""
for c in "$ROOT/handoff/target/release/hf" "$ROOT/handoff/target/debug/hf"; do
  [ -x "$c" ] && HF="$c" && break
done
[ -n "$HF" ] || exit 0

cd "$ROOT/handoff" 2>/dev/null || exit 0

# Prefer the compact packet (kernel verb tranche); fall back to a bounded head of
# the full packet so context injection stays small either way.
out=$("$HF" resume --compact 2>/dev/null) || out=$("$HF" resume 2>/dev/null) || exit 0
[ -n "$out" ] || exit 0
printf '%s\n' "$out" | head -25
exit 0
