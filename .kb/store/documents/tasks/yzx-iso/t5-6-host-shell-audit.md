---
id: 019f8800-70bc-7393-97f8-5759427cf065
slug: tasks/yzx-iso/t5-6-host-shell-audit
title: "T5.6 — Audit host default shell stays bash"
type: task
status: draft
priority: low
tags: [yzx-iso, T5, test]
---

Overview: Confirm /etc/passwd login shell remains /bin/bash; nu only inside yazelix.

## Acceptance
- [ ] Host shell = bash confirmed
- [ ] No PAM/login sets nu
- [ ] Documented invariant

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Verified this session host shell=bash; audit-as-guard task is new.
- remaining scope (goal preserved, NOT narrowed): guard
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-081 on worktree-archbp-frontier
