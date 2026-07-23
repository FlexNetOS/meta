---
id: 019f8800-707a-71d0-964d-cf7d184a017d
slug: tasks/yzx-iso/t5-2-close-dotclaude
title: "T5.2 — Close ~/.claude active owner"
type: task
status: draft
priority: high
tags: [yzx-iso, T5, impl]
---

Overview: Route every writer through CLAUDE_CONFIG_DIR so no process writes HOME/.claude.

## Acceptance
- [ ] No writes to ~/.claude
- [ ] Writers inherit profile env
- [ ] Durable copy moved to plane

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: ~/.claude active-owner residual is a this-session finding; not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-078 on worktree-archbp-frontier
