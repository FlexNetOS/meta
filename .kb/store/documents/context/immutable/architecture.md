---
id: 019f2142-140b-7eb0-aa8a-52e09c876296
slug: context/immutable/architecture
title: "Architecture"
type: architecture
status: draft
priority: medium
---

# Architecture

## Workspace Shape

Root `gitkb/meta` is a meta-repo containing configuration, docs, release automation, tests, hooks, Claude assets, and a convenience Cargo workspace. The real implementation crates live in independent child repositories listed in `.meta.yaml`.

## Child Repositories

Foundation crates:
- `loop_lib` provides `loop-lib`.
- `meta_plugin_protocol` provides `plugin-protocol`.
- `meta_core` provides `meta-core`.
- `meta_git_lib` provides `meta-git-lib`.

Mid-level crates:
- `loop_cli` depends on `loop-lib`.
- `meta_cli` provides `meta-cli` and depends on `meta-core`, `plugin-protocol`, and `loop-lib`.

Top-level crates:
- `meta_git_cli` depends on `plugin-protocol`, `meta-git-lib`, `meta-cli`, and `loop-lib`.
- `meta_project_cli` depends on `plugin-protocol`, `meta-cli`, and `meta-git-lib`.
- `meta_rust_cli` depends on `plugin-protocol` and `meta-cli`.
- `meta_mcp` depends on `meta-cli`.

Standalone/non-code repos are `agent`, `claude-plugins`, `codex-plugins`, and `meta-plugins`.

## Runtime Flow

`meta` parses CLI arguments, reads `.meta.yaml`, applies filters, discovers plugins, and either routes to a plugin or runs arbitrary commands through the loop engine with `meta exec --`.

## Automation Surface

- CI clones child repos and runs workspace tests, clippy, format, and Bats integration tests.
- Release workflow builds platform artifacts and updates crates/Homebrew, but the active task records a `meta-rust` packaging gap to resolve.
- GitKB is the database-first knowledge system; `.kb/workspaces` is an ignored editing surface.

## Source Evidence

.meta.yaml, Cargo.toml, README.md, docs/architecture_overview.md, .github/workflows/*.yml, .kb/AGENTS.md.
