---
id: 019f9288-c3f9-7263-adbd-eb9e075ff7b3
slug: tasks/yazelix-mainline-runner-consumer-smoke
title: "Restore Mainline Coverage for the Yazelix Runner Consumer"
type: task
status: active
priority: medium
tags: [yazelix, gha-runner, github-actions, ci, gap-hunt]
---

## Overview

Turn the merged Yazelix canonical-runner consumer smoke from a feature-branch proof into ongoing trusted mainline coverage.

## Observed Evidence

`.github/workflows/flexnetos-runner-smoke.yml` is manually dispatchable, but its automatic `push.branches` list contains only `feat/flexnetos-gha-runner-nix-2026-07-23`. After PR #109 merged, changes to `flake.nix`, `flake.lock`, or the smoke workflow on `main` do not trigger the proof. The final profile-runtime step also prints path existence without asserting it.

## Implementation Plan

1. Replace the retired branch restriction with main and trusted same-repository PR coverage for the existing path filters.
2. Preserve fork isolation and exact action SHA pinning.
3. Convert informational checks into assertions for the canonical app, package, runner identity, and profile-runtime contract.
4. Add the smoke conclusion to runner-consumer promotion evidence.

## Acceptance Criteria

- [ ] Relevant `main` changes automatically create the consumer smoke run.
- [ ] Same-repository PRs can prove the pin before merge; fork PRs never receive the self-hosted runner.
- [ ] The workflow fails when `.#gha-runner`, the canonical package pin, or profile-runtime contract is missing.
- [ ] A post-change run completes on `flexnetos-nix` and records run ID/head SHA/conclusion.
- [ ] No active trigger references the retired feature branch.

## Tracking

- Beads: `lifeos-yazelix-mainline-runner-smoke-8r8`
- Consumer source: [[tasks/flexnetos-runner-canonical-promotion]]