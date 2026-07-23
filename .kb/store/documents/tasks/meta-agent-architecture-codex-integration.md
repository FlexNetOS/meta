---
id: 019f21b2-5e14-73c3-af3c-a84d12fd1426
slug: tasks/meta-agent-architecture-codex-integration
title: "Deep dive agent architecture and .codex integration"
type: task
status: completed
priority: high
---

# Summary
Deep dive the meta architecture to understand why Claude is currently the only designated generated agent surface, then design how .codex should be built and wired without conflicting with Claude, GitKB, hooks, or the clean meta control-plane model.

# Acceptance Criteria
- [x] Read and map existing Claude-specific architecture and generation paths.
- [x] Identify hook, settings, skill, and rule ownership boundaries.
- [x] Explain why Claude is currently designated and what assumptions enforce that.
- [x] Design additive .codex wiring that does not mutate or conflict with Claude surfaces.
- [x] Add implementation tasks for any required source changes.

# Evidence

## Live repo-local harness surfaces

- `.claude/settings.json` owns active Claude hook wiring:
  - `PreToolUse` -> `./target/debug/agent guard`
  - `SessionStart` -> `meta context`
  - `SessionStart` -> GitKB daemon start
  - `PreCompact` -> `meta context`
- `.claude/rules/`, `.claude/skills/`, `.claude/commands/`, and
  `.claude/agents/meta-worker.md` make Claude the only rich generated repo-local
  assistant surface.
- `.codex/instructions/` plus `.codex/skills/*` symlinks match the narrower
  documented `git-kb init codex` scaffold.

## Architecture conclusion

Claude is the designated generated surface today because it is the only local
harness with active hooks, repo-local rules, repo-local skills, KB command
wrappers, and a generated worker persona. Codex is already present, but as a
GitKB-first adapter consisting of instructions plus skill forwarders.

The correct Codex path is additive:

1. keep `.codex/` as a repo-local adapter rather than mirroring `.claude/`;
2. diff `.claude/` against `.codex/` before any new Codex wiring;
3. design Codex-specific hook/config parity rather than copying Claude files;
4. preserve single-owner MCP policy;
5. move shared intent into the meta-owned control-plane design.

## Source-change backlog

Required follow-on work already exists as separate KB tasks, so no duplicate
task creation was needed:

- `tasks/meta-diff-claude-to-codex-wiring`
- `tasks/meta-design-codex-hook-parity`
- `tasks/meta-unified-agent-plugin-control-plane`
- `tasks/meta-plugin-claude-retirement-proof-plan`

## Files updated

- `docs/architecture/assistant-harness-boundaries.md`
- `docs/architecture/README.md`
