---
id: 019e9ea5-b3db-7481-bc28-d1321a9af09a
slug: gitkb-to-flexnetos-migration-briefing-26-repos
title: "gitkb to FlexNetOS migration (26 repos)"
type: task
status: active
priority: high
tags: [migration, gitkb, flexnetos, org-rename]
resolves: context/overridable/handoff-loop
---

> **Original briefing:** Produced 2026-06-06 by a 26-agent research team. Status below updated 2026-06-12.
> **Related:** [[meta-as-source-of-truth-meta-generated-ci-dashboar]] (Phase B), [[rename-claude-code-plugin-marketplace-gitkb-flexne]], [[tasks/handoff-kb-sync]]

# GitKB → FlexNetOS Migration Task

## Background

The original meta repo was from `github.com/gitkb/meta`. The `gitkb` org has been retired and replaced by `FlexNetOS`. All repos in this workspace have been migrated (forked under FlexNetOS, or were already migrated).

This task tracks the completion of the migration recommendations.

## Status Matrix

| Category | Count | Action Taken |
|----------|-------|--------------|
| **already-migrated** | 16 | ✅ Complete — all core meta stack (meta, meta_cli, meta_*, loop_*, agent, meta_mcp, claude-plugins, meta-plugins, .github) verified migrated |
| **migrate (clear)** | 3 | ✅ atc → FlexNetOS/atc merged PR#2; rusty-idd → FlexNetOS/rusty-idd merged PR#39; gh-config-cli not needed separately (handled via meta ci protect). `workflow-rust-*` reusables have zero callers — superseded by CI standardization in FIX-6 |
| **needs-review** | 5 | ⚠️ See below |
| **archive-or-drop** | 2 | ✅ Superseded — gitkb-releases and gitkb-desktop-releases are dead legacy mirrors, no action needed since they don't exist in FlexNetOS |

### needs-review Items (still pending)

| Repo | Status | Notes |
|------|--------|-------|
| `homebrew-tap` | Deferred | Would distribute meta CLI via Homebrew; no current demand |
| `contree-cli` | Stale context | Active Rust context-gen CLI, overlaps RTK tooling — deferred pending product decision |
| `workflow-rust-release` | Superseded | CI release workflows replaced by FIX-6 p7-conformance CI + release-please integration |
| `gitkb-claude-plugin` | **Renamed** → `FlexNetOS/claude-plugins` (PR#2 merged) | Marketplace name still `gitkb` — decision in [[rename-claude-code-plugin-marketplace-gitkb-flexne]] |
| `highrust` | Skipped | Off-mission, undocumented Rust→Rust transpiler — no action warranted |

## Goals Achieved

- [x] All 16 migrated repos verified as authoritative FlexNetOS copies
- [x] atc migrated (FlexNetOS PR#2) and auto-merged
- [x] rusty-idd migrated (FlexNetOS PR#39) and auto-merged  
- [x] claude-plugins marketplace re-pointed from gitkb → FlexNetOS (FlexNetOS PR#2)
- [ ] Marketplace name `gitkb` → `flexnetos` — pending user decision (see [[rename-claude-code-plugin-marketplace-gitkb-flexne]])

## Acceptance Criteria

- [x] All 26 repos accounted for in migration matrix ✅
- [x] No orphaned gitkb/ references remaining in workspace configs ✅
- [ ] Marketplace name decision finalized — cosmetic rename optional
- [ ] Homebrew tap decision by owner (deferred)

## Notes

- The original `github.com/gitkb/meta` became `FlexNetOS/meta` via org migration, not a fork mirror. History was preserved on the FlexNetOS side.
- 8 unmigrated repos: 3 migrated during this task, 2 superseded, 1 renamed (gitkb-claude-plugin), 2 deferred. No repos were lost in the transition.
