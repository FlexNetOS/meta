---
id: 019f2173-4992-7fb3-9491-badff1705cdd
slug: tasks/meta-root-claude-settings-hook-command-drift
title: "Align tracked Claude settings hooks with generated hook commands"
type: task
status: completed
priority: high
tags: [hooks, claude, alignment]
---

# Summary

Tracked root `.claude/settings.json` is out of sync with the generated hook commands from `meta init claude`, and the init command is not help-safe when invoked as `meta init claude --help`.

# Source Evidence

- `.claude/settings.json` currently uses `./target/debug/agent guard` for the Bash `PreToolUse` hook.
- `meta_cli/src/init.rs` generates `agent guard` for the Bash `PreToolUse` hook and `meta context 2>/dev/null` for context hooks.
- Running `/home/flexnetos/FlexNetOS/usr/bin/meta init claude --help` during the prep audit executed the init path and attempted to merge an additional `agent guard` hook instead of printing command help.
- The transient source change was reverted immediately to preserve the clean upstream mirror.

# Acceptance Criteria

- Align tracked root hook settings with the canonical generated command form or document why they intentionally differ.
- Make `meta init claude --help` print help without mutating `.claude/settings.json`.
- Add a regression test for help-only init invocation.
