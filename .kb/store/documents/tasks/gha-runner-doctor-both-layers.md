---
id: 019f9288-c078-7ea3-9541-9c0f54d79140
slug: tasks/gha-runner-doctor-both-layers
title: "Make Runner Doctor Validate Both Composed Layers"
type: task
status: active
priority: medium
tags: [gha-runner, metaharness, healthcheck, nix, gap-hunt]
---

## Overview

Make `runner doctor` enforce the documented two-layer health contract instead of validating only actions/runner.

## Reproduction

Build the canonical substrate, invoke `scripts/runner.nu doctor` with valid `GHA_SUBSTRATE` but `GHA_BUN=/definitely/missing/bun` and `GHA_HARNESS=/definitely/missing/cli.js`. The command prints `doctor: substrate OK` and exits zero because `cmd-doctor` never resolves or invokes either agent-layer variable. The canonical Runner Smoke workflow relies on this command.

## Implementation Plan

1. Resolve and validate `GHA_BUN` and `GHA_HARNESS` as exact executable/file paths.
2. Invoke the harness doctor through Bun and propagate all failures.
3. Return structured per-layer status suitable for workflow evidence while retaining concise human output.
4. Extend the offline and Nix-closure tests with negative fixtures.

## Acceptance Criteria

- [ ] Missing Bun, missing harness, unreadable harness, and nonzero harness doctor each make the outer doctor fail.
- [ ] A valid built closure reports actions/runner, Bun, kernel, backend, and GitHub Actions host adapter.
- [ ] Runner Smoke exercises this complete doctor and rejects a broken agent package.
- [ ] No doctor path requires or prints registration tokens or provider credentials.

## Tracking

- Beads: `lifeos-runner-doctor-both-layers-40n`
- Related implementation: [[tasks/gha-runner-implement-metaharness-task-dispatch]]