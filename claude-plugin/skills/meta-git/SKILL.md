---
name: meta-git
description: Git operations across multiple repositories — status, commit, push, pull, snapshots, multi-commit.
---

# Meta Git Skill

Git operations across multiple repositories. One command operates on ALL repos in the workspace.

## The Core Insight

**Use `rtk meta git` instead of `git`** when you want to operate across the workspace:

```bash
# Instead of running rtk git status in each repo...
rtk meta git status    # Shows status for ALL repos at once

# Instead of committing in each repo...
rtk meta git commit -m "feat: update"    # Commits in ALL dirty repos
```

## Cloning a Meta Repo

```bash
# Clone meta repo and all child repos defined in .meta
rtk meta git clone <url>

# Clone recursively (if child repos are also meta repos)
rtk meta git clone <url> --recursive

# Control parallelism
rtk meta git clone <url> --parallel 8

# Shallow clone
rtk meta git clone <url> --depth 1
```

**How it works**: Meta clones the parent, reads `.meta`, then queues and clones all children in parallel. With `--recursive`, it repeats for any child that has its own `.meta`.

## Updating All Repos

```bash
# Pull latest + clone any missing repos
rtk meta git update
```

This is the "sync workspace" command - ensures you have all repos at latest.

## Snapshots (Critical for Batch Operations)

Before making sweeping changes, create a snapshot:

```bash
# Save current state of ALL repos
rtk meta git snapshot create before-refactor

# See what snapshots exist
rtk meta git snapshot list

# Preview what restore would do
rtk meta --dry-run git snapshot restore before-refactor

# Actually restore (auto-stashes uncommitted work)
rtk meta git snapshot restore before-refactor
```

**What snapshots capture per repo:**
- Current SHA
- Branch name
- Dirty status

**On restore**: If a repo has uncommitted changes, meta automatically stashes them before checking out the snapshot state.

## Common Git Operations

All standard git commands work:

```bash
rtk meta git pull
rtk meta git push
rtk meta git fetch
rtk meta git checkout -b feature/new-thing
rtk meta git add .
rtk meta git diff
rtk meta git log --oneline -5
```

## Filtering

Target specific repos:

```bash
# By tag
rtk meta --tag backend git status

# By name
rtk meta --include api,web git push

# Exclude repos
rtk meta --exclude legacy git pull
```

## Workflow Patterns

### Starting Work
```bash
rtk meta git status              # What's the current state?
rtk meta git snapshot create wip # Save state before changes
rtk meta git pull                # Get latest
```

### After Making Changes
```bash
rtk meta git status              # Review changes across repos
rtk meta git add .               # Stage in all repos
rtk meta git commit -m "feat: ..." # Commit with shared message
rtk meta git push                # Push all repos
```

### Safe Batch Refactoring
```bash
rtk meta git snapshot create before-changes
# ... make changes across repos ...
rtk meta git status              # Review
# If something went wrong:
rtk meta git snapshot restore before-changes
```

## SSH Optimization

For faster parallel operations:

```bash
rtk meta git setup-ssh
```

Configures SSH connection multiplexing for reuse across parallel git operations.

## MCP Tools for Git Operations

When the meta MCP server is available, these tools provide structured JSON output:

| Tool | Purpose |
|------|---------|
| `meta_git_multi_commit` | Per-repo commit messages in one call (for audit trails when changes differ) |
| `meta_git_status` | Structured rtk git status across all repos |
| `meta_git_diff` | Structured diff output |
| `meta_git_branch` | Branch info across repos |

## Efficiency Tips

- **Targeted commits**: `rtk meta --include repo1,repo2 git commit -m "msg"` commits in exactly the repos you want
- **Tag-based push**: `rtk meta --tag backend git push` pushes only tagged repos
- **Per-repo messages**: Use `meta_git_multi_commit` when changes in different repos need different commit messages
- **One-call status**: `rtk meta git status` replaces N individual `cd && rtk git status` sequences
