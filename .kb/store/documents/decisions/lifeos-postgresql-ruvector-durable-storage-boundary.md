---
id: 019f8111-b913-7332-8b39-b3d584c9b1de
slug: decisions/lifeos-postgresql-ruvector-durable-storage-boundary
title: "LifeOS PostgreSQL/RuVector durable-storage boundary"
type: adr
status: active
priority: high
parent: tasks/lifeos-postgresql-durable-storage-cutover
in:
  tasks/lifeos-postgresql-durable-storage-cutover: "a0"
---

Decision: LifeOS canonical durable state is PostgreSQL 17.10 with RuVector installed in schema extensions. SQLx storage owns accounts, AgentDB cognition, semantic vectors, and durable UI/lighting/provider projections. SQLite is limited to a one-way, transactional legacy importer; source bytes are archived before retirement, and conflicts retain the source. Exact Nix PostgreSQL 17.10 verification created ruvector 0.3.0 in extensions and passed storage plus native runtime proof. The installed package remains relocatable=false despite the source correction, so fresh topology is proven but closure replacement/rebuild is still required before an upgrade/relocation claim.