---
id: 019f80a9-3dfe-7762-aa4e-fa94b7b68c2b
slug: tasks/architecture-rtk-nu-adapter
title: "Implement byte-exact rtk_nu adapter"
type: task
status: completed
priority: high
tags: [architecture-blueprint, rtk-nu, byte-lineage, rtk-tokenkill]
---

## Objective

Implement the required separately pinned rtk_nu adapter in the rtk-tokenkill source repository. It must tee exact stdout and stderr bytes before any parse or compact transform, preserve stream order and offsets, emit versioned JSONL, JSON, and Nuon-safe envelopes, and retain failures, binary data, partial lines, signals, and parser errors.

## Authority

Immutable expanded architecture anchor sections 3.4, 4.4, 19 and diagrams D07 through D09; anchor requirements ANCHOR-REQ-004 and ANCHOR-REQ-003; current RTK contract retains rtk as compact output proxy and does not mislabel it as the adapter.

## Acceptance

- A dedicated rtk_nu binary and package contract is pinned and documented.
- A shell command is executed with byte-exact ordered frame capture before parsing.
- JSONL, JSON, and Nuon formats carry schema, frame metadata, identity context, digests, exit outcome, parser status, and idempotency key.
- Native Nu remains a bypass path and no ordinary rtk command behavior regresses.
- Unit and binary fixture coverage proves invalid UTF-8, binary bytes, stderr interleaving, non-zero exit, and partial output behavior.
- The adapter proof links to CodeDB ingestion, redb owner, and envctl commit tasks.