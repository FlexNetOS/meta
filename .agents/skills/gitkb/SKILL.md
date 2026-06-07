---
name: gitkb
description: Use when working with git-kb project context, tasks, boards, code intelligence, callers, symbols, or KB-backed workspace memory.
---

Use `git kb` with a space, not `git-kb`.

Common commands:

- `git kb list --path context/`
- `git kb board`
- `git kb show <slug>`
- `git kb create task --title "Brief title"`
- `git kb commit -m "message"`
- `git kb callers <symbol>`
- `git kb symbols <path>`

Code-intelligence workflows inherited from `.claude`:

- Explore by concept: use semantic KB search, then inspect symbols, callers, and callees.
- Understand a file or symbol: list symbols, inspect callers/callees, and check KB document references.
- Before refactor: find the exact symbol, inspect all callers, run impact analysis, and list affected files.
- Prefer `kb_symbols`, `kb_callers`, `kb_callees`, `kb_impact`, `kb_dead_code`, and `kb_symbol_refs` over grep for code structure.

Follow `.kb/AGENTS.md`, `.claude/skills/gitkb/SKILL.md`, `.claude/skills/explore/SKILL.md`, `.claude/skills/understand/SKILL.md`, `.claude/skills/before-refactor/SKILL.md`, and `.claude/rules/code-intelligence.md` for full details.
