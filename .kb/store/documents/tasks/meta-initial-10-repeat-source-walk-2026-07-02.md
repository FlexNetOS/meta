---
id: 019f215e-e14b-7811-93c0-4dba2d9207d0
slug: tasks/meta-initial-10-repeat-source-walk-2026-07-02
title: "Repeat source walk for initial 10 meta repos"
type: task
status: completed
priority: high
tags: [meta, source-walk, gitkb, memory]
---

# Summary

Repeat the clean-base manual source walk for the initial 10 meta repos at every depth, add any newly needed tasks to GitKB, and save key findings to Codex memory.

# Scope

Initial 10 repos: loop_cli, loop_lib, meta_cli, meta_core, meta_git_cli, meta_git_lib, meta_mcp, meta_plugin_protocol, meta_rust_cli, meta_project_cli.

# Constraints

- Preserve the upstream mirror source trees.
- Treat child repos as independent git repos.
- Add only evidence-backed KB tasks.
- Save concise key findings to memory after verification.

# Completion Evidence

Completed the repeat manual source walk for the initial 10 repos:

- `loop_cli`
- `loop_lib`
- `meta_cli`
- `meta_core`
- `meta_git_cli`
- `meta_git_lib`
- `meta_mcp`
- `meta_plugin_protocol`
- `meta_rust_cli`
- `meta_project_cli`

Confirmed the tracked source/config/workflow files by repo and read the large files in chunks to avoid truncated evidence. No source repo files were edited.

# Findings Routed To Existing Tasks

- `tasks/loop-lib-sequential-spawn-error-handling`: `loop_lib/src/lib.rs` still panics on sequential `spawn`/`wait` failures via `expect`.
- `tasks/meta-core-atomic-write-temp-collision`: `meta_core/src/store.rs` still writes atomic temp data to a fixed sibling `path.with_extension("tmp")`.
- `tasks/meta-command-surface-docs-reconciliation`: stale command/docs evidence remains in embedded Claude skills and help text, including `--ordered`, `meta git setup-ssh`, `meta project sync`, `meta project update`, `.meta-plugins`, and `--include-only`.
- `tasks/meta-lockfile-version-drift`: standalone child CI still synthesizes workspace roots with hardcoded package versions (`0.1.0` in most repos, `0.0.0` in `meta_git_cli`) and some workflows create `VERSION=0.0.0-ci`.
- `tasks/meta-mcp-destructive-tool-guardrails`: `meta_mcp/src/main.rs` exposes mutating/destructive MCP tools, including add, commit, push, checkout, snapshot restore, and batch shell execution.
- `tasks/meta-worktree-hook-trust-boundary`: `meta_git_lib/src/worktree/hooks.rs` executes trusted `.meta` hook strings through `sh -c` with JSON stdin.

# New Tasks

No duplicate tasks were created. Every repeat-walk issue found was already represented by an existing GitKB task with adequate source evidence.

# Memory

Saved a concise key-finding note to Codex memory at `/home/flexnetos/.codex/memories/extensions/ad_hoc/notes/2026-07-02-meta-repeat-source-walk.md`.
