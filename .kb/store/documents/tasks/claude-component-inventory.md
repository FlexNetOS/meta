---
id: 019f075e-04ae-7e90-9bc3-c208235cc078
slug: tasks/claude-component-inventory
title: "Detailed per-component inventory of all active .claude configs"
type: task
status: draft
priority: medium
tags: [inventory, claude, mcp, docs]
---

## Overview

Follow-up to the MCP/plugin census in `mcp_hub/docs/claude-config-inventory.md` (merged
2026-06-26, PR mcp_hub#5). That doc lists *which* config surfaces exist and *which* MCP
servers + plugins each wires. This task expands it to the **full per-component breakdown**:
for every active `.claude` dir, enumerate its commands, skills, agents, hooks, rules,
settings, and statusline config.

Owner explicitly deferred this from the census task ("might be best for a later task").

## Goals

- One row/section per active `.claude` dir (the ~48 from inventory §A).
- Per dir, list: `commands/`, `skills/`, `agents/`, `hooks/` (+ which events),
  `rules/`, `settings.json` keys of note (statusLine, permissions, model), and any
  `CLAUDE.md`/`AGENTS.md`.
- Flag duplication/overlap across repos (same skill/hook copied vs. inherited from user SoT).
- Note which components are mirrors of the `envctl/home/.claude` SoT vs. repo-local.

## Acceptance Criteria

- [ ] Component table covering every active `.claude` dir from inventory §A.
- [ ] Hooks enumerated with their trigger events and target scripts.
- [ ] Skills/commands/agents listed per dir, with SoT-inherited vs. repo-local distinction.
- [ ] Cross-repo duplication called out.
- [ ] Doc committed (extend `mcp_hub/docs/claude-config-inventory.md` or a sibling) and linked.

## Context

- Census doc: `mcp_hub/docs/claude-config-inventory.md` (active surfaces in §A; scope =
  Claude Code only, active configs).
- User SoT for Claude config: `meta/envctl/home/.claude` (`~/.claude` symlinks into it).
- Plan file: `~/.claude/plans/eventual-petting-prism.md`.
- Use `rtk proxy find …` for census (RTK's hook rewrites bare `find`).

## Out of scope

- Noise dirs (archives, CI `_work` mirrors, `.worktrees`, caches) and sibling agent-tool
  configs (`.cursor`/`.codex`/`.roo`/`.junie`/`.aws`/copilot/VS Code) — see census §A/§D.
- Fixing the drift items in census §E (separate remediation pass).
