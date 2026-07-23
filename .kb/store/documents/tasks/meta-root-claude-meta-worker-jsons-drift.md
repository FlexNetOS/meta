---
id: 019f2173-496f-7132-a7c8-f48b9555a57a
slug: tasks/meta-root-claude-meta-worker-jsons-drift
title: "Fix stale --jsons in root meta-worker agent doc"
type: task
status: completed
priority: medium
tags: [docs, claude, alignment]
---

# Summary

The root Claude meta-worker agent document still tells workers to use `meta project list --jsons`, but the live meta CLI exposes the global `--json` flag and does not document `--jsons`.

# Source Evidence

- `.claude/agents/meta-worker.md` Phase 0 command block says `meta project list --jsons`.
- `meta --help` shows `--json` as the output flag.
- `meta project list --recursive --json` works and was used for the initial-14 repo inventory.

# Acceptance Criteria

- Replace the stale `--jsons` command form with the current JSON command form.
- Add or update a lightweight check if this generated/agent doc has a validation path.
