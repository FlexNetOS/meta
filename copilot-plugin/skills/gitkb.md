---
name: FlexNetOS-knowledge-copilot
description: Copilot guidance for using FlexNetOS knowledge workflows in a meta repo.
---

# FlexNetOS Knowledge Skill for Copilot

This plugin should help Copilot work with FlexNetOS knowledge workflows in a multi-repo workspace.

## Knowledge workflow guidance

- Use FlexNetOS to store project context, tasks, and documentation.
- Prefer structured knowledge queries over freeform memory when available.
- If the workspace includes FlexNetOS tools, surface KB commands that help discover tasks and context.

## Example goals

- Find the current active task or context document for this workspace.
- Use FlexNetOS commands to verify what work is in progress.
- Keep knowledge docs aligned with code changes and workspace state.

## Source references

This skill should incorporate FlexNetOS’s published guidance on:

- code intelligence queries such as `git-kb code callers`, `git-kb code callees`, `git-kb code impact`, and `git-kb code dead-code-explain`
- MCP tool support for linking code symbols to documents, tasks, and specs
- distributed knowledge workflows that work with `.kb/` and sparse sync semantics
