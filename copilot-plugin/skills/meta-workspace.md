---
name: meta-workspace-copilot
description: Copilot guidance for navigating meta repository workspaces and using meta CLI commands.
---

# Meta Workspace Skill for Copilot

This workspace is a meta repository. It manages multiple independent child repositories through a single `.meta` or `.meta.yaml` manifest.

## Use `meta` instead of direct `git`

In a meta repo, `meta` commands operate across every child repository:

```bash
meta project list
meta git status
meta exec -- <command>
```

These commands help Copilot:

- discover workspace structure
- identify which repos are affected by a change
- avoid missing changes in nested repos

## Key Copilot guidance

- Always run `meta project list` first to see the full repo graph.
- Use `meta git status` to check workspace-wide state before editing.
- When making a change, ask whether other repos depend on the modified repo.
- Use `meta --tag` or `meta --exclude` to scope commands when needed.

## What this plugin should enable

- workspace management across multi-repo projects
- safe cross-repo changes
- consistent use of the `meta` toolchain
