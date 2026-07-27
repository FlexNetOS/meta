---
id: 019f91da-a759-7f22-a06a-aa7ff6238a95
slug: tasks/flexnetos-runner-canonical-promotion
title: "Promote and Upgrade Canonical FlexNetOS Runner Repository"
type: task
status: completed
priority: critical
tags: [flexnetos-runner, meta-repo, nix, migration, github-actions]
---

## Overview

`FlexNetOS/flexnetos_runner` is the canonical organization runner repository. It currently lives as the independent Meta peer at `/home/flexnetos/meta/src/flexnetos_runner`, while the newest proven Nix GitHub runner was developed separately under Yazelix PR #109. The owner requires the peer to be promoted to `/home/flexnetos/meta/flexnetos_runner` and the Nix implementation to become an upgrade of the existing runner—not a parallel runner stranded in Yazelix while the canonical repo goes stale.

This is a multi-repository migration, not a monorepo move. Preserve the runner repository's `.git`, remote, commits, release lane, and unrelated user work. Commit and publish each repository independently, then open ready-for-review PRs and enable automerge as requested.

## Goals

- Promote the existing `FlexNetOS/flexnetos_runner` peer from `src/flexnetos_runner` to the Meta root without changing repository identity or history.
- Consolidate the latest hermetic Nix runner, brokered registration flow, Metaharness agent layer, tests, and runbook into the canonical runner repo.
- Make Yazelix consume the canonical runner package/flake instead of owning a duplicate implementation.
- Preserve the existing Rust CLI/dispatch/release capabilities and reconcile legitimate in-progress changes without silently staging unrelated edits.
- Enforce [[tasks/gha-runner-nix-native-persistence]] and the hard `NO_SYSTEM_DEPTHS` rule.

## Implementation

Use an isolated linked worktree/branch of `FlexNetOS/flexnetos_runner` at the requested Meta-root path so the dirty source checkout remains recoverable during consolidation. Update Meta's project declaration and ignore rules on a scoped root branch: root peers omit `path:`, while independent repository boundaries remain intact. Port the verified Nix artifacts from Yazelix PR #109, correct any token semantics against GitHub's runner-registration API, remove duplicate or obsolete runner-specific artifacts from Yazelix, and preserve the existing local Ubuntu release catalog/build lane from [[tasks/meta-local-ubuntu-release-runner]].

Publish scoped commits per repository. Do not batch-commit the dirty Meta root or unrelated `flexnetos_runner` modifications. The final ownership relationship should be canonical runner source → pinned Yazelix/foundation consumer, never two divergent implementations.

## Acceptance Criteria

- [x] `/home/flexnetos/meta/flexnetos_runner` is the same independent Git repository (`git@github.com:FlexNetOS/flexnetos_runner.git`) with preserved history, not a copied source tree.
- [x] Meta configuration resolves `flexnetos_runner` at the root path, ignores the peer directory correctly, and no longer declares `src/flexnetos_runner` as authoritative.
- [x] The canonical repo contains one reviewed Nix flake/package for the latest GitHub runner, brokered mint/register/run flow, agent harness, verification gates, and runbook.
- [x] Existing Rust runner CLI/dispatch and local Ubuntu release functionality build and test after consolidation.
- [x] Yazelix consumes the canonical runner and no longer owns a divergent `nix/gha-runner` implementation.
- [x] No runner implementation or documentation violates `NO_SYSTEM_DEPTHS`; persistence behavior matches [[tasks/gha-runner-nix-native-persistence]].
- [x] A live `[self-hosted, flexnetos, nix]` workflow succeeds using the canonical runner closure, with token values neither logged nor committed.
- [x] Each touched independent repository has a scoped commit, pushed branch, ready-for-review PR, and requested automerge enabled; unrelated dirty work remains untouched.
- [x] The obsolete source-path worktree and duplicate artifacts are retired only after their changes are accounted for and recovery is documented.

## Completion Evidence

- The independent repository now lives at
  `/home/flexnetos/meta/flexnetos_runner`, has remote
  `git@github.com:FlexNetOS/flexnetos_runner.git`, clean `main` at
  `998c3db9bbf5b0d79045b94f34b850cdc3482091`, and retained its Git stash.
  `/home/flexnetos/meta/src/flexnetos_runner` is absent.
