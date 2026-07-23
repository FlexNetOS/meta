---
id: 019f5083-4256-7cc2-96ca-866ef5e98502
slug: tasks/lifeos-notebooklm-source-claim-complete-proof
title: "Prove every NotebookLM source claim against canonical evidence"
type: task
status: draft
priority: medium
---

## Objective

Exhaustively test every atomized claim in every captured NotebookLM source
against current, canonical primary evidence. Do not treat a repeated report,
task mapping, source extract, or prior conclusion as proof of truth.

## Scope

- Inventory every row in
  `planning-spine-v0/generated/notebooklm_source_claims.source.csv`.
- Preserve each claim's exact wording and source pointer while verifying it.
- Use the source-specific verification rule: local dependency source and tests
  for engine facts; local call paths, tests, commits, PRs, and runtime proof
  for implementation claims; reproducible benchmarks for performance claims;
  and technical evidence plus a recorded owner decision for proposals.
- Record every result in the canonical claim-evidence table and proof ledger
  with an immutable proof URI.
- Treat a failed exact claim as a refutation, not as permission to silently
  narrow, rewrite, or omit it.

## Acceptance Criteria

- [ ] Claim inventory count, claim IDs, source IDs, and source checksums are
      reconciled with the source registry.
- [ ] Every claim is resolved as `verified`, `qualified`, `refuted`, or
      `owner-decided`; there are no implicit or untracked unresolved rows.
- [ ] Every resolution has a primary-evidence pointer, content hash or
      reproducibility receipt where applicable, and proof URI.
- [ ] Any claim that cannot be proven true exactly is explicitly retained as
      `refuted` or `qualified` with the contradicting primary evidence.
- [ ] The evidence table, queue, truth matrix, source proof records, and
      append-only ledger agree exactly.
- [ ] `bun run planning-spine:verify` and `git diff --check` pass.

## Verification Record

Pending recovery of the completed `NBSOURCE-030` through `NBSOURCE-032`
verification packet and exhaustive inventory of all preceding source claims.
