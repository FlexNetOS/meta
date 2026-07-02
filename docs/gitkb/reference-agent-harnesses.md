<!-- Source: https://gitkb.com/docs/reference/agent-harnesses/ -->
<!-- Snapshot: 2026-07-02 -->

# Agent Harnesses &  Skills

Local verification: this extracted page was executed against the FlexNetOS
`meta` checkout. The canonical `.kb/skills/` inventory has 17 skills; local
Codex adapters already point at all 17 through `.codex/skills/`; Claude has a
partial legacy/local skill surface and `git-kb init claude --dry-run` would add
14 GitKB skill adapters. Cursor and Windsurf are not currently materialized in
this checkout; their dry-runs would create `.kb/rules/`, harness skills, and
harness rules.

GitKB supports five integration paths for agents:

Harness | Use when | Assets/config
Claude Code | You want Claude-native rules, skills, and MCP tools | ` .claude/rules/` , ` .claude/skills/` , MCP config, ` CLAUDE.md`
Codex | You use Codex locally and want GitKB skills plus session instructions | ` .codex/skills/` , ` .codex/instructions/` , optional ` $CODEX_HOME`  install
Cursor | You use Cursor Agent mode with GitKB MCP tools and repo rules/skills | ` .cursor/rules/` , ` .cursor/skills/` , ` .cursor/mcp.json`
Windsurf | You use Windsurf with GitKB MCP tools and repo rules/skills | ` .windsurf/rules/` , ` .windsurf/skills/` , MCP config
Generic MCP clients | Your assistant can connect to an MCP stdio server | MCP config that runs ` git-kb mcp`

The live `git-kb init --help` output still mentions Hermes in the Windsurf
description, but `git-kb init windsurf --dry-run` reports `.windsurf/skills/`
and `.windsurf/rules/` writes, not `.hermes/` writes. Treat the Hermes wording
as CLI help drift unless a later binary proves otherwise.

## Skill source of truth

The canonical GitKB skill content lives under ` .kb/skills/` . Assistant-specific directories are lightweight adapters:

```
.kb/skills/                    # Canonical GitKB workflows
.claude/skills/                # Claude Code forwarders/adapters
.codex/skills/                 # Codex forwarders/adapters
.cursor/skills/                # Cursor forwarders/adapters
.windsurf/skills/              # Windsurf forwarders/adapters
```

This layout keeps GitKB workflow behavior consistent across harnesses while allowing each assistant to load skills in the format it expects. The ` kb-*`  command-style workflows are skills now, so harnesses load them from ` .kb/skills/`  instead of separate ` .claude/commands/`  or ` .codex/commands/`  directories.

Projects can also expose local skill packs through additional symlinks under the harness skill directory. In Harmony, for example, ` .claude/skills/atc`  and ` .codex/skills/atc`  point at ` ../../.atc/skills` .

## GitKB skills

### Core

Skill | Purpose
`gitkb` | Core KB operations, CLI/MCP mapping, workspace workflow

### Task workflow

Skill | Purpose
`kb-board` | View the kanban board with task status columns
`kb-tasks` | List and filter tasks with relationships and status details
`kb-start` | Start a task, load context, set it active, and check it out
`kb-progress` | Add dated progress entries to a task
`kb-review` | Review acceptance criteria against current code/docs state
`kb-close` | Complete a task with evidence before status changes

### Knowledge management

Skill | Purpose
`kb-create` | Create tasks, incidents, specs, notes, and context documents
`kb-search` | Search documents and suggest next actions
`kb-context` | Load and validate project context before work
`kb-status` | Inspect pending KB workspace changes
`kb-commit` | Validate and commit KB workspace changes
`kb-handoff` | Capture end-of-session state for the next agent

### Code intelligence

Skill | Purpose
`code-intelligence` | Prefer structured symbol/call graph tools over grep
`explore` | Find where concepts live across code and documents
`understand` | Analyze a file or symbol’s structure and dependencies
`refactor-safety` | Check callers, callees, and blast radius before refactors

Mutating skills such as ` kb-create`  and ` kb-commit`  should be explicit user actions. Read-only or analysis skills can be used opportunistically by agents when they need context.

## Setup commands

```
# Claude Code integration
git-kb init claude

# Codex integration
git-kb init codex
git-kb init codex --install-home

# Cursor integration
git-kb init cursor

# Windsurf integration
git-kb init windsurf

# Generic MCP clients
git-kb mcp
```

Use ` git-kb init < harness >  --dry-run`  before writing files if you want to preview generated assets. Generic MCP clients use manual MCP configuration that starts ` git-kb mcp` .

Live dry-run counts in this checkout:

- `git-kb init claude --dry-run`: 14 would create, 42 skipped.
- `git-kb init codex --dry-run`: 53 skipped.
- `git-kb init codex --dry-run --install-home`: 2 would create under `$CODEX_HOME`, 53 skipped.
- `git-kb init cursor --dry-run`: 23 would create, 34 skipped.
- `git-kb init windsurf --dry-run`: 23 would create, 34 skipped.
- `git-kb mcp`: tools/list returns 49 tools.

## Choosing a path

- Use Claude Code  or Codex  when you want assistant-native skills and workflow instructions.

- Use Cursor  when you want Cursor Agent mode to use the same GitKB MCP tools.

- Use Windsurf  when you want Windsurf to load the same GitKB rules and skills.

- Use generic MCP  when the assistant only needs tool access and you will provide workflow instructions separately.

## Related docs

- MCP Setup  — Connect any MCP-compatible assistant.

- Claude Code  — Claude-specific scaffold and workflow.

- Codex  — Codex-specific scaffold and global install.

- Agent Workflows  — How agents use GitKB during real work.

- CLI Reference  — Full command help for the installed CLI.
