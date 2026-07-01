---
id: 019f1f24-04b3-70a2-b45d-2db3b1402a3d
slug: context/immutable/project-brief
title: "Project Brief"
type: brief
status: draft
priority: medium
---

# Project Brief

`meta` is a Rust multi-repository management CLI. Its purpose is to make a set
of independent Git repositories feel operationally cohesive without turning them
into a monorepo or Git submodules.

The clean-room baseline for this workspace is branch
`codex/clean-room-foundation-base-20260628` at
`868edfee4e5104a18c6818f2fb604305598fb01c`.

## Core Requirements

- Treat this repository as a meta-repo. Child directories listed in `.meta.yaml`
  are independent Git repositories with their own remotes, branches, commits,
  and worktrees.
- Keep implementation crates as peer repos under this meta root, not vendored
  source and not submodules.
- Use `.meta.yaml` as the project inventory and `Cargo.toml` as the clean-room
  Rust workspace boundary.
- Use GitKB for persistent project context before broad implementation work.
- Use live proof from repo state, GitKB, meta, command logs, or runner output
  before marking work complete.

## Clean-Room Boundary

The clean-room branch has 10 Cargo workspace members:

- `loop_cli`
- `loop_lib`
- `meta_cli`
- `meta_core`
- `meta_git_cli`
- `meta_git_lib`
- `meta_mcp`
- `meta_plugin_protocol`
- `meta_project_cli`
- `meta_rust_cli`

If `rtk-tokenkill`, `shimmy`, `meta_plugin_api`, or `meta_dashboard_cli` appear
as workspace members, the agent is not looking at the clean-room branch.

## Foundational Decisions

- The loop engine performs the actual per-directory command execution.
- The main `meta` CLI parses configuration, filters projects, discovers plugins,
  and routes commands.
- Plugins are subprocess executables that communicate via JSON on stdin/stdout.
- MCP support exists so agents can inspect and operate on multi-repo workspaces.
- Distribution should support users without requiring Rust, but local source
  validation still belongs in the owning peer repos.
