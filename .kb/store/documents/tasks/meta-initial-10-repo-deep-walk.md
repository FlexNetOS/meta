---
id: 019f2151-2d91-7b30-986b-f4b852dc174f
slug: tasks/meta-initial-10-repo-deep-walk
title: "Deep walk initial 10 meta repos"
type: task
status: completed
priority: high
tags: [meta, source-walk, gitkb]
---

# Summary

Walk every file at every depth for the initial 10 Rust workspace repos in upstream `gitkb/meta`, then add any source-backed issues or cleanup work to the GitKB task system before source changes.

# Scope

Initial 10 repos are the root Cargo workspace members: `loop_cli`, `loop_lib`, `meta_cli`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_rust_cli`, and `meta_project_cli`.

# Constraints

- Preserve the clean upstream root mirror unless an explicit source task is started.
- Treat every child as an independent git repo, not monorepo folders.
- Read all tracked source files at all depths, excluding ignored/generated build output.
- Add only evidence-backed follow-up tasks to GitKB.
- Record command evidence and final repo cleanliness before completion.

# Completion Evidence

Completed on 2026-07-02 after resetting the original peer repos back to their upstream `gitkb/*` mirrors and pruning confusing local branches.

- Verified all 14 peer repos (`loop_cli`, `loop_lib`, `meta_cli`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_rust_cli`, `meta_project_cli`, `agent`, `claude-plugins`, `codex-plugins`, `meta-plugins`) on `main...origin/main` with origin URLs under `https://github.com/gitkb/`.
- Verified each peer had only local branch `main` after the cleanup pass.
- Removed child `.kb/` directories that were untracked peer-local residue, leaving GitKB state centralized in the root meta KB.
- Walked all tracked files in the initial 10 workspace repos at all depths, excluding generated/ignored build output.
- Recorded follow-up issues in GitKB instead of changing source:
  - `tasks/meta-command-surface-docs-reconciliation`
  - `tasks/meta-lockfile-version-drift`
  - `tasks/loop-lib-sequential-spawn-error-handling`
  - `tasks/meta-core-atomic-write-temp-collision`
  - `tasks/meta-mcp-destructive-tool-guardrails`
  - `tasks/meta-worktree-hook-trust-boundary`

# Commands Run

- `git status --short --branch`
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb status --json`
- `/home/flexnetos/FlexNetOS/usr/bin/meta exec -- git status --short --branch`
- Per-peer `git remote -v`, `git branch --format`, and `git status --short --branch` checks.
- Per-repo tracked-file enumeration and manual reads for the initial 10 repos.
