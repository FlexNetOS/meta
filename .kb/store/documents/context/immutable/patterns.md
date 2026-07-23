---
id: 019f2141-e14f-7661-a5ce-3dd3020a95d9
slug: context/immutable/patterns
title: "System Patterns"
type: patterns
status: draft
priority: medium
---

# System Patterns

## Meta-Repo Discipline

- Treat root `gitkb/meta` as a control-plane repository and every listed child as an independent repository.
- Use `meta project list --json`, `meta exec -- ...`, and plugin commands to operate across repos intentionally.
- Avoid raw monorepo assumptions, broad destructive commands, or root-local overlay additions.

## Command Routing

- `meta` loads `.meta.yaml`, applies filters, discovers plugins, then routes commands.
- Plugin commands such as `meta git`, `meta project`, and `meta rust` own their command namespaces.
- Arbitrary commands use `meta exec -- <command>`.
- Bare non-plugin commands are not the canonical documented execution path.

## Plugin Architecture

- Plugins are subprocess executables using JSON over stdin/stdout.
- Built-in plugin surfaces are git, project, and rust.
- Plugin discovery includes project/local plugin directories and PATH.

## Safety Patterns

- Check state before work: KB status, root git status, meta project inventory, and per-repo git status.
- Use snapshots or precise filters before risky multi-repo operations.
- Record non-trivial work in GitKB tasks before source changes.
- Complete task body evidence before marking status complete.

## Known Drift To Resolve

The active task records source-backed gaps around release packaging, command-surface documentation drift, org migration residue, and CI/local verification parity.

## Source Evidence

.kb/AGENTS.md, AGENTS.md, CLAUDE.md, README.md, docs/plugin_development.md, docs/architecture_overview.md, .claude/rules/*.md, and tasks/meta-clean-foundation-build-order.
