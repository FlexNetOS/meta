---
id: 019f2145-7b02-7e41-b514-6c638922295f
slug: tasks/meta-lockfile-version-drift
title: "Resolve Cargo.lock drift from workspace version bump"
type: task
status: completed
priority: high
tags: [cargo, verification, lockfile]
---

# Summary

Clean `cargo build --workspace` against upstream source rewrites `Cargo.lock`. The tracked lockfile still records local workspace packages at `0.2.20`, while the current workspace manifests are `0.2.22`, and dependency resolution adds newer packages required by the checked-out child crates.

# Evidence

During the clean foundation verification on 2026-07-02, `nix shell nixpkgs#cargo nixpkgs#rustc -c cargo build --workspace` completed successfully but modified `Cargo.lock`. The diff changed workspace package versions such as `loop_cli`, `loop_lib`, `meta`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_plugin_protocol`, `meta_project_cli`, `meta_rust_cli`, and `meta-mcp` from `0.2.20` to `0.2.22`, and added resolved packages including `colored 3.1.1`, `console 0.16.4`, `dirs 6.0.0`, `indicatif 0.18.6`, and `thiserror 2.0.18`. The generated lockfile change was restored to keep the upstream mirror clean.

The initial-10 source walk also found child-repo standalone CI workflows synthesizing temporary root `Cargo.toml` files with mismatched `[workspace.package]` versions. Most use `version = "0.1.0"` while `meta_git_cli` uses `version = "0.0.0"`. That can hide version drift between standalone child verification and the root release/workspace version.

# Acceptance Criteria

- Decide whether upstream should update `Cargo.lock` to match the current workspace manifests.
- Decide whether standalone child CI should derive the workspace package version from source instead of hardcoding `0.1.0` or `0.0.0`.
- `cargo build --workspace --locked` succeeds from a clean checkout.
- `cargo test --workspace --locked` succeeds from a clean checkout or has source-backed failures recorded in a separate task.
- The verification workflow uses locked builds/tests where source cleanliness matters.
