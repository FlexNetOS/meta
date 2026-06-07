# Codex Environment

This directory is the repo-scoped Codex layer for the FlexNetOS meta workspace.

Seven layers:

1. `.claude/` and `claude-plugin/` remain the Claude source surface.
2. `.codex/config.toml` and `.codex/hooks.json` provide Codex runtime config.
3. `.agents/skills/` provides Codex-native equivalents for meta workflows.
4. `.agents/plugins/marketplace.json` exposes the local Codex plugin.
5. `meta_*` repos and `meta-plugins/` provide the Rust meta CLI/plugin surface.
6. `commands/`, `hooks_hub/`, `plugin_hub/`, and `tool_hub/` provide hub registries.
7. `agent codex inventory` and `agent codex stop` provide Rust validation and hooks.

Claude auxiliary workflow parity:

- `.claude/skills/explore/SKILL.md`, `.claude/skills/understand/SKILL.md`, `.claude/skills/before-refactor/SKILL.md`, and `.claude/rules/code-intelligence.md` are exposed through `$gitkb`.
- `.claude/agents/meta-worker.md` is exposed through `$meta-workspace` and `$meta-worktree` as an explicit Codex subagent/worktree workflow.

Do not remove or rewrite `.claude/` for Codex parity. Treat `.claude/` as a source to mirror, not as a generated target.
