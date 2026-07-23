---
id: 019f8800-7067-7982-b39f-866173fe3136
slug: tasks/yzx-iso/t5-1-finalize-xdg
title: "T5.1 — Finalize XDG_DATA/STATE_HOME redirect via envctl"
type: task
status: draft
priority: high
tags: [yzx-iso, T5, impl]
---

Overview: Confirm and lock XDG_DATA_HOME/XDG_STATE_HOME at meta/var/lib through the envctl committer.

## Acceptance
- [ ] XDG redirect committed
- [ ] Verified live
- [ ] Restart-gated finalize ready

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: XDG_DATA/STATE_HOME already redirected to meta/var/lib (session env); ARCHBP-030 (READY) covers envctl root relocation. Finalize-via-committer not proven.
- remaining scope (goal preserved, NOT narrowed): finalize + lock via committer
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-030
