---
name: meta-exec
description: Use when running shell/build/test commands across the meta workspace or targeted sets of child repos.
---

Use `meta exec` for cross-repo commands instead of manual `cd` loops.

Patterns:

- `meta exec -- <cmd>`
- `meta --include repo1,repo2 exec -- <cmd>`
- `meta --exclude repo exec -- <cmd>`
- `meta --tag rust exec -- cargo test`
- `meta --ordered exec -- cargo build`
- `meta --dry-run exec -- <dangerous-cmd>`

Target narrowly, dry-run destructive commands, and prefer ordered execution when dependency order matters. Read `.claude/skills/meta-exec.md` and `claude-plugin/skills/meta-exec/SKILL.md` for the full inherited command surface.
