---
id: 019f80a3-4a40-7de2-8a91-ca6864585cc2
slug: tasks/gitkb-code-index-symbol-forwarding
title: "Repair GitKB duplicate symbol-forwarding index failure"
type: task
status: active
priority: high
tags: [gitkb, code-index, architecture-blueprint, incident]
---

## Incident

A forced targeted Meta code-index run stored 252590 symbols for the exact source set and then failed before call resolution with SQLite UNIQUE constraint failed: index idx_symbol_forwarding_unique.

## Reproduction

Run GitKB code index with index-only and force from the Meta KB root over the targeted first-party source paths.

## Impact

The canonical GitKB document graph is healthy, but the code graph has symbols without resolved call edges. The index must not be represented as current until an official safe repair or profile-owner upgrade resolves the duplicate forwarding cause.

## Required resolution

- Identify and remove the duplicate-forwarding cause through a GitKB-supported operation or a profile-owner upgrade.
- Rebuild the affected exact-commit index without dependency caches or vault_hub.
- Prove code statistics, doctor, code search, caller, and dependency surfaces report a complete healthy index.
- Preserve this incident, reproduction, fix provenance, and verification receipt.