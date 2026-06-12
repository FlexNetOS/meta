#!/usr/bin/env bash
# Stop / PreCompact hook — witness an auto-checkpoint into the fleet ledger (ADR-0004 §3).
# Until `hf checkpoint --auto --quiet` lands (in-flight kernel tranche), this is a
# silent no-op: hf rejects the flags, we swallow it, the session is never blocked.
# When the verb lands, auto-checkpointing goes live with zero settings changes.
# The verb itself owns debounce semantics (no event when nothing changed).
set -u
ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"

HF=""
for c in "$ROOT/handoff/target/release/hf" "$ROOT/handoff/target/debug/hf"; do
  [ -x "$c" ] && HF="$c" && break
done
[ -n "$HF" ] || exit 0

cd "$ROOT/handoff" 2>/dev/null || exit 0
"$HF" checkpoint --auto --quiet >/dev/null 2>&1 || true
exit 0
