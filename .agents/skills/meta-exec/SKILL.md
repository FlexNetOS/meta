---
name: meta-exec
description: Use when running shell/build/test commands across the meta workspace or targeted sets of child repos.
---

Use `rtk meta exec` for cross-repo commands instead of manual `cd` loops.

Patterns:

- `rtk meta exec -- <cmd>`
- `rtk meta --include repo1,repo2 exec -- <cmd>`
- `rtk meta --exclude repo exec -- <cmd>`
- `rtk meta --tag rust exec -- rtk cargo test`
- `rtk meta --ordered exec -- rtk cargo build`
- `rtk meta --dry-run exec -- <dangerous-cmd>`

Target narrowly, dry-run destructive commands, and prefer ordered execution when dependency order matters. Read `.claude/skills/meta-exec.md` and `claude-plugin/skills/meta-exec/SKILL.md` for the full inherited command surface.
