---
id: 019f9288-c28f-7b62-b4fa-5c89f8215bf6
slug: tasks/gha-runner-align-codex-auth-runtime
title: "Align Forge Loop Codex Auth with Profile Runtime"
type: task
status: active
priority: medium
tags: [gha-runner, codex, path-law, authentication, gap-hunt]
---

## Overview

Move the rerouted Forge Loop to the authoritative Codex auth location instead of the retired home compatibility path.

## Observed Evidence

- `.github/workflows/codex-forge-loop.yml` sets `CODEX_HOME=/home/flexnetos/.codex` and explicitly exits when `auth.json` is missing.
- `runner-cli/src/forge_loop.rs` uses the same path as `DEFAULT_CODEX_HOME`.
- `/home/flexnetos/.codex/auth.json` is absent on the promoted host.
- The active credential is mode 0600 under `/run/user/1001/yazelix/profile-runtime/codex/auth.json`.
- Historical Forge Loop runs succeeded on the retired runner environment; the canonical listener does not recreate that home path.

## Implementation Plan

1. Define one Yazelix/profile-runtime derivation for `CODEX_HOME` that does not hardcode a UID.
2. Inject it at the canonical runner/Forge Loop boundary and use it in runner-cli readiness artifacts.
3. Remove active home-path assumptions without copying credential content.
4. Add negative path-law and missing-auth tests.
5. Run owner-approved preflight after workflow action admission is restored.

## Acceptance Criteria

- [ ] Workflow, runner-cli, and listener agree on the same authoritative `CODEX_HOME`.
- [ ] The path is derived from the supported runtime contract rather than a numeric UID or home compatibility tree.
- [ ] Missing/empty auth fails before Codex invocation with no credential content in logs.
- [ ] `rtk codex login status` and the file readiness check pass on `flexnetos-nix` in an owner-approved run.
- [ ] Tests reject reintroduction of `/home/flexnetos/.codex` on active Forge Loop surfaces.

## Tracking

- Beads: `lifeos-runner-align-codex-auth-runtime-pyt`
- Follow-up to [[tasks/flexnetos-runner-canonical-promotion]]