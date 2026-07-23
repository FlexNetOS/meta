---
id: 019f2174-4ed5-7a53-88fe-1c223884fe9e
slug: tasks/meta-docs-architecture-workspace-version-drift
title: "Update architecture overview workspace version snippet"
type: task
status: completed
priority: medium
tags: [docs, architecture, version]
---

# Summary

`docs/architecture_overview.md` embeds the actual root workspace `Cargo.toml` shape but shows workspace package version `0.1.0`, while the current root workspace package version is `0.2.22`.

# Source Evidence

- `docs/architecture_overview.md` shows `[workspace.package] version = "0.1.0"` in the root workspace example.
- Root `Cargo.toml` has `[workspace.package] version = "0.2.22"`.
- The architecture doc otherwise lists the current `meta_rust_cli` member, so this appears to be stale version documentation rather than a generic example.

# Acceptance Criteria

- Update the architecture overview workspace snippet to match the current root workspace version or replace the literal with guidance that avoids version drift.
- Add a docs validation check if workspace snippets are expected to mirror root `Cargo.toml`.
