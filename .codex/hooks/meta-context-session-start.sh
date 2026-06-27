#!/usr/bin/env bash
set -euo pipefail

# Runs under .codex/hooks/with-meta-env.sh when invoked from hooks.json. If called directly,
# continue to work as long as the caller already provided META_ROOT/PATH.
context=""
if command -v rtk >/dev/null 2>&1; then
  context="$(cd "${META_ROOT:-$PWD}" && timeout 8s rtk meta context 2>/dev/null || true)"
fi

META_CONTEXT="$context" rtk python3 -c '
import json
import os

context = os.environ.get("META_CONTEXT", "")
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": context,
        "watchPaths": [],
    }
}))
'
