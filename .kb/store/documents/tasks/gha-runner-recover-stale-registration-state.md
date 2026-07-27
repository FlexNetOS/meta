---
id: 019f9288-c1de-73e3-8be9-9e3bdc6fbd0e
slug: tasks/gha-runner-recover-stale-registration-state
title: "Recover Canonical Runner from Stale Registration State"
type: task
status: active
priority: medium
tags: [gha-runner, reliability, registration, recovery, gap-hunt]
---

## Overview

Replace the local-file-presence registration heuristic with a bounded lifecycle that can distinguish healthy reusable state from partial, revoked, or server-deleted registration.

## Observed Evidence

`cmd-is-registered` returns success whenever both `.runner` and `.credentials` exist. `runner-start.nu` then skips mint/register. GitHub-side runner deletion, revoked credentials, partial configuration, or copied stale files all satisfy this check but make `Runner.Listener` fail authentication. The current runbook calls file presence “valid” and documents no automatic repair.

## Implementation Plan

1. Define a non-secret registration health probe using supported actions/runner behavior and/or a minimal authenticated org lookup.
2. Model states explicitly: absent, partial, healthy, stale, active/concurrent, and unrecoverable.
3. Reuse healthy state without minting; remove/replace only proven stale state and permit one bounded re-registration attempt.
4. Add a lock/process-identity fence so concurrent foreground starts do not race the same credentials.
5. Document manual recovery and preserve token redaction.

## Acceptance Criteria

- [ ] Healthy state is reused without minting a new registration token.
- [ ] Partial local files fail health and are repaired or rejected before listener launch.
- [ ] A fixture simulating server-side deletion/revocation re-registers exactly once and reaches readiness.
- [ ] Repair failure exits nonzero without looping, deleting unrelated state, or printing tokens.
- [ ] Two concurrent starts cannot both mutate/use one state directory.
- [ ] Runbook recovery steps match tested state transitions.

## Tracking

- Beads: `lifeos-runner-recover-stale-registration-edc`
- Related lifecycle decision: [[tasks/gha-runner-nix-native-persistence]]