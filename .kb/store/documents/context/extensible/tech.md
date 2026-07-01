---
id: 019f1f24-04ee-7de1-bd8f-fb10be2f9121
slug: context/extensible/tech
title: "Tech Context"
type: context
status: draft
priority: medium
---

# Tech Context

## Stack

- Rust workspace, edition 2021.
- Workspace package version on the clean-room branch: `0.2.22`.
- CLI parsing is based on `clap`.
- Serialization and plugin protocol use JSON through serde-compatible types.
- Error handling should use idiomatic `Result`, `Option`, `anyhow`, and
  `thiserror` patterns where the owning crates already do so.
- MCP server support exposes meta operations to agent clients.

## Clean-Room Workspace Members

The branch-local `Cargo.toml` includes:

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

`agent` is excluded from the Cargo workspace in this branch.

## Local Tooling

- Use `/home/flexnetos/FlexNetOS/usr/bin/git-kb` for GitKB.
- Use `/home/flexnetos/FlexNetOS/usr/bin/meta` for installed meta runtime proof.
  It currently wraps the upstream `meta-release` binary so plugin discovery can
  see workspace-local plugin binaries.
- Use the installed Yazelix `yzx run nu -c ...` route when the user asks for
  Yazelix/Nushell-shaped installs.
- Bun and bunx, when needed for Node tasks in this workspace, are fronted from
  `/home/flexnetos/FlexNetOS/usr/bin`.
- Do not infer missing tools from ambient `PATH`; use the workspace frontdoors
  or Yazelix-provided dev shells.
- When running GitKB code intelligence with `repos.strategy = "meta"`, prepend
  `/home/flexnetos/FlexNetOS/usr/bin` to `PATH` so GitKB can resolve the
  workspace `meta` frontdoor.
- Code intelligence is branch-mapped to
  `codex/clean-room-foundation-base-20260628` in `.kb/config.toml`; do not let
  the index silently fall back to `main` for this clean-room lane.
- The `yazelix` meta peer points to an in-root symlink so meta/GitKB discovery
  can use a safe path while the real checkout remains in the workspace sibling
  repo at `/home/flexnetos/FlexNetOS/src/yazelix`.
- `.gitkbignore` excludes `yazelix` from root code indexing. Without that,
  GitKB follows the symlink and fails prune with absolute Yazelix paths that are
  not normalized relative to the root KB.
- GitKB is local-first in this workspace. Durable KB state is shared through
  normal Git/GitHub by tracking `.kb/store` and reviewed GitKB files in the
  owning repo. GitKB cloud sync is optional and not required for FlexNetOS local
  work.

## Release Binary Contract

The clean-room workspace has 14 `.meta.yaml` peer repos, but not all peers are
installed binaries. The expected FlexNetOS release binary surface is:

- `meta_cli` -> `meta`
- `meta_git_cli` -> `meta-git`
- `meta_project_cli` -> `meta-project`
- `meta_mcp` -> `meta-mcp`
- `meta_rust_cli` -> `meta-rust`
- `loop_cli` -> `loop`

Library and protocol crates such as `loop_lib`, `meta_core`, `meta_git_lib`,
and `meta_plugin_protocol` explain part of the repo-count/bin-count difference.
The actionable release defect is that upstream packaging omits `meta-rust`.

## Validation Lanes

- GitKB: `git-kb status --json`, `git-kb list --path context/ --json`,
  `git-kb verify`, and `git-kb doctor`.
- GitKB code intelligence:
  `git-kb code index --force --prune --branch codex/clean-room-foundation-base-20260628`,
  `git-kb code stats --json`, `git-kb code doctor --json`, and
  `git-kb code callers <symbol>`.
- Meta repo shape: branch/HEAD/remote/dirty status plus `.meta.yaml` and
  `Cargo.toml` agreement.
- Installed upstream meta proof: `meta --version`, `meta project check`, and
  `meta exec -- <command>` prove installed runtime behavior only.
- FlexNetOS release proof requires a source build plus archive/installer checks
  that include `meta-rust`.
