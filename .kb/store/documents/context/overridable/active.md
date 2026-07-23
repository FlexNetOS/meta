---
id: 019f2142-744e-7092-ba84-c6433d8d0007
slug: context/overridable/active
title: "Active Context"
type: context
status: draft
priority: medium
---

# Active Context

## Current Focus

The clean GitKB-backed foundation task for upstream `gitkb/meta` is complete. The current focus should move to the source-backed follow-up tasks that were loaded during that foundation pass.

## Immediate Objective

Use the completed foundation evidence before making source changes. Pick one loaded follow-up task, verify current source state, make the smallest upstream-appropriate change, and record command evidence in that task before marking it complete.

## Current Constraints

- Root source must stay clean unless a separate source task is intentionally started.
- No `.codex` root overlay.
- Child repos are independent and must be checked independently.
- Use `/home/flexnetos/FlexNetOS/usr/bin/git-kb` for GitKB operations in this environment.

## Known Follow-Up Areas

- `meta-rust` release/install packaging.
- Docs/skills command-surface drift.
- Legacy org reference cleanup.
- CI/local verification parity.
- Cargo.lock/workspace version drift; locked build currently fails until the lockfile is reconciled.
