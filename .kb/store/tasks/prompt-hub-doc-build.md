---
id: kb-2026-06-12-prompt-hub-doc
slug: tasks/prompt-hub-doc-build
title: "Fix prompt_hub docs build — 14 broken intra-doc links (P0)"
type: incident
status: active
priority: high
tags: [prompt_hub, ci, docs, blocking]
resolves: context/overridable/handoff-loop
---

## Source
CI failure on `FlexNetOS/prompt_hub` main branch. CI job: `doc` — `cargo doc --workspace --all-features --no-deps` with `RUSTDOCFLAGS="-D warnings"`. The check is REQUIRED and blocks ALL PRs (including non-code PRs like #77 which seeds `.handoff/` docs).

## Root Cause
14 broken intra-doc links in source files — references to symbols that don't exist, were renamed, or were removed. No corresponding struct/type/module exists for these names:
- `ChaosAuto`, `SmartContext`, `LimitStatus`, `ModerationReport` — likely feature-gated or module-moved types no longer visible
- `sync`, `OfflineConfig` — possibly re-exported from outer crate (now a path issue)
- `Change::Create/Update/Delete` — enum variants not in scope or renamed
- `TouchEvent`, `TouchAction` — event-types module moved or renamed
- `PromptHub` — self-reference that broke when struct moved modules
- 1 redundant explicit link target

## Impact
Blocks all PRs to prompt_hub. This is a P0 blocker for the repo's CI health and for the P7 continuity layer (#77) which is currently BLOCKED because of this.

## Acceptance Criteria
- [ ] All 14 broken intra-doc links fixed or removed (use `#[allow(rustdoc::broken_intra_doc_links)]` as last resort only if symbol still exists elsewhere)
- [ ] Local: `RUSTDOCFLAGS="-D warnings" cargo doc --workspace --all-features --no-deps` passes clean
- [ ] PR to prompt_hub main with fix, CI green on all checks
- [ ] Verify prompt_hub#77 (`.handoff/` seed) unblocks after this fix

## Notes
Loop harness cycle 82 ran successfully but didn't catch these doc regressions — likely because `cargo doc -D warnings` is not in the local test/dev flow (only in CI). This is a CI-local-only check that should be added to local dev tooling.

Related: [[tasks/prompt-hub-coverage]], [[tasks/prompt-hub-safety-check]], [[context/overridable/handoff-loop]]
