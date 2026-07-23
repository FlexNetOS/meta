---
id: 019f237b-51cb-7591-b211-79f62648ac0b
slug: incidents/codex-gitkb-mcp-startup-singleton-conflict
title: "Codex GitKB MCP startup singleton conflict"
type: incident
status: completed
priority: high
---

## Summary

Codex sessions can report MCP startup incomplete for `gitkb` and
`gitkb-yazelix` when another live Codex process already owns the per-KB
`git-kb mcp` stdio server. The replacement client exits during initialize with
`MCP server already running (PID ...)`, which leaves GitKB tools unavailable in
the new session even though the configured wrappers are correct.

## Evidence

- `codex mcp list` shows both servers enabled through
  `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta` and
  `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-yazelix`.
- The current PID files point at live `git-kb mcp` processes owned by a
  different Codex process.
- `git-kb mcp --help` exposes `--force` as the supported replacement path:
  force start, killing any existing MCP server for this KB.

## Acceptance

- Both root wrapper frontdoors use the supported `git-kb mcp --force` startup.
- Direct MCP initialize and tools/list succeeds through both wrappers.
- `codex mcp list` still reports only the intended GitKB MCP entries.

## Resolution

Updated both FlexNetOS root MCP wrapper frontdoors to execute
`/home/flexnetos/FlexNetOS/usr/bin/git-kb mcp --force`. Direct MCP
initialize/tools-list probes through both wrappers returned server
`gitkb` version `0.2.12` and the full tools list. The probes replaced the prior
live MCP PIDs with the supported force path, then exited without leaving stale
`mcp.pid` files.
