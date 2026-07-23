---
id: 019f22bd-cba6-7093-8146-db540e04db2c
slug: tasks/meta-release-catalog-portable-tools
title: "Catalog portable release components"
type: task
status: completed
priority: high
---

## Overview

Make the local Ubuntu release catalog-driven so the release is a portable FlexNetOS state, not a hand-picked partial bundle. The release catalog must include the Codex Rust binary, GitKB, every meta peer, Yazelix, envctl, flexnetos_runner, and workspace tools currently used by the control plane.

Related: [[tasks/meta-local-ubuntu-release-runner]].

## Acceptance Criteria

- [x] Add a checked-in release catalog that names every current required release component.
- [x] Include Cargo-built source peers and copied binary payloads in the same catalog format.
- [x] Wire `scripts/build-local-ubuntu-release.sh` to use the catalog by default.
- [x] Keep `FXRUN_RELEASE_COMPONENTS` as an optional filter, not the source of truth.
- [x] Include the catalog in release provenance.
- [x] Validate the full catalog with `--check-only`.
- [x] Prove `copy-bin` catalog rows by building a filtered archive for GitKB, Codex, and Bun.

## Progress Log

- 2026-07-02: Added `release/catalog.tsv` with entries for `flexnetos_runner`, `meta`, `meta-agent`, `gitkb`, `codex`, `envctl`, `beads_rust`, `rtk-tokenkill`, `yazelix`, `yazelix-helix`, `nu_plugin`, `loop_lib`, `meta_plugin_protocol`, and `bun`.
- 2026-07-02: Replaced hard-coded component dispatch in `scripts/build-local-ubuntu-release.sh` with catalog parsing for `cargo` and `copy-bin` rows. The script now defaults to all catalog rows and writes `provenance/catalog.tsv` into each staged release.
- 2026-07-02: Full catalog validation passed with `build-local-ubuntu-release.sh --check-only`.
- 2026-07-02: Filtered proof archive for `gitkb codex bun` succeeded at `release/flexnetos-ubuntu-26.04-x86_64-20260702T121553Z.tar.gz`; SHA-256 verification passed and `/nix/store` scan found no matches in the filtered stage.
