---
id: 019f2143-e187-7bf1-af16-652fe2b204a1
slug: tasks/meta-rust-release-packaging
title: "Package meta-rust in release and install flows"
type: task
status: completed
priority: high
tags: [release, packaging, meta-rust]
---

# Summary

Reconcile the built-in `meta-rust` plugin with release and install packaging. The source scan found README/docs/.meta/Makefile/live plugin references showing the Rust plugin exists, while install and release artifacts appear to omit it.

# Source Evidence

- README/docs list `meta rust` as a built-in plugin surface.
- `.meta.yaml` declares `meta_rust_cli`.
- The release workflow clones `meta_rust_cli` but does not appear to build/package/publish a `meta-rust` artifact.
- install scripts and Homebrew packaging appear to install `meta`, `meta-git`, `meta-project`, and `meta-mcp` without `meta-rust`.

# Acceptance Criteria

- Decide whether `meta-rust` is intentionally shipped or intentionally excluded.
- If shipped, release workflow builds, packages, and publishes the `meta-rust` binary.
- Install scripts and Homebrew formula install the expected `meta-rust` artifact.
- A release/package verification check asserts the expected binary set.
- Docs match the implemented packaging behavior.
