---
id: 019f9288-bf02-7291-ba31-f1130da8abb1
slug: tasks/gha-runner-complete-fleet-label-cutover
title: "Complete Canonical Runner Label Cutover Across the Fleet"
type: task
status: active
priority: high
tags: [gha-runner, github-actions, nu-plugin, fleet, migration, gap-hunt]
---

## Overview

Finish the organization-wide migration from the retired `self-hosted,linux,x64,local,flexnetos` selector to the canonical `self-hosted,flexnetos,nix` contract before relying on the single promoted runner.

## Observed Evidence

- The live organization API lists only `flexnetos-nix` with labels `self-hosted`, `Linux`, `X64`, `flexnetos`, and `nix`.
- `FlexNetOS/nu_plugin` default branch still requests `["self-hosted","linux","x64","local","flexnetos"]` for `truth_surface` and `rust`.
- Those jobs previously ran on legacy `fxrun-...` registrations, which were retired during promotion.
- `runner-cli` now classifies only the new label set as local, so a queued legacy-label job is categorized as nonlocal rather than stranded local capacity.

## Implementation Plan

1. Query every FlexNetOS default branch for self-hosted selectors and build a migration ledger.
2. Change `nu_plugin` and any newly discovered active selectors to the canonical contract, preserving hosted fallback for fork PRs.
3. During transition, teach runner queue audit to identify known retired label sets as stranded/invalid rather than vendor queues.
4. Add a fleet-level contract test against live runner labels and default-branch workflow selectors.
5. Dispatch trusted `nu_plugin` jobs and capture runner assignment.

## Acceptance Criteria

- [ ] No active FlexNetOS default-branch workflow requires `local` or another retired runner-only label.
- [ ] Fork PRs retain GitHub-hosted isolation; trusted push/same-repo jobs select `flexnetos-nix`.
- [ ] Queue audit reports retired-label jobs as migration failures until none remain.
- [ ] `nu_plugin` `Truth surface` and `Rust workspace` both start on `flexnetos-nix`.
- [ ] A repeatable fleet audit compares workflow requirements with live org runner labels and exits nonzero on an unmatched selector.

## Tracking

- Beads: `lifeos-runner-complete-fleet-label-cutover-2rd`
- Follow-up to [[tasks/flexnetos-runner-canonical-promotion]]