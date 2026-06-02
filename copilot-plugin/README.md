# GitKB Copilot Plugin

This repository contains the scaffold for a GitKB Copilot plugin that brings multi-repo workspace management and knowledge workflows to GitHub Copilot.

This plugin is modeled on the existing `gitkb/claude-plugins` marketplace and the `meta` CLI ecosystem.

## What this plugin provides

- **Workspace management** via `meta` commands:
  - `meta project list`
  - `meta git status`
  - `meta git update`
  - `meta exec -- <command>`
- **Knowledge and context support** via GitKB knowledge workflows
- **Cross-repo safety guidance** for multi-repo changes

## Plugin manifest

The Copilot plugin manifest is stored at `.copilot-plugin/plugin.json` and declares the plugin metadata plus the available resources:

- `resources.skills` → `../skills/meta-workspace.md`, `../skills/gitkb.md`
- `resources.hooks` → `../hooks/hooks.json`

## Local meta plugin helper

A local helper script is provided at `copilot-plugin/meta-copilot`.
It can be used to inspect the Copilot manifest, list available skills, and summarize workspace state for agent integration.

Example usage:

```bash
./copilot-plugin/meta-copilot help
./copilot-plugin/meta-copilot manifest
./copilot-plugin/meta-copilot skills
./copilot-plugin/meta-copilot hooks
./copilot-plugin/meta-copilot summary
```

## Dependencies

These components are relevant to the implementation:

- `gitkb/meta_cli` — main meta CLI and plugin orchestration
- `gitkb/meta_project_cli` — project management plugin
- `gitkb/meta_mcp` — MCP server for AI integration
- `gitkb/gh-config-cli` — GitHub org config tooling for org-aware workflows

## Relevant GitKB sources

- GitKB Code Intelligence docs: https://gitkb.com/docs/core-concepts/code-intelligence/
- GitKB releases overview: https://github.com/gitkb/gitkb-releases/blob/main/README.md

These sources emphasize:

- code intelligence across a repo graph with call graph queries, callers, callees, impact, and dead code
- MCP-based tooling for agents and editor integration
- GitKB knowledge engineering as a distributed knowledge graph for tasks, docs, and decision support

## Getting started

1. Install or build the `meta` toolchain and ensure `meta` is in your PATH.
2. Add Copilot-specific plugin definitions and skill guidance to Copilot if supported.
3. Use this scaffold to define workspace and knowledge interactions analogously to the existing Claude plugin.

## Next steps

- Add Copilot-specific marketplace metadata and manifest support
- Implement skill and hook content for Copilot agent behavior
- Wire Copilot commands to the `meta` CLI and GitKB knowledge tools
- Add example usage for `meta` and `gh-config-cli` integration
