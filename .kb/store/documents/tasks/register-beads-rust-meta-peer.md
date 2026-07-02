---
id: 019f20d9-db2e-7621-a2b3-403c5feefd71
slug: tasks/register-beads-rust-meta-peer
title: "Register beads_rust as meta peer"
type: task
status: completed
priority: medium
---

# Overview

Register the `FlexNetOS/beads_rust` repository as a Meta-managed child
repository in the clean-room `FlexNetOS/meta` workspace.

## Goals

- Add `beads_rust` to `.meta.yaml` with the full FlexNetOS registry remote.
- Ignore the child repository path in the meta repo root `.gitignore`.
- Use the installed `meta` control-plane commands to materialize and verify the
  registered repo.

## Acceptance Criteria

- [x] `.meta.yaml` includes `beads_rust` pointing to
  `git@github.com:FlexNetOS/beads_rust.git`.
- [x] `.gitignore` ignores `beads_rust`.
- [x] `/home/flexnetos/FlexNetOS/src/meta/beads_rust` exists on disk as an
  independent Git checkout of `FlexNetOS/beads_rust`.
- [x] `meta project list --json` includes `beads_rust`.
- [x] `meta project check` reports all projects cloned and present.

## Verification

- `meta project list --json`: includes `beads_rust` with path `beads_rust`
  and repo `git@github.com:FlexNetOS/beads_rust.git`.
- `meta project check`: all projects are cloned and present.
- `meta --include beads_rust exec -- git status --short --branch`: clean on
  `main...origin/main`.
- `meta --include beads_rust exec -- git remote get-url origin`:
  `git@github.com:FlexNetOS/beads_rust.git`.
- `meta --include beads_rust exec -- git rev-parse HEAD`:
  `2498339168b8e88d641e8ae1664843fc69740012`.
- `meta --include beads_rust exec -- test -d .beads`: passed.
