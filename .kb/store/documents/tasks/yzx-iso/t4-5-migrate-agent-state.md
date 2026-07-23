---
id: 019f8800-7000-7f80-9e2e-d0828a76f651
slug: tasks/yzx-iso/t4-5-migrate-agent-state
title: "T4.5 — Migrate agent/session/tool state into Postgres"
type: task
status: draft
priority: medium
tags: [yzx-iso, T4, impl]
---

Overview: Move claude/codex/icm/rtk state from tmpfs + home dotdirs into the durable plane.

## Acceptance
- [ ] State migrated and verified
- [ ] Sources removed only after commit
- [ ] Conflicts fail closed

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: STORE-001 (product_execution=false) + BlobStore SHA-256 parity contract design. No proof that claude/codex/icm/rtk state is migrated into the plane.
- remaining scope (goal preserved, NOT narrowed): actual agent/session/tool-state migration
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-131 on worktree-archbp-frontier
