---
id: 019f2173-4a3b-79e3-86ed-bebdaeb6c116
slug: tasks/meta-release-workflow-meta-rust-artifact-drift
title: "Include meta-rust in release artifacts and generated Homebrew formula"
type: task
status: completed
priority: high
tags: [release, meta-rust, packaging]
---

# Summary

The release workflow clones `meta_rust_cli` but does not build, package, publish, or install `meta-rust` in release artifacts/Homebrew output the way the Makefile local install flow does.

# Source Evidence

- `.github/workflows/release.yml` clones `meta_rust_cli` in build/publish jobs.
- The same workflow builds and packages `meta`, `meta-git`, `meta-project`, `meta-mcp`, and `loop`, but not `meta-rust`.
- The generated Homebrew formula installs `meta`, `meta-git`, `meta-project`, `meta-mcp`, and `loop`, but not `meta-rust`.
- `Makefile` builds/copies/installs `meta-rust` to `.meta/plugins/meta-rust` and `~/.meta/plugins/meta-rust`.

# Acceptance Criteria

- Include `meta-rust` in release builds, archives/zips, checksum artifacts, and generated Homebrew formula if it is intended as a built-in plugin.
- Publish/install behavior should match the root Makefile and help surface.
- Add release verification coverage for the complete built-in plugin set.
