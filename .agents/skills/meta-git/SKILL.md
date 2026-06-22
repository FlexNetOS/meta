---
name: meta-git
description: Use for git operations that may span multiple repos in the FlexNetOS meta workspace, including status, snapshot, commit, push, worktree, and update flows.
---

Use `rtk meta git` for workspace git operations.

Core commands:

- `rtk meta git status`
- `rtk meta git update`
- `rtk meta git snapshot create <name>`
- `rtk meta git snapshot restore <name>`
- `rtk meta --include repo1,repo2 git <args>`
- `rtk meta --tag <tag> git <args>`

Before destructive or broad operations, create or inspect a snapshot and use precise `--include`, `--exclude`, or `--tag` filters. For the full command guide, read `.claude/skills/meta-git.md` and `claude-plugin/skills/meta-git/SKILL.md`.