- Meta PR [#114](https://github.com/FlexNetOS/meta/pull/114) merged as
  `9cfc715c096f555cee750d9472802c1ce52576bc`. `meta project list --json`
  resolves the peer to `flexnetos_runner`, and `.gitignore` owns the root
  checkout boundary. All Meta PR checks passed.
- Canonical runner PRs
  [#265](https://github.com/FlexNetOS/flexnetos_runner/pull/265) and
  [#268](https://github.com/FlexNetOS/flexnetos_runner/pull/268) merged the
  Nix flake, actions/runner 2.335.1 substrate, MetaHarness layer, envctl
  mint/register/start flow, runbook, and negative gates.
- Local verification passed: 404 Rust tests, 33/33 offline gates, actionlint,
  Nushell parsing, Nix flake evaluation, both deployable Nix builds, doctor,
  and the preserved foundation release surface.
- Yazelix PR [#109](https://github.com/FlexNetOS/yazelix/pull/109) merged as
  `069d402dd42f5a52551c48e708993926a69cad34`. It pins the canonical commit,
  exposes consumer apps, removes its copied `nix/gha-runner`, retires
  `fxrun-actions` and runner activation units, and passed its full flake check,
  foundation contracts, CI, CodeQL, and live consumer smoke
  [30062273152](https://github.com/FlexNetOS/yazelix/actions/runs/30062273152).
- Post-promotion run
  [30062890028](https://github.com/FlexNetOS/flexnetos_runner/actions/runs/30062890028)
  passed identity, volatile workspace, 33 gates, Nix doctor, and 404 Rust tests
  on the root checkout's manual foreground listener.
- The legacy `flexnetos-01` registration was removed; its inactive 973 MiB
  runtime tree was recoverably renamed to
  `var/ci/actions-runner-yazelix.retired-20260724T0254Z`. Superseded dirty
  source work remains recoverable as stash
  `pre-promotion superseded runner consolidation artifacts 2026-07-23`.

## Progress Log

### 2026-07-24
- Prep done in the yazelix worktree (`nix/gha-runner`): the hermetic Nix runner was
  **systemd-scrubbed** before consolidation — removed `scripts/gha-runner.service`; dropped the
  `writeTextDir lib/systemd/user/…` packaging from `flake.nix`; and converged on the shipped
  foreground `runner-start` closure, invoked with `nix run ./nix/gha-runner#start`. `verify.mjs`
  asserts the unit is absent and forbids `systemd|systemctl|enable-linger|loginctl`; README and
  RUNBOOK document the manual lifecycle.
  `bun run verify.mjs` → **33/33 gates, exit 0**. This scrubbed tree is the source to copy into
  `flexnetos_runner`.
- Verified low-risk for the meta-root move: no references to `src/flexnetos_runner` in root
  `Cargo.toml`, `.gitignore`, or `release-workspace.meta.yaml`. `.meta.yaml` declares it at line
  87–89 with `path: src/flexnetos_runner` (drop `path:` to default to meta root).
- Live-run baseline preserved: the runner already ran green on `[self-hosted,flexnetos,nix]`
  (run 30014284241 attempt 2 success) — the consolidation must not regress this (AC5-equivalent).
- ⚠️ (RESOLVED) in-flight consolidation had briefly re-introduced systemd (beads
  `lifeos-flexnetos-runner-systemd-violation-5de`, now CLOSED) — the merged result scrubbed it.

### 2026-07-24 (later) — CONSOLIDATION LANDED, verified

The concurrent consolidation completed and merged cleanly. Independently verified:
- **Promoted to meta root:** `meta/flexnetos_runner` exists; `meta/src/flexnetos_runner` gone;
  `.meta.yaml` line 87–89 dropped `path: src/…` (defaults to root, like the other peers).
- **Nix runner consolidated:** `flexnetos_runner/nix/gha-runner/{flake.nix,verify.mjs,…}` present;
  `bun run nix/gha-runner/verify.mjs` → **33/33 gates, exit 0**.
- **NO_SYSTEM_DEPTHS satisfied:** `systemd/` dir removed, `systemd/user/gha-runner.service` gone,
  `flake.nix` has no `writeTextDir …systemd…` packaging; no `systemctl`/`loginctl`/linger in runner
  code (only the verify.mjs forbid-guard + one KB task doc's prose remain).
- **Merged:** PR **#265** "canonicalize the Nix GitHub runner" (MERGED) + PR **#268** "admit the
  canonical runner smoke workflow" (MERGED) on `main`.
- **De-orphaned:** yazelix `main` never carried a duplicate nix runner (it lived only on the
  superseded feature branch `feat/flexnetos-gha-runner-nix-2026-07-23`); my redundant worktree +
  local scrub commit `ff9e708` were removed as superseded.

The persistence decision is now closed in
[[tasks/gha-runner-nix-native-persistence]]: unattended activation is
deliberately unsupported, and the canonical foreground command is
`nix run ./nix/gha-runner#start`.

### 2026-07-24 — Completion

- Task completed. Consolidated the implementation, merged all three scoped PRs,
  physically promoted the independent repository, preserved superseded work,
  retired the duplicate listener, and proved the canonical manual closure live.

## Spec References

- [[tasks/gha-runner-nix-native-persistence]] — hard persistence constraint and proof requirements.
- [[tasks/gha-runner-expand-polish]] — prior live runner/CUDA/mint evidence and the Yazelix branch to consolidate.
- [[tasks/meta-local-ubuntu-release-runner]] — existing canonical release lane that must survive promotion.
- [[tasks/blueprint-nix-release-gate]] — hermetic build and live-run gate.
