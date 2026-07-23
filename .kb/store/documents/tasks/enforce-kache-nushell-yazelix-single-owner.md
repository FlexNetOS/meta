---
id: 019f5f00-e89d-7fb0-acd9-1f9beac2caf0
slug: tasks/enforce-kache-nushell-yazelix-single-owner
title: "Enforce Kache, Nushell, and single Yazelix owner"
type: task
status: active
priority: critical
tags: [lifeos, planning-spine, envctl, yazelix, kache, nushell, repository-hygiene]
---

# Overview

Enforce the owner-directed runtime and repository contract across the FlexNetOS fleet. Kache is the only cache, agent shell execution is Nushell-only unless the owner explicitly authorizes an emergency fallback, and one profile-owned Yazelix installation owns binaries, runtime, and active configuration.

This task also records and governs the required TDD research, LifeOS Planning Spine task integration, envctl `agent-env` coverage, worktree-cleanup coverage, and complete branch/stash/PR synchronization without cherry-picking.

## Goals

- Establish executable tests and proof for Kache-only caching, Nushell-only agent shell use, and the single Yazelix/Nix profile ownership model.
- Add the canonical implementation task(s) to `meta/src/lifeos/planning-spine-v0` and ensure they enter its graph/ledger rather than an untracked draft surface.
- Ensure envctl `agent-env` and repo-owned worktree cleanup explicitly carry the task and its acceptance gates.
- Publish all valuable stash, branch, and worktree changes through normal commits and PRs; merge without cherry-picking; synchronize and clean the fleet.

## Acceptance Criteria

- [ ] TDD research identifies current tests, failure cases, owners, and exact red/green verification commands before implementation.
- [ ] Planning Spine contains canonical active task records for the full contract, connected to its task graph and proof ledger.
- [ ] envctl `agent-env` includes the task, enforcement policy, and verification gates.
- [ ] Worktree cleanup includes detection and safe settlement of stashes, dirty worktrees, merged branches, and stale worktrees.
- [ ] Kache is the only configured cache and no agent/workspace path activates a competing cache.
- [ ] Agent shell execution is Nushell-only; fallback shells remain unavailable unless the owner explicitly authorizes an emergency.
- [ ] One profile-owned Yazelix installation owns binaries, generated runtime, and active configuration, with stale shadows removed.
- [ ] Every in-scope repo has all valuable changes committed, pushed through PRs, merged without cherry-picking, and its origin/default/develop branches synchronized where those branches exist; merged branches and obsolete worktrees are purged.

## Context

- Owner directive received 2026-07-14 in Codex goal session `019f5ddf-29c4-7722-8121-a043ab49fa7a`.
- Active profile frontdoor: `/home/flexnetos/.nix-profile/bin/yzx`.
- Repository-reviewed Yazelix, Codex, and Claude inputs are packaged by Nix; installed binaries/configuration resolve through `/home/flexnetos/.nix-profile`; mutable process state is reached only through `/home/flexnetos/.nix-profile/runtime` and its owner-controlled volatile target.
- Canonical repositories are independent Meta peers under `/home/flexnetos/meta/src`.
- `/home/flexnetos/.codex/RULES.md` is required by the home contract but was absent when this task began; restoring it through its owning source is part of the tracked proof gap.
- Existing GitKB workspace changes must be preserved and settled; do not discard them as stale.

## Progress Log

### 2026-07-14

- Created the task before code exploration as required by GitKB process discipline.
- Confirmed the durable Codex rules path is currently absent and must not be replaced from retired mirrors.

### 2026-07-20 owner correction and Yazelix implementation

- Superseded every earlier generated-home ownership statement: `/home/flexnetos/.nix-profile` is the sole installed binary, configuration, launcher, state, cache, and runtime frontdoor for Yazelix, Codex, and Claude.
- Yazelix commit `68137971` adds profile-owned Codex and Claude wrappers, an exact volatile runtime link, fail-closed owner checks, standard profile desktop ownership, source guards, migration contracts, and focused recovery/materialization tests.
- Full Nix flake evaluation, all 14 flake checks, both profile builds, actionlint, Rust formatting, and patch whitespace verification pass. Merge, installed cutover, stale-shadow purge, and fleet propagation remain active acceptance gates.

## Completion Evidence

To be populated with task identifiers, PR URLs, merge commits, test receipts, clean-worktree proof, synchronized branch heads, and final fleet status.
