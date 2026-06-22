# Codex Rust Forge Research

Last refreshed: 2026-06-22.

## Source Priority

1. OpenAI Codex manual: `https://developers.openai.com/codex/codex-manual.md`
2. OpenAI Codex GitHub repository: `https://github.com/openai/codex`
3. Codex app-server implementation docs: `https://github.com/openai/codex/tree/main/codex-rs/app-server`
4. Codex Rust source for multi-agent defaults: `codex-rs/core/src/config/mod.rs`
5. mlua crate docs: `https://docs.rs/crate/mlua/latest`

Refresh these sources before treating names, flags, or schemas as current.

## Current Codex Feature Map

| Area | Current artifact or command | Forge handling |
| --- | --- | --- |
| Repo instructions | `AGENTS.md` | Require local instruction scan before generation. |
| Skills | `.agents/skills/<skill>/SKILL.md`, `$skill-name`, `/skills` | Generate reusable workflow guidance and optional scripts/references. |
| Slash commands | Built-ins plus checked-in `.codex/prompts/*.md` templates installed to `/prompts:*` | Generate prompt templates that call the skill and pass the target. |
| Custom agents | `.codex/agents/*.toml`; built-ins include `default`, `worker`, `explorer` | Model agent roles in Lua and map each role to custom or built-in agents. |
| Subagents | Explicit user-requested parallel agent workflows; `/agent` switches threads | Represent fan-out steps with `kind = "subagent"` and dependencies. |
| Swarms | Parallel subagent teams with explicit consolidation and bounded depth/concurrency | Represent as fan-out plus fan-in steps, never open-ended recursion. |
| Multi-model routing | `/model`, custom agent `model`, `model_reasoning_effort`, provider config | Declare model intent per agent and step; preserve current defaults unless the user asks to pin. |
| Hooks | `.codex/hooks.json` or inline config; events include `SessionStart`, `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `SubagentStart`, `SubagentStop`, `Stop` | Model lifecycle guardrails and validation hooks as first-class steps. |
| Permissions | sandbox and approval policy from CLI/config and runtime overrides | Require least-privilege policy per generated step. |
| MCP | `/mcp`, `mcp_servers`, plugin-bundled MCP servers | Declare MCP dependency and required tool names in Lua. |
| Apps/connectors | `/apps`, plugin-bundled app dependencies | Declare connector use separately from public web/search. |
| Tools and helpers | Shell commands, MCP tools, connector tools, Rust helper functions, Lua `forge.*` helpers | Keep execution in Rust/Codex-controlled layers; Lua declares intent. |
| Plugins | `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`, `/plugins` | Use when distribution beyond one repo is required. |
| Noninteractive loop | `codex exec --json`, `--output-schema`, `-o`, stdin piping, resume | Generate stable shell command specs and JSON schema outputs. |
| App-server | `codex app-server`, JSON-RPC threads, turns, items, streaming notifications | Generate integration steps for products needing live event streams. |
| SDK | TypeScript `@openai/codex-sdk`, Python `openai-codex` | Prefer SDK for CI/product automation unless Rust+mlua output is required. |
| Review | `/review`, GitHub review integrations | Include final review and diff audit steps. |
| CI/GitHub | `openai/codex-action` for Actions; patch artifact pattern | Keep API key exposure isolated and open PRs from a separate write job. |
| Memory | `/memories`, project memory systems such as ICM | Include recall-before-work and store-after-completion gates when present. |

## Rust + mlua Notes

Use `mlua` 0.11 with `lua54`, `vendored`, and `serde` for a portable embedded Lua runtime. Rust should:

- create the `Lua` state with `Lua::new()`
- inject a `forge` helper table with Rust functions if needed
- load the Lua script with `lua.load(...).set_name(...).exec()`
- read globals or returned tables into typed Rust structs
- validate dependencies, feature coverage, and unique step IDs before rendering JSON

Avoid letting Lua run shell commands directly. Emit command specs from Lua and execute or review them from Rust or Codex-controlled tooling.
