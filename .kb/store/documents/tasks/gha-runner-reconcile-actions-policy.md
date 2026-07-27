---
id: 019f9288-be4e-7543-b59b-1821aabd336d
slug: tasks/gha-runner-reconcile-actions-policy
title: "Reconcile Runner Workflows with Selected-Action Policy"
type: task
status: active
priority: high
tags: [gha-runner, github-actions, ci, release-gate, gap-hunt]
---

## Overview

Make every active `FlexNetOS/flexnetos_runner` workflow admissible under the repository's selected-action policy and turn startup failures into a blocking release signal.

## Observed Evidence

The repository API reports `allowed_actions=selected`, `github_owned_allowed=false`, and only two admitted patterns: the exact `actions/checkout@34e114...` SHA and `hustcer/setup-nu@ccd5...`. Default-branch workflows still reference `actions/checkout@v6`, `dtolnay/rust-toolchain@stable`, and `actions/upload-artifact@v7`. Runs `30061846949` (CI), `30064924565` (Runner Sustain), and `30064662184` (Runner Black Factor Watch) completed as `startup_failure` with zero jobs. PR #268 repaired only Runner Smoke.

## Implementation Plan

1. Enumerate every `uses:` reference in active and reusable workflows.
2. Resolve each reference to an immutable reviewed SHA, or expand selected-action policy only where a minimal, documented exception is required.
3. Add a deterministic workflow-policy parity checker that consumes both workflow refs and the expected selected-action manifest.
4. Make release/promotion evidence reject `startup_failure`, missing job creation, and skipped required workflow files.
5. Dispatch representative push, schedule, and manual paths after policy convergence.

## Acceptance Criteria

- [ ] Every default-branch `uses:` reference is immutable and admitted by the selected-action policy.
- [ ] CI validates workflow refs against a tracked expected policy and fails on an unadmitted ref.
- [ ] CI, Runner Sustain, and Runner Black Factor Watch create jobs and no longer conclude `startup_failure`.
- [ ] Codex Forge Loop and Agentic System Watch parse and create jobs when their explicit owner gates are enabled in a safe test.
- [ ] Evidence includes policy patterns, run IDs, head SHAs, and conclusions without secrets.

## Tracking

- Beads: `lifeos-runner-reconcile-actions-policy-hx9`
- Follow-up to [[tasks/flexnetos-runner-canonical-promotion]]