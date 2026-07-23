---
id: 019f80f4-24ff-7b41-85a6-d6810fa5fdc1
slug: tasks/lifeos-postgresql-durable-storage-cutover
title: "Cut LifeOS durable storage over to PostgreSQL/RuVector"
type: task
status: active
priority: critical
parent: tasks/architecture-data-pipeline-blueprint
---

Implement the LifeOS-side durable-storage boundary required by ARCHANCHOR-001 §16 and ANCHOR-REQ-001/006/007. Replace SQLite as canonical durable storage; retain only explicitly transient redb projections; enforce PostgreSQL/RuVector migrations, recovery evidence, and Tauri startup configuration.

Progress: SQLx storage and Tauri startup now use PostgreSQL/RuVector; accounts, AgentDB cognition, semantic vectors, and durable UI/lighting/provider projections are PostgreSQL-owned. A one-way legacy SQLite/JSON importer captures raw source bytes, commits atomically, preserves divergent sources, and retires source files only after successful commit. The exact PostgreSQL 17.10 Nix frontdoor passed 40 storage tests and a native Tauri runtime smoke with ruvector 0.3.0 installed in `extensions`.

Remaining release gates: provision an authenticated durable production PostgreSQL endpoint before importing any real local legacy source; rebuild or replace the installed RuVector closure before claiming relocatable upgrade support, because the verified package control file remains `relocatable=false` even though the current source correction is relocatable.
