---
id: 019f2173-4983-7b33-acfd-5fd21151163e
slug: tasks/meta-root-claude-code-intelligence-command-drift
title: "Align root Claude code-intelligence docs with git-kb code commands"
type: task
status: completed
priority: high
tags: [docs, claude, gitkb, code-intelligence]
---

# Summary

Root Claude code-intelligence docs describe older `git kb ...`/MCP command names that do not match the current Codex GitKB skill surface or the explicit binary available in this environment.

# Source Evidence

- `.claude/rules/code-intelligence.md` references `git kb callers`, `git kb index`, and MCP names such as `kb_callers`/`kb_impact`.
- `.claude/skills/gitkb/SKILL.md`, `.claude/skills/explore/SKILL.md`, `.claude/skills/before-refactor/SKILL.md`, and `.claude/skills/understand/SKILL.md` use `git kb index` and related legacy forms.
- `codex-plugins/plugins/gitkb/skills/gitkb-code-intelligence/SKILL.md` documents the current Codex-side commands as `git-kb code symbols`, `git-kb code callers`, `git-kb code callees`, `git-kb code impact`, `git-kb code doctor`, and `git-kb code index`.
- In this shell, `/home/flexnetos/FlexNetOS/usr/bin/git-kb code doctor --json` and `/home/flexnetos/FlexNetOS/usr/bin/git-kb code index` are the working command forms.

# Acceptance Criteria

- Decide whether the root Claude assets should document `git kb` subcommand syntax, `git-kb` binary syntax, or both with environment notes.
- Align code-intelligence examples across root `.claude` docs and Codex plugin docs.
- Add a validation/search check for stale code-intelligence command forms.
