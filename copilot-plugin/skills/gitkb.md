---
name: gitkb-knowledge-copilot
description: Copilot guidance for using GitKB knowledge workflows in a meta repo.
---

# GitKB Knowledge Skill for Copilot

This plugin should help Copilot work with GitKB knowledge workflows in a multi-repo workspace.

## Knowledge workflow guidance

- Use GitKB to store project context, tasks, and documentation.
- Prefer structured knowledge queries over freeform memory when available.
- If the workspace includes GitKB tools, surface KB commands that help discover tasks and context.

## Example goals

- Find the current active task or context document for this workspace.
- Use GitKB commands to verify what work is in progress.
- Keep knowledge docs aligned with code changes and workspace state.

## Source references

This skill should incorporate GitKB’s published guidance on:

- code intelligence queries such as `git-kb code callers`, `git-kb code callees`, `git-kb code impact`, and `git-kb code dead-code-explain`
- MCP tool support for linking code symbols to documents, tasks, and specs
- distributed knowledge workflows that work with `.kb/` and sparse sync semantics
