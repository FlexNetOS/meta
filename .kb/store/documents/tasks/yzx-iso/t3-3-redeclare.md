---
id: 019f87ff-90bb-74f2-8b09-efb53af2168c
slug: tasks/yzx-iso/t3-3-redeclare
title: "T3.3 — Redeclare profile-runtime paths in the flake/env engine"
type: task
status: draft
priority: high
tags: [yzx-iso, T3, impl]
---

Overview: Point CLAUDE_CONFIG_DIR, CODEX_HOME, YAZELIX_STATE_DIR at the persistent root.

## Acceptance
- [ ] Vars redeclared in yazelix env
- [ ] No durable var on /run
- [ ] Committed via envctl (T3.6)

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-030 (READY, not built) redeclares/relocates envctl root; overlaps but does not target CLAUDE_CONFIG_DIR/CODEX_HOME/YAZELIX_STATE_DIR off /run.
- remaining scope (goal preserved, NOT narrowed): redeclare profile-runtime vars
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-030
