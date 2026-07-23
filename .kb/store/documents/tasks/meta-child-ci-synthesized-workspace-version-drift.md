---
id: 019f2174-7c18-7de3-a96c-3fc6850c4939
slug: tasks/meta-child-ci-synthesized-workspace-version-drift
title: "Align child CI synthesized workspace versions"
type: task
status: completed
priority: high
tags: [ci, version, workspace, alignment]
---

# Summary

Standalone child CI workflows synthesize temporary root `Cargo.toml` files with hardcoded workspace package versions that no longer match the root workspace version.

# Source Evidence

- Root `Cargo.toml` has `[workspace.package] version = "0.2.22"`.
- `loop_cli`, `loop_lib`, `meta_cli`, `meta_core`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_project_cli`, and `meta_rust_cli` CI/auto-format workflows synthesize `[workspace.package] version = "0.1.0"`.
- `meta_git_cli/.github/workflows/ci.yml` and `auto-format.yml` synthesize `[workspace.package] version = "0.0.0"`.
- `meta_git_lib` and `meta_mcp` workflows also write `VERSION` as `0.0.0-ci` in places while other workflows derive it from source.

# Acceptance Criteria

- Decide whether child CI should derive workspace package version from the crate/source under test or from a shared root release source.
- Align all synthesized workspace files with that decision.
- Add a grep/check so future version bumps do not leave standalone child workflows stale.
