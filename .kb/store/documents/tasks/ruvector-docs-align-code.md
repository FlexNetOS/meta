---
id: 019eed6d-44cb-7e90-908c-f248bfa5450d
slug: tasks/ruvector-docs-align-code
title: "Align ruvector documentation (READMEs + //! doc-comments) with actual crate code"
type: task
status: draft
priority: medium
---

## Discovery DONE (2026-06-22) — swarm: 23 agents/1.9M tok, 228 crates audited
Inventory: ~/Desktop/meta/RUVECTOR-DOC-DRIFT-INVENTORY.json
- 131/228 docs ACCURATE; 95 drift (42%): 16 severe, 43 major, 36 minor.
- Dominant failure: READMEs document PHANTOM APIs (types/methods that don't exist;
  examples won't compile). //! doc-comments mostly CORRECT. Whole families share
  copy-pasted wrong READMEs (router-*, tiny-dancer-*, mincut-*, graph-transformer-*).
- Some misrepresent SECURITY (ruvix/boot ML-DSA-65 stub, proof-gate, exo-manifold burn).
Fix = rewrite each lying README grounded in real lib.rs exports.
## Batches: (1) 16 severe [in progress], (2) 43 major, (3) 36 minor + 11 missing-README.
