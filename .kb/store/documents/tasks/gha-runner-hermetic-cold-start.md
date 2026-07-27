---
id: 019f9288-c123-7173-ada2-453f882be216
slug: tasks/gha-runner-hermetic-cold-start
title: "Make Canonical Runner Cold Start Closure-Complete"
type: task
status: active
priority: high
tags: [gha-runner, nix, envctl, cold-start, path-law, gap-hunt]
---

## Overview

Close the gap between the documented one-closure cold-start contract and the current mutable home-profile dependency, then activate the merged consumer closure on the promoted host.

## Observed Evidence

- `mkRunnerStart` exports `PATH="$HOME/.nix-profile/toolbin:$HOME/.nix-profile/bin:..."` before calling the mint script.
- `mint-runner-token.nu` resolves `secretctl` from that PATH unless `SECRETCTL_BIN` is injected.
- The active `/home/flexnetos/.nix-profile` currently has no `secretctl`, `envctl`, or `flexnetos-runner-start`.
- Yazelix commit `069d402d` packages those artifacts into a new foundation closure, but that output is not the active profile generation.
- Existing profile-runtime credentials bypass mint, so the successful live smoke did not exercise a post-reboot/cold-state start.

## Implementation Plan

1. Choose an exact dependency contract: either add a pinned envctl/secretctl package input to the start closure or have the Yazelix consumer wrap start with an exact `SECRETCTL_BIN` store path.
2. Remove mutable home-profile PATH lookup from the canonical start boundary.
3. Add an offline cold-state preflight and fake-minter/substrate integration test.
4. Build and atomically activate the merged Yazelix foundation with a recorded rollback generation.
5. Exercise a safe isolated cold registration sequence under owner control.

## Acceptance Criteria

- [ ] Every executable used before `Runner.Listener` resolves to an exact Nix store path from the supported consumer closure.
- [ ] A clean environment with empty mutable PATH reaches the intended vault-locked or fake-minter result, never “secretctl not found.”
- [ ] The active profile exposes `secretctl`, `envctl`, and `flexnetos-runner-start` from one reviewed generation with rollback evidence.
- [ ] A test starts from absent `.runner/.credentials`, registers, and reaches listener readiness without logging tokens.
- [ ] Existing-state smoke and cold-state proof are separate release gates.
- [ ] `NO_SYSTEM_DEPTHS` remains satisfied.

## Tracking

- Beads: `lifeos-runner-hermetic-cold-start-ips`
- Reopens an unproven acceptance claim in [[tasks/gha-runner-nix-native-persistence]]