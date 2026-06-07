---
name: meta-codex-rust-env
description: Use to verify or explain the seven-layer Codex Rust environment for the FlexNetOS meta workspace.
---

The seven layers are:

1. Instructions, guidance, and memory in `AGENTS.md`, `CLAUDE.md`, and `.agent/skills-catalog.md`.
2. Runtime config and custom agents in `.codex/config.toml` and `.codex/agents/`.
3. Slash commands and prompt templates: built-in Codex `/` commands plus `.codex/prompts/`.
4. Repo-scoped Codex skills in `.agents/skills/`.
5. Repo-scoped Codex plugin marketplace in `.agents/plugins/`.
6. Hooks, rules, and permissions in `.codex/hooks.json`, `.codex/rules/*.rules`, and policy docs.
7. Tools, MCP, subagents, and automation through `agent codex`, `meta mcp`, configured MCP servers, and custom agents.

Run `agent codex inventory` or `agent --json codex inventory` to verify the current state.
Run `agent codex install-prompts` to sync checked-in prompt templates into `~/.codex/prompts/` so they appear as `/prompts:*` after a Codex restart.
Do not remove or change `.claude/` while maintaining this layer.
