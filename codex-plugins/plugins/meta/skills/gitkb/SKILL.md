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
- `git kb create note --slug notes/<slug> --title "Brief title" --body "..."`
- `git kb commit -m "message"`
- `git kb callers <symbol>`
- `git kb symbols <path>`

Codex note capture:

- Use `/prompts:kb-note` for durable note capture into `meta/.kb`; the checked-in template lives at `.codex/prompts/kb-note.md`.
- Notes belong under the `notes/` namespace. If a user gives a bare slug, normalize it to `notes/<slug>`.
- CLI fallback when the MCP create tool is unavailable:
  ```bash
  git kb create note --slug notes/<slug> --title "Brief title" --body "..." --tags codex,note --json
  git kb commit -m "docs(kb): add note notes/<slug>"
  ```
- After creating or changing a note, verify `.kb/store/**` remains trackable and include durable KB store changes in the normal git commit/PR. Do not leave notes as loose markdown or untracked ignored state.

Code-intelligence workflows inherited from `.claude`:

- Explore by concept: use semantic KB search, then inspect symbols, callers, and callees.
- Understand a file or symbol: list symbols, inspect callers/callees, and check KB document references.
- Before refactor: find the exact symbol, inspect all callers, run impact analysis, and list affected files.
- Prefer `kb_symbols`, `kb_callers`, `kb_callees`, `kb_impact`, `kb_dead_code`, and `kb_symbol_refs` over grep for code structure.

Follow `.kb/AGENTS.md`, `.claude/skills/gitkb/SKILL.md`, `.claude/skills/explore/SKILL.md`, `.claude/skills/understand/SKILL.md`, `.claude/skills/before-refactor/SKILL.md`, and `.claude/rules/code-intelligence.md` for full details.
