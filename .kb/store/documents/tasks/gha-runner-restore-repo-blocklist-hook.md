---
id: 019f9288-bd97-7e82-8b69-9f2df2ce2175
slug: tasks/gha-runner-restore-repo-blocklist-hook
title: "Restore the Canonical Runner Repository Blocklist Hook"
type: task
status: active
priority: high
tags: [gha-runner, security, github-actions, regression, gap-hunt]
---

## Overview

Restore the repository-level operator hold that was disconnected during canonical Nix runner promotion. The standard actions/runner substrate remains correct, but the launch boundary no longer exports the job-start hook, so the retained guard script cannot execute.

## Observed Evidence

- Before `691a661c`, `scripts/install-runner-services.sh` wrote both `ACTIONS_RUNNER_HOOK_JOB_STARTED=<prefix>/scripts/runner-repo-guard.sh` and `FXRUN_REPO_BLOCKLIST=<prefix>/_work/config/runner-blocklist.txt`.
- The canonical `nix/gha-runner/scripts/runner.nu::cmd-run` launches `Runner.Listener` with only `RUNNER_ROOT`.
- The only current references to either hook variable are comments/logic inside `scripts/runner-repo-guard.sh`; the Nix subflake does not package that script.
- The live `flexnetos-nix` runner belongs to the Default group, which is selected for a broad organization repository set, making the operator hold security-relevant.

## Implementation Plan

1. Add the guard to the canonical Nix source closure and pass its exact immutable path to `Runner.Listener`.
2. Choose and document an operator-owned mutable blocklist path compatible with profile-runtime and `NO_SYSTEM_DEPTHS`; preserve the intended missing-file behavior explicitly.
3. Add source and behavioral gates that fail if the script is present but not wired.
4. Exercise a safe test repository through listed and unlisted cases, then restore the operator policy.

## Acceptance Criteria

- [ ] The listener environment contains an exact closure path for `ACTIONS_RUNNER_HOOK_JOB_STARTED` and an explicit blocklist path.
- [ ] A listed repository job is rejected before its first workflow step; an unlisted repository job executes normally.
- [ ] Missing, blank, comment-only, and case-insensitive entries have documented tests.
- [ ] `verify.mjs` or an equivalent release gate detects disconnected hook wiring.
- [ ] Live evidence records only repository/run identifiers and conclusions; no token or credential content is logged.
- [ ] No system/user service, linger, cron, or other system depth is introduced.

## Tracking

- Beads: `lifeos-runner-restore-blocklist-hook-rm8`
- Regression source: [[tasks/flexnetos-runner-canonical-promotion]]