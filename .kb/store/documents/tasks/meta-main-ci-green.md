---
id: 019eed48-0445-7b43-8514-8d76c8c644f6
slug: tasks/meta-main-ci-green
title: "Green meta main CI — real upgrades, no downgrades (Format+Test+Build failing)"
type: task
status: active
priority: medium
---

## Overview
Owner flagged meta main CI red. ROOT CAUSE: teri "multiple workspace roots" error
(teri became its own [workspace]) broke every cargo cmd on the parent workspace.
FIXED by #40 (teri->exclude). Run 27926199098 on #40 merge = ALL 7 jobs GREEN
(Format/Clippy/Test x3/Integration x2). CI-red is RESOLVED.

## Goals (broadened per owner: identify all issues + apply real upgrades, no downgrades)
- Audit the meta workspace members for REAL issues beyond the (now-green) CI gate:
  clippy pedantic/nursery, cargo-audit CVEs, dead code, outdated deps, TODO/FIXME debt.
- Apply real upgrades (remove/comment-out genuinely dead/broken); PR+merge per repo.

## Acceptance Criteria
- [x] meta main CI green (Format/Clippy/Test/Integration) — DONE via #40
- [ ] Real-issue inventory across the 13 workspace member repos
- [ ] Upgrades applied + merged (no downgrades)
