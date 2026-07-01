---
id: 019f1f27-511f-7c93-b837-0a125d0defdb
slug: tasks/bootstrap-clean-room-peer-repos
title: "Bootstrap clean-room peer repos"
type: task
status: completed
priority: high
tags: [clean-room, bootstrap, meta]
---

# Overview
Bootstrap the clean-room meta branch by adding the child repositories declared in .meta.yaml, preferring FlexNetOS remotes when they exist and using upstream gitkb remotes only as fallback.

## Goals
- Keep src/meta on codex/clean-room-foundation-base-20260628.
- Clone all branch-local .meta.yaml child repos as independent Git repositories.
- Create local clean-room baseline branches in child repos without pretending they already exist upstream.
- Update .meta.yaml remote URLs to match the local clone source where appropriate.
- Verify GitKB and repo state after cloning.

## Acceptance Criteria
- [x] All branch-local .meta.yaml child directories exist locally as Git repos.
- [x] Each child repo has branch, HEAD, and remote source recorded.
- [x] Clean-room branch confusion with main-only workspace members is documented.
- [x] GitKB verify and status checks pass.
- [x] Root worklog records the correction and remaining gaps.

## Context
Related context docs: [[context/overridable/active]], [[context/overridable/progress]], [[context/immutable/project-brief]].

## Progress Log

### 2026-07-01

- Corrected `src/meta` from `main` to local branch
  `codex/clean-room-foundation-base-20260628`, tracking the clean-room remote.
- Preserved the accidental wrong-branch GitKB reinit in a Git stash instead of
  applying it to clean-room.
- Created and committed the seven required GitKB context documents.
- Added all 14 `.meta.yaml` children as local Git repos.
- Updated `.meta.yaml` to use FlexNetOS HTTPS remotes where available and
  upstream `gitkb` fallbacks for `agent`, `codex-plugins`, and `meta-plugins`.
- Switched GitKB repo discovery to explicit `custom` entries because the `meta`
  CLI is not installed yet and `strategy = "meta"` requires it.

## Completion Evidence

- `git-kb list --path context/ --json`: 7 context documents.
- `git-kb repo list --refresh --json`: 14 repos discovered.
- `git-kb doctor --json`: repo discovery ok; only `code.symbols` warning.
- `git-kb verify`: ok.
- `cargo metadata --manifest-path /home/flexnetos/FlexNetOS/src/meta/Cargo.toml --no-deps --format-version 1`: exit 0.
