---
description: Spawn or use a meta-worker style subagent.
argument-hint: TASK="worker task"
---

Use the `meta-worker` custom agent if subagents are available.
The worker must treat `/home/drdave/Desktop/meta` as a meta-repo, inspect `meta project list --json` and `meta git status --json`, avoid reverting user-owned changes, and return a concise verification-backed handoff.

Task: $TASK
