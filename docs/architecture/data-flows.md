---
title: Data Flows
status: draft
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
---

# Data Flows

## Repo Graph Flow

.meta.yaml declares the peer repositories. meta project list reads that inventory
and surfaces the current workspace shape.

## Command Result Flow

User command -> meta_cli -> config load -> filter application -> plugin discovery
or meta exec -> plugin/stdin-json or loop engine -> aggregated output.

## KB Flow

Task or context data -> GitKB document store -> workspace checkout and edit ->
commit -> board, status, and graph views.

## Release Flow

Release catalog and runner scripts -> dependency graph and packaging steps ->
build artifacts -> install and update surfaces.

## Runtime and Config Flow

Declarative tables or source configs -> generated runtime state -> shell or runtime
frontdoor -> tool execution.
