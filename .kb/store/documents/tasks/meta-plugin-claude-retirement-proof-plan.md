---
id: 019f21fc-3cb1-7000-9ec1-7e7d07fe2377
slug: tasks/meta-plugin-claude-retirement-proof-plan
title: "Plan Claude retirement through meta-plugin with proof before changes"
type: task
status: draft
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Plan Claude adapter retirement through `meta-plugin`, with proof and tests before deleting or replacing any current `.claude` assets.

# Feedback Captured

The right model is:

- `meta-plugin/` is the shared control plane and source of truth for tool/harness behavior.
- `.kb/skills/` remains the canonical GitKB workflow content for GitKB skills.
- `.claude/` and `.codex/` should become generated or thin adapter surfaces, not separate places where behavior is invented.
- `claude-plugin/` and `codex-plugins/` are package/publication surfaces, not the design authority.
- Current `.claude` drift should be snapshotted and compared against upstream `gitkb/meta/.claude`.
- The upstream `.claude` baseline can replace polluted local state only after Claude loading is proven.
- `kb-*` symlinks and duplicate command paths are confusing and should retire only after the plugin/skill path covers the behavior.

# Source Evidence

- `docs/gitkb/reference-agent-harnesses.md` says `.kb/skills/` is canonical and assistant-specific directories are adapters.
- `docs/gitkb/reference-agent-harnesses.md` says `kb-*` command-style workflows are skills now, not separate `.claude/commands/` or `.codex/commands/`.
- `docs/gitkb/getting-started-claude-code.md` documents `git-kb init claude`, `.claude/rules/`, `.claude/skills/`, `.claude/settings.json`, and `CLAUDE.md`.
- `docs/gitkb/getting-started-claude-code.md` says most `.claude/skills/` entries are symlinks into `.kb/skills/`.

# Commands And Configs Covered

- `git-kb init claude`
- `git-kb init claude --dry-run`
- `.claude/rules/`
- `.claude/skills/`
- `.claude/settings.json`
- `CLAUDE.md`
- `.kb/skills/`
- `kb-*` skill adapters

# Acceptance Criteria

- [ ] Install/verify the Claude binary in a separate task before changing `.claude`.
- [ ] Install/verify `yeachan-heo/oh-my-claudecode` separately before using it for retirement proof.
- [ ] Snapshot current `.claude` state and diff it against upstream `gitkb/meta/.claude`.
- [ ] Run `git-kb init claude --dry-run` and capture expected generated assets.
- [ ] Prove Claude loads GitKB skills from `.claude/skills/` or plugin-generated equivalents.
- [ ] Prove `kb-*` workflows are available as skills before removing `.claude/commands/kb-*`.
- [ ] Retire duplicate `.claude` command/symlink paths only after proof and with a focused commit.
- [ ] Do not manually preserve polluted `.claude` behavior unless a real required behavior is extracted and moved into `meta-plugin`.

# Non-Goals

- Do not delete `.claude` in this task.
- Do not reset `.claude` to upstream in this task.
- Do not invent a new Claude layout outside the upstream docs and `meta-plugin` plan.
