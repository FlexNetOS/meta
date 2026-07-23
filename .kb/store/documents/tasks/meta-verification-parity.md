---
id: 019f2144-3063-7612-a5fc-cce9c9136610
slug: tasks/meta-verification-parity
title: "Align local hooks, CI, and release verification"
type: task
status: completed
priority: medium
tags: [ci, tests, verification]
---

# Summary

Define the canonical verification path for `gitkb/meta` and align local hooks, Makefile targets, CI, and release checks so contributors and agents run the same meaningful gates.

# Source Evidence

- CI runs cargo test, clippy, format, and Bats after cloning child repositories.
- The pre-push hook runs fmt/clippy/test but not Bats.
- Makefile test uses nextest while CI uses cargo test.
- No obvious release packaging test asserts that the expected binaries are included in release artifacts.

# Acceptance Criteria

- Document the canonical local verification command sequence.
- Decide whether hooks should include Bats or point to a fuller local/CI target.
- Reconcile Makefile nextest usage with CI cargo test, or document why both exist.
- Add a package/release artifact verification path for expected binaries.
- Record command output evidence in the task before completion.
