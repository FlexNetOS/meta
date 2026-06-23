---
name: meta-worktree
description: Use for isolated multi-repo worktree creation, execution, status, diff, pruning, and parallel worker setup in the meta workspace.
---

Use `rtk meta git worktree` for isolated cross-repo work.

Common commands:

- `rtk meta git worktree create <name> --repo . --repo <repo>`
- `rtk meta git worktree list --json`
- `rtk meta git worktree status <name>`
- `rtk meta git worktree diff <name> --base main`
- `rtk meta git worktree exec <name> -- <cmd>`
- `rtk meta git worktree destroy <name>`
- `rtk meta git worktree prune --dry-run`

Always include `--repo .` when a worktree needs full meta config, tags, plugins, and dependency graph behavior. Read `.claude/skills/meta-worktree.md` and `claude-plugin/skills/meta-worktree/SKILL.md` for details.
