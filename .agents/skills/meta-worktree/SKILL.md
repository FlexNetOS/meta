---
name: meta-worktree
description: Use for isolated multi-repo worktree creation, execution, status, diff, pruning, and parallel worker setup in the meta workspace.
---

Use meta worktrees for isolated cross-repo work.

Common commands:

- `meta worktree create <name> --repo . --repo <repo>`
- `meta worktree list --json`
- `meta worktree status <name>`
- `meta worktree diff <name> --base main`
- `meta worktree exec <name> -- <cmd>`
- `meta worktree destroy <name>`
- `meta worktree prune --dry-run`

Always include `--repo .` when a worktree needs full meta config, tags, plugins, and dependency graph behavior. Read `.claude/skills/meta-worktree.md` and `claude-plugin/skills/meta-worktree/SKILL.md` for details.
