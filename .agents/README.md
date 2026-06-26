# Codex Environment

This directory is the repo-scoped Codex layer for the FlexNetOS meta workspace.

Seven layers:

1. Instructions, guidance, and memory: `AGENTS.md`, `CLAUDE.md`, and `.agent/skills-catalog.md`.
2. Runtime config and trust: `.codex/config.toml` plus project custom agents in `.codex/agents/`.
3. Slash command and prompt surface: built-in Codex `/` commands plus checked-in prompt templates under `.codex/prompts/`.
4. Skills: repo-scoped workflows in `.agents/skills/`.
5. Plugins and marketplace: `.agents/plugins/marketplace.json` and bundled plugins.
6. Hooks, rules, and permissions: `.codex/hooks.json`, `.codex/rules/*.rules`, and policy docs.
7. Tools, MCP, subagents, and automation: `agent codex`, `meta mcp`, configured MCP servers, and custom subagents.

Codex custom prompts are user-home scoped. To install the checked-in prompt templates as `/prompts:*` slash commands, run:

```bash
agent codex install-prompts
```

Then restart Codex and type `/prompts:`.

Checked-in prompt templates include:

- `/prompts:kb-note` — create durable git-kb notes under `meta/.kb`/`notes/` and verify `.kb/store` is committed, not invisible state.
- `/prompts:meta-status`, `/prompts:meta-upgrade`, `/prompts:meta-worker`, and `/prompts:codex-rust-forge` — existing meta/workflow entrypoints.

Claude auxiliary workflow parity:

- `.claude/skills/explore/SKILL.md`, `.claude/skills/understand/SKILL.md`, `.claude/skills/before-refactor/SKILL.md`, and `.claude/rules/code-intelligence.md` are exposed through `$gitkb`.
- `.claude/agents/meta-worker.md` is exposed through `$meta-workspace` and `$meta-worktree` as an explicit Codex subagent/worktree workflow.

Do not remove or rewrite `.claude/` for Codex parity. Treat `.claude/` as a source to mirror, not as a generated target.
`.agent/` is retained as an existing catalog source; `.agents/` is the Codex-native repo skill and plugin surface.
