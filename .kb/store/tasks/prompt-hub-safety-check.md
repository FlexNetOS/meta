---
id: kb-2026-06-12-prompt-hub-safety
slug: tasks/prompt-hub-safety-check
title: "Fix prompt_hub safety check — 2 lib files missing forbid(unsafe_code) (P0)"
type: incident
status: active
priority: high
tags: [prompt_hub, ci, safety, blocking]
resolves: context/overridable/handoff-loop
---

## Source
CI failure on `FlexNetOS/prompt_hub` main branch. CI job: `safety` — `./scripts/check_safety.sh`. This script enforces that ALL library files have `#![forbid(unsafe_code)]` as a first-level attribute.

## Root Cause
2 library files are missing the directive:
- `prompt-hub/src/touch.rs` — handles mobile touch events
- `prompt-hub/src/mobile.rs` — handles mobile-specific functionality

All other 68 lib files have it. These two appear to be newer additions (likely from feature work that wasn't gated by safety checks).

## Impact
Blocks all PRs to prompt_hub. This is a policy enforcement check — the project-wide guarantee that no unsafe code can enter the lib layer. Without it, these modules could introduce unsafe code at any point without compile-time protection.

## Acceptance Criteria
- [ ] Add `#![forbid(unsafe_code)]` as first line in `touch.rs` and `mobile.rs`
- [ ] Local: `./scripts/check_safety.sh` passes clean
- [ ] PR to prompt_hub main with fix, CI green on all checks
- [ ] Verify no other files are missing the directive (full re-scan)

## Notes
The safety script also checks for actual `unsafe` keyword usage as a belt-and-suspenders measure. Adding the forbid attribute is the primary requirement; the secondary check would catch any remaining unsafe blocks even after forbid is added.

Related: [[tasks/prompt-hub-doc-build]], [[tasks/prompt-hub-coverage]], [[context/overridable/handoff-loop]]
