---
id: 019f63b5-e902-7373-bd7c-9f8b9048677e
slug: tasks/archbp-022-gitkb-branch-current
title: "ARCHBP-022: Make GitKB and Meta release isolation branch-current"
type: task
status: active
priority: high
tags: [archbp-022, gitkb, release-isolation, code-index]
---

## Overview

Planning-spine task ARCHBP-022 (phase 13-architecture-blueprint-execution,
parents LPS-023 / NBVERIFY-030). Configure explicit repository discovery
(`[repos]` section in `.kb/config.toml` — currently absent, `git-kb repo list
--json` returns `[]`) and branch-current GitKB code indexes for the release
peers, preserve Meta coordination without monorepo fusion, and prove release
decisions resolve exact repositories and commits.

## Baseline (observed 2026-07-14)

- git-kb 0.2.12 (profile-owned, nix store)
- Meta root KB `/home/flexnetos/meta/.kb`: 1024 rust symbols / 151 files, ALL
  tagged `branch: null` (no repo discovery, so no branch tagging)
- LifeOS (`src/lifeos`) code index: 0 symbols
- `git-kb doctor`: warn `repos.config` — "No [repos] section in .kb/config.toml"
- Federated peers with their OWN `.kb` (must NOT be double-indexed here):
  envctl, nu_plugin, flexnetos_runner, rtk-tokenkill

## Goals

- `[repos]` explicit discovery for the release peer set
- `[code.repo_default_branch_map]` via `git-kb code detect-default-branches`
- Branch-current `--index-only` indexes for meta workspace crates + lifeos,
  with before/after stats receipts
- Release-isolation map: peer → repo → remote → branch → commit → index mode
  (indexed-here / federated / discovery-only)
- Checker + negative tests: fail on empty, stale, wrong-branch, ambiguous
  index states; assert no monorepo fusion (independent .git + lockfiles);
  index state is never source authority

## Acceptance Criteria

- [ ] Red evidence captured (empty repo list, 0 lifeos symbols, branchless index)
- [ ] `[repos]` section resolves the release peers in `git-kb repo list --json`
- [ ] LifeOS + meta crate symbols tagged with their current checkout branches
- [ ] Negative tests fail-closed on all four bad-state fixtures
- [ ] Live gate checker passes; receipts pin exact commits
- [ ] Proof JSON returned to orchestrator (ledger lane writes proof_records/)

## Worktree / Branch

`/home/flexnetos/meta/.claude/worktrees/task/archbp-022-gitkb-branch-current`
branch `task/archbp-022-gitkb-branch-current` (FlexNetOS/meta, from origin/main).
