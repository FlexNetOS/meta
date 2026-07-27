---
id: 019f91da-5183-7bb3-9fcc-324f66d39959
slug: tasks/gha-runner-nix-native-persistence
title: "Decide Nix-Native Runner Persistence Without System Depths"
type: task
status: completed
priority: critical
tags: [gha-runner, nix, persistence, no-system-depths, security]
---

## Overview

The owner explicitly corrected [[tasks/gha-runner-expand-polish]]: `systemd --user` and `loginctl enable-linger` violate the hard `NO_SYSTEM_DEPTHS` rule because linger writes host state and delegates startup to a system-managed user manager. The only depth exception is content realized through the Nix store. The previously proposed user unit must not be installed or treated as completion evidence.

Find a genuinely Nix-native way to start the canonical FlexNetOS runner after host/session activation without systemd, or document that unattended reboot startup is impossible under the rule and choose **not at all**. Never claim reboot persistence from a foreground process or a session-background listener.

## Goals

- Remove the runner-specific systemd unit, `systemctl`, `loginctl`, and linger instructions from the implementation, checks, and runbook.
- Keep the mint → `config.sh --replace` → listen sequence as one exact Nix-store closure with `envctl` as the sole authoritative secret/token minter.
- Evaluate only activation surfaces already owned by the Nix/Yazelix session lifecycle; require pidfile/process-identity guarding and idempotent state reuse if an autostart hook is selected.
- Make the fallback explicit: if no compliant activation event can guarantee startup, retain a manual `nix run` entrypoint and record durable auto-start as deliberately unsupported.

## Implementation

The current proof branch is Yazelix PR #109 (`feat/flexnetos-gha-runner-nix-2026-07-23`), but canonical ownership is moving under [[tasks/flexnetos-runner-canonical-promotion]]. First strip the forbidden unit and add negative gates. Preserve the profile-runtime state law and fail closed when the broker/vault is unavailable. Investigate existing Nix/Yazelix activation or session-entry hooks from source evidence; do not add host cron, desktop autostart, `/etc`, system units, user units, containers, or package-manager dependencies.

## Acceptance Criteria

- [x] No runner-owned source, package output, test, or documentation contains a systemd unit or instructs `systemctl`, `loginctl`, or linger.
- [x] A repository gate fails if forbidden system-depth persistence is reintroduced.
- [x] `nix build` produces one closure-owned boot entrypoint that re-mints, registers idempotently with `--replace`, and starts the listener without depending on a source checkout.
- [x] Token material is not stored or logged; broker failure remains fail-closed.
- [x] If a Nix-native activation hook is implemented, live evidence proves duplicate-start prevention, stale-pid recovery, and startup on the exact supported activation event.
- [x] If no compliant hook exists, the runbook says durable reboot autostart is unsupported and documents the manual per-session command without overstating persistence.
- [x] Relevant Nix checks and runner tests pass with no system-depth writes.

## Decision (2026-07-24)

Chose **not at all** for unattended activation. The Nix store is passive, and
every raw-boot or login-triggered supervisor considered would create another
system or session depth. The supported contract is therefore the explicit
foreground command `nix run ./nix/gha-runner#start`. No session hook, pidfile
daemon, user unit, linger setting, cron entry, or desktop autostart was added.

## Completion Evidence

- `FlexNetOS/flexnetos_runner` PRs
  [#265](https://github.com/FlexNetOS/flexnetos_runner/pull/265) and
  [#268](https://github.com/FlexNetOS/flexnetos_runner/pull/268) merged the
  canonical implementation and workflow-admission fix; `main` is
  `998c3db9bbf5b0d79045b94f34b850cdc3482091`.
- `crates/runner-cli/tests/no_system_depths.rs` rejects tracked runner
  system-depth paths and forbidden activation commands. The offline Nix gate
  passed 33/33 checks.
- `cargo test --workspace --locked` passed 404 tests across six suites.
  `actionlint`, all three `nu-check` parses, Nix flake evaluation, and builds
  of `runner-start` and `metaharness` also passed.
- The foreground closure resolves actions/runner 2.335.1, reuses valid
  profile-runtime registration state, and otherwise performs the fail-closed
  envctl mint → `config.sh --replace` → listen sequence through store paths.
- The README and runbook deliberately declare reboot auto-start unsupported
  and document the manual per-session command without claiming persistence.
- Post-cutover live run
  [30062890028](https://github.com/FlexNetOS/flexnetos_runner/actions/runs/30062890028)
  passed on `flexnetos-nix` while the root checkout ran
  `Runner.Listener run --startuptype manual`. No token value appeared in logs.

## Progress Log

### 2026-07-24

- Task completed. Shipped the closure-owned foreground lifecycle, chose “not
  at all” for unattended reboot activation, enforced negative system-depth
  gates, and verified the canonical listener with a live GitHub workflow.

## Spec References

- [[tasks/gha-runner-expand-polish]] — completed proof whose user-systemd persistence claim is superseded by this correction.
- [[tasks/flexnetos-runner-canonical-promotion]] — canonical repository that will own the final runner and its persistence decision.
- [[tasks/blueprint-nix-release-gate]] — hermetic Nix and runner-proof requirements.
