---
id: kb-2026-06-12-prompt-hub-coverage
slug: tasks/prompt-hub-coverage
title: "Fix prompt_hub code coverage — tests fail to compile (P0)"
type: incident
status: active
priority: high
tags: [prompt_hub, ci, coverage, blocking]
resolves: context/overridable/handoff-loop
---

## Source
CI failure on `FlexNetOS/prompt_hub` main branch. CI job: `coverage` — `cargo tarpaulin --workspace --all-features --out xml`. Tests don't compile → no coverage generated → CI red. This blocks ALL PRs including non-code changes like #77 (P7 seed).

## Root Cause
Test code references methods that don't exist in `hub::PromptHub`:
- `set_retention_period()` / `get_retention_period()` — retention feature missing
- `is_data_expired()` — expiration check missing  
- `gc_enabled()` — garbage collection status missing
- `validate_image_mime_type()` — image validation missing
- `extract_placeholder_ids()` — template placeholder extraction missing

Also: `unresolved import crate::retention` — the `retention` module is missing entirely.

These are likely stubbed test methods from a feature that was planned but never implemented, or features removed during refactoring without updating tests. The loop-harness cycle count at 82 didn't catch this because local dev flow doesn't run full `cargo test --all-features`.

## Impact
Blocks all PRs to prompt_hub. CI `coverage` check is REQUIRED — no coverage data = merge blocked. Cascades to blocking the entire P7 continuity layer (#77).

## Acceptance Criteria
- [ ] Implement missing methods OR remove test stubs (match intent)
- [ ] Create `retention` module if intentional but dropped; otherwise remove unused import
- [ ] Local: `cargo test --lib` passes all tests green
- [ ] PR to prompt_hub main, CI green on ALL checks
- [ ] Verify coverage job produces valid XML output

## Notes
Loop harness cycle 82 ran on this repo — these test failures were never caught because the harness doesn't run `cargo test --all-features` in its local dev flow. Add it as a prerequisite to any loop workflow that touches prompt_hub.

Related: [[tasks/prompt-hub-doc-build]], [[tasks/prompt-hub-safety-check]], [[context/overridable/handoff-loop]]
