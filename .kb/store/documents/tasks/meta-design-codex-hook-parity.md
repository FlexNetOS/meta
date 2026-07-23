---
id: 019f21c0-63f6-7c70-9461-8e31bab7e7d3
slug: tasks/meta-design-codex-hook-parity
title: "Design Codex hook parity for GitKB and meta cleanup workflow"
type: task
status: completed
priority: high
---

# Summary
`git-kb init codex` creates `.codex/skills` and `.codex/instructions`, but it does not create Codex hook/config policy equivalent to the current Claude `.claude/settings.json` hooks. Design the correct additive Codex hook wiring before implementing anything.

# Evidence
- Ran `/home/flexnetos/FlexNetOS/usr/bin/git-kb init codex --dry-run`: it listed `.kb/skills`, `.codex/skills` symlinks, and `.codex/instructions` only.
- Ran `/home/flexnetos/FlexNetOS/usr/bin/git-kb init codex`: it created the same 53 files/symlinks and no hook/config file.
- `find .codex -maxdepth 4` shows only `.codex/skills` and `.codex/instructions`.
- `.claude/settings.json` currently has PreToolUse `agent guard`, SessionStart `meta context`, SessionStart GitKB daemon start, and PreCompact `meta context` hooks.
- The live FlexNetOS root Codex control plane already owns lifecycle hooks through `/home/flexnetos/FlexNetOS/.codex/config.toml` plus `/home/flexnetos/FlexNetOS/.codex/hooks.json`.
- The root config explicitly says lifecycle hooks are single-owned by the root `.codex/hooks.json`, and plugin or peer-repo hooks must not duplicate that enforcement.

# Acceptance Criteria
- [x] Identify the supported Codex hook/config mechanism for this installed Codex version.
- [x] Map Claude hook semantics to Codex equivalents without duplicating or conflicting with Claude.
- [x] Define which behavior belongs in hooks vs skills/instructions vs GitKB tasks.
- [x] Explicitly decide whether automatic commit, push, PR, and automerge is allowed, gated, or forbidden.
- [x] Implement only after the policy design is reviewed.

# Decision

## Supported Codex mechanism in the live control plane

The supported Codex lifecycle-hook mechanism for the installed surface is the active FlexNetOS root control plane.

- `/home/flexnetos/FlexNetOS/.codex/config.toml` enables `hooks = true`.
- `/home/flexnetos/FlexNetOS/.codex/hooks.json` owns `SessionStart`, `PreToolUse`, `PermissionRequest`, `PostToolUse`, `PreCompact`, and `Stop`.
- There is no repo-local `src/meta/.codex/config.toml`; the meta repo-local Codex surface remains instructions plus skill adapters.

## Hook-parity mapping

Claude local hooks today:

- `PreToolUse` -> `./target/debug/agent guard`
- `SessionStart` -> `meta context`
- `SessionStart` -> GitKB daemon start
- `PreCompact` -> `meta context`

Codex parity decision:

- root lifecycle enforcement belongs to the FlexNetOS root Codex hook wrapper, not to `src/meta/.codex/` and not to Codex plugin payloads;
- repo-local `src/meta/.codex/instructions/*` and `src/meta/.codex/skills/*` stay additive guidance and adapter surfaces only;
- plugin payload hooks may carry source guidance or metadata, but must not add duplicate lifecycle enforcement while the root gate remains authoritative.

## Policy split

- hooks: root session gating, workspace policy enforcement, and runtime gate enforcement
- repo-local instructions and skills: GitKB-first workflow, code-intelligence discipline, and meta-specific repo guidance
- GitKB tasks: commit/push/PR/automerge workflow expectations, review gates, and cleanup ownership decisions

## Automation policy

Automatic commit, push, PR, and automerge are forbidden as root lifecycle hook behavior in the current design. They remain explicit, task-reviewed actions rather than background hook side effects.

## Follow-on implementation tasks

This design task does not itself implement new hook files. The implementation backlog remains:

- `tasks/meta-diff-claude-to-codex-wiring`
- `tasks/meta-unified-agent-plugin-control-plane`
- `tasks/meta-plugin-claude-retirement-proof-plan`
