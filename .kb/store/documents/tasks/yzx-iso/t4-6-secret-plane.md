---
id: 019f8800-7012-7703-84bc-d5bd721077d5
slug: tasks/yzx-iso/t4-6-secret-plane
title: "T4.6 — Migrate secrets into envctl secret engine"
type: task
status: draft
priority: medium
tags: [yzx-iso, T4, impl]
---

Overview: Move OS-keyring/env secrets into the envctl secret engine/broker/vault.

## Acceptance
- [ ] Secrets in envctl engine
- [ ] No plaintext residue
- [ ] Relay boundary enforced

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-044 (NOT-COMPLETE, READY) six-part protected secret custody; STORE-001 six_part_secret_lifecycle_required. Keyring path still transitional.
- remaining scope (goal preserved, NOT narrowed): implement secret-engine migration
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-044
