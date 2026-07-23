---
id: 019f2142-57d4-7543-9adf-f8326254055d
slug: context/extensible/tech
title: "Tech Context"
type: context
status: draft
priority: medium
---

# Tech Context

## Languages and Tooling

- Rust workspace with edition 2021 and workspace package version 0.2.22.
- Stable Rust toolchain via `rust-toolchain.toml`.
- Cargo workspace members are independent child repos cloned into root for local builds.
- Bats integration tests exercise CLI behavior.
- Commitlint enforces conventional commit subjects and semantic PR titles.

## Main Commands

- Build root convenience workspace: `cargo build --workspace`.
- Test root convenience workspace: `cargo test --workspace` or Makefile nextest target.
- Run Bats tests after building: `bats tests/*.bats`.
- Inspect workspace: `meta project list --json`.
- Cross-repo arbitrary commands: `meta exec -- <command>`.
- GitKB CLI in this environment: `/home/flexnetos/FlexNetOS/usr/bin/git-kb`.

## GitKB Notes

`.kb/AGENTS.md` documents `git kb` examples, but this shell does not expose `git-kb` on PATH as a Git subcommand. Use the explicit binary path until PATH/subcommand wiring is intentionally fixed outside the clean mirror.

## Automation

- `.github/scripts/clone-child-repos.sh` clones workspace child repositories from `gitkb/*`.
- CI runs workspace cargo checks and Bats tests after cloning children.
- Release workflow builds cross-platform artifacts, publishes crates, and updates Homebrew.

## Source Evidence

Cargo.toml, Makefile, .github/workflows/*.yml, .github/scripts/clone-child-repos.sh, tests/*.bats, .githooks/*, .kb/config.toml.
