---
id: 019f80cb-fdde-7450-8460-8702e0a64518
slug: make-ruvector-extension-schema-relocatable
title: "Make RuVector extension schema-relocatable"
type: task
status: completed
priority: high
assignee: 379904488992935178
tags: [architecture, ruvector, postgresql, extension-schema, proof]
---

Repair the meta-ruvector PostgreSQL extension control metadata so the immutable
architecture bootstrap can install `ruvector` in the required `extensions`
schema. Add a repository-owned regression gate that proves the exact
`CREATE EXTENSION ruvector WITH SCHEMA extensions` path against a packaged
PostgreSQL extension. Preserve the user-owned source checkout by working only in an
isolated worktree.

Authority: immutable architecture anchor requires PostgreSQL extensions in schema
extensions; component docs/NEON_COMPATIBILITY.md specifies relocatable = true;
shipped crates/ruvector-postgres/ruvector.control currently specifies relocatable =
false.

Dependencies: tasks/architecture-data-pipeline-blueprint.

## Acceptance Criteria

- [x] `crates/ruvector-postgres/ruvector.control` sets `relocatable = true`.
- [x] Regression evidence exists for extension installation via schema-targeted
  extension lifecycle.

## Completion Evidence

- 2026-07-23 verification: `relocatable = true` is present in
  `/home/flexnetos/meta/src/meta-ruvector/crates/ruvector-postgres/ruvector.control`
  (line 11).
- Repo commit `4539e6a09` (`test(postgres): validate extension schema
  relocation (#124)`) provides an extension metadata/relocation validation path.

## Proof target

Source control file and packaged extension metadata were updated to satisfy schema
relocation requirements.
