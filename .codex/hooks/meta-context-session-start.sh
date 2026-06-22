#!/usr/bin/env bash
set -euo pipefail

meta context 2>/dev/null | python3 -c '
import json
import sys

context = sys.stdin.read()
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": context,
        "watchPaths": [],
    }
}))
'
