---
id: 019f218f-6bf4-7852-8730-c11e9b09ad66
slug: tasks/meta-claude-gitkb-command-hook-drift
title: "Align Claude GitKB command and daemon hook docs"
type: task
status: completed
priority: high
tags: [claude, gitkb, hooks, docs]
---

# Summary

The checked-in Claude GitKB skill and settings still reference legacy command forms that fail in this workspace.

# Evidence

- `git kb --help` fails because `git` has no `kb` subcommand in this shell.
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb daemon --help` exposes daemon management.
- `.claude/settings.json` contains `git kb service status/start`.
- `.claude/skills/gitkb/SKILL.md` tells agents to use `git kb` and `git kb service`.

# Acceptance Criteria

- Checked-in Claude settings do not call legacy `git kb service`.
- GitKB skill docs point agents at the working `git-kb` command and `git-kb daemon`.
- Tests or searches verify no legacy `git kb service` guidance remains in tracked source.
