---
name: meta-safety
description: Use before destructive, broad, or cross-repo changes in the FlexNetOS meta workspace.
---

Safety defaults:

1. Discover scope with `rtk meta project list --json`.
2. Check state with `rtk meta git status`.
3. Use `rtk meta --include`, `--exclude`, `--tag`, and `--ordered` to target exact repos.
4. Use `rtk meta --dry-run exec -- <cmd>` before broad destructive commands.
5. Use `rtk meta git snapshot create <name>` before irreversible workspace operations.
6. Do not revert or delete user-owned changes.

The Codex PreToolUse hook runs `rtk "$HOME/Desktop/meta/agent/target/debug/agent" guard` for destructive Bash patterns. Read `.claude/rules/meta-destructive-commands.md`, `.claude/rules/meta-workspace-discipline.md`, and `claude-plugin/skills/meta-safety/SKILL.md` for the full policy.
