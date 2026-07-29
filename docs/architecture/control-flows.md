---
title: Control Flows
status: draft
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
---

# Control Flows

## Meta Command Routing

meta parses args, loads .meta config, discovers plugins, then either routes to a
plugin or falls through to meta exec.

## GitKB Workflow Control

Create or update task or context -> checkout to workspace -> edit -> commit ->
verify -> set status. The task body and evidence must support the status claim.

## Plugin Control

Plugins are subprocesses that speak JSON over stdin/stdout. The host owns routing;
plugins own command planning or specialized execution.

## MCP Control

Agent-facing MCP servers are wrappers around repo-owned or workspace-owned
implementations. They should be declared once and launched through the correct
frontdoor, not duplicated in multiple places.
