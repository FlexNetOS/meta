---
id: 019f87ff-8f81-76f1-a8ec-4b4bdd288524
slug: tasks/yzx-iso/t1-4-invariant-ledger
title: "T1.4 — Author the numbered invariant ledger"
type: task
status: draft
priority: high
tags: [yzx-iso, T1, architecture]
---

Overview: Enumerate I01..In invariants, each with an acceptance predicate, covering isolation, persistence, ownership, portability.

## Acceptance
- [ ] Invariants numbered with predicates
- [ ] Each maps to at least one goal G1-G10
- [ ] Ledger merged as normative

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Spine has a proof ledger + North Star acceptance (RELEASE-001) but no OS-isolation invariant ledger. ARCHBP-047 (NOT-COMPLETE) is anchor-topology conformance, not isolation invariants.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-061 on worktree-archbp-frontier
