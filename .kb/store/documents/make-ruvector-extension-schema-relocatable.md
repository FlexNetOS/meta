---
id: 019f80cb-fdde-7450-8460-8702e0a64518
slug: make-ruvector-extension-schema-relocatable
title: "Make RuVector extension schema-relocatable"
type: task
status: active
priority: high
tags: [architecture, ruvector, postgresql, extension-schema, proof]
---

Repair the meta-ruvector PostgreSQL extension control metadata so the immutable architecture bootstrap can install ruvector in the required extensions schema. Add a repository-owned regression gate that proves the exact CREATE EXTENSION ruvector WITH SCHEMA extensions path against a packaged PostgreSQL extension. Preserve the user-owned source checkout by working only in an isolated worktree.\n\nAuthority: immutable architecture anchor requires PostgreSQL extensions in schema extensions; component docs/NEON_COMPATIBILITY.md specifies relocatable = true; shipped crates/ruvector-postgres/ruvector.control currently specifies relocatable = false.\n\nDependencies: tasks/architecture-data-pipeline-blueprint.\n\nProof target: source control file, packaged extension metadata, and clean PostgreSQL schema-install transaction.