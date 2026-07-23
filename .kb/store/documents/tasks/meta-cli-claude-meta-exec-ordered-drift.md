---
id: 019f2173-49a8-7d83-b9e4-1f9c85a5356b
slug: tasks/meta-cli-claude-meta-exec-ordered-drift
title: "Fix stale --ordered guidance in meta-exec skill"
type: task
status: completed
priority: medium
tags: [docs, claude, meta-cli]
---

# Summary

`meta_cli/.claude/skills/meta-exec.md` documents a global `--ordered` mode that is not present in live `meta --help`.

# Source Evidence

- `meta_cli/.claude/skills/meta-exec.md` Efficiency Tips say to use `--ordered` for dependency-aware build/test order.
- Live `meta --help` includes `--parallel` and `--sequential`, but not `--ordered`.

# Acceptance Criteria

- Update the skill guidance to the supported ordering/selection behavior.
- Add this stale pattern to any doc validation grep/check.
