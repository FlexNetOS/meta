---
title: Assistant Harness Boundaries
status: draft
source_task: tasks/meta-agent-architecture-codex-integration
last_verified: 2026-07-03
---

# Assistant Harness Boundaries

This note explains why Claude is currently the designated generated agent
surface in `src/meta`, what the repo-local Codex surface already owns, and how
Codex should grow additively without conflicting with Claude, GitKB, hooks, or
the meta control plane.

## Current Live Surfaces

### Claude-owned repo-local adapter

Live evidence under `.claude/` shows Claude currently owns the richer generated
repo-local assistant surface:

- `.claude/settings.json` wires active hooks:
  - `PreToolUse` -> `./target/debug/agent guard`
  - `SessionStart` -> `meta context`
  - `SessionStart` -> GitKB daemon start
  - `PreCompact` -> `meta context`
- `.claude/rules/` carries always-on workspace and safety guidance.
- `.claude/skills/` carries both meta-specific skills and GitKB adapters.
- `.claude/commands/` still carries KB command wrappers.
- `.claude/agents/meta-worker.md` is the only repo-local generated agent role.

Claude is therefore the designated generated surface today because it is the
only harness in this repo that combines:

1. explicit hook wiring,
2. repo-local rules,
3. repo-local skills,
4. KB command adapters, and
5. a repo-local generated worker persona.

### Codex-owned repo-local adapter

Live evidence under `.codex/` shows a narrower but valid GitKB-first adapter:

- `.codex/instructions/codex-rules.md`
- `.codex/instructions/gitkb-process.md`
- `.codex/skills/*` symlinks into canonical `.kb/skills/*`

This matches the documented `git-kb init codex` contract in
`docs/gitkb/getting-started-codex.md`: repo-local Codex gets instructions plus
skill adapters, not a Claude-shaped copy of rules, agents, commands, or
settings.

## Ownership Boundaries

The clean control-plane split is:

- `.kb/skills/`: canonical GitKB workflow content.
- `.claude/` and `.codex/`: repo-local harness adapters for the active repo.
- `claude-plugin/`: Claude marketplace/install payload.
- `codex-plugins/plugins/*/`: Codex marketplace/install payloads.
- `meta-plugins/`: meta CLI subprocess plugins, not assistant plugins.
- global or project Codex config: MCP ownership when a plugin payload is not
  the owner.

This means `.codex/` should not try to become a byte-for-byte mirror of
`.claude/`. Claude and Codex load different artifact types and support
different integration mechanisms.

## Why Claude Is Still Designated

Claude is currently designated by implementation reality, not by a timeless
policy preference:

- `meta init claude` is represented directly in the repo docs and local files.
- `.claude/settings.json` is the only checked-in harness config with active hook
  execution.
- Claude-specific meta skills are documented in `docs/claude_code_skills.md`.
- The checked-in Codex adapter is intentionally thinner and GitKB-scaffolded.
- `docs/agent_plugin_control_plane.md` already says `.claude/` and `.codex/`
  are adapters, not marketplace source of truth.

So the repo currently assumes:

1. Claude owns repo-local hook enforcement.
2. Codex owns GitKB workflow instructions plus skill adapters.
3. MCP ownership must remain single-owner and explicit.
4. Assistant plugin payload generation should eventually move under a shared
   meta-owned control plane.

## Additive Codex Wiring Plan

Codex should be extended additively in this order:

1. Keep `.codex/instructions/` and `.codex/skills/` as the existing repo-local
   adapter base.
2. Produce a full Claude-to-Codex diff before adding any new Codex files.
3. Separate supported Codex surfaces from Claude-only surfaces:
   - instructions and skill adapters: likely portable;
   - hook/config semantics: require Codex-specific design;
   - Claude command wrappers and agent persona files: do not copy blindly.
4. Preserve single-owner MCP policy. Codex must not register MCP servers that
   are already owned by global or project config.
5. Move durable integration intent into the meta-owned control-plane design,
   then generate or validate assistant-specific payloads from there.

## Follow-on Source-Change Tasks

This architecture task does not need to mint duplicate implementation tasks.
The required follow-on tasks already exist and should be treated as the
implementation backlog:

- `tasks/meta-diff-claude-to-codex-wiring`
- `tasks/meta-design-codex-hook-parity`
- `tasks/meta-unified-agent-plugin-control-plane`
- `tasks/meta-plugin-claude-retirement-proof-plan`

## Decision

The correct near-term direction is:

- do not mutate `.claude/` to make Codex feel symmetric;
- do not invent unsupported `.codex/` structure;
- do capture the live boundary map and use it to drive a diff task, a hook
  parity design task, and the longer-term unified control-plane work.
