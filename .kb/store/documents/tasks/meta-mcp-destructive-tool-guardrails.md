---
id: 019f2159-5ece-75e0-a891-001121c5487f
slug: tasks/meta-mcp-destructive-tool-guardrails
title: "Document and guard destructive meta_mcp tools"
type: task
status: completed
priority: high
tags: [meta_mcp, safety, mcp]
---

# Summary

`meta_mcp` exposes tools that can mutate repositories or execute shell commands; their descriptions and guardrails should make destructive behavior explicit.

# Evidence

The initial-10 source walk found `meta_mcp/src/main.rs` exposing `meta_snapshot_restore`, `meta_git_add`, `meta_git_commit`, `meta_git_push`, `meta_git_checkout`, and `meta_batch_execute`. `tool_snapshot_restore` can run checkout plus `reset --hard` when `force` is true, and `tool_batch_execute` invokes `sh -c` for caller-provided commands.

# Acceptance Criteria

- MCP tool descriptions clearly mark destructive and shell-executing tools.
- Restore/checkout/commit/push/batch execution behavior has explicit confirmation or documented caller responsibility appropriate for MCP clients.
- Tests or schema checks cover descriptions for destructive tools.
