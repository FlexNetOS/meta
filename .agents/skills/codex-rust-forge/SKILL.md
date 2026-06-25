---
name: codex-rust-forge
description: Build complex Codex workflows as Rust plus mlua artifacts. Use when asked for Codex Rust forge workflows, multi-agent or swarm orchestration, subagents, hooks, skills, plugins, MCP/apps, codex exec JSON loops, app-server/SDK integrations, or any reusable Codex automation that must be generated as Rust+Lua/mlua rather than prose only.
---

# Codex Rust Forge

Use this skill to turn a complex Codex operating workflow into a production-ready Rust project that embeds a Lua workflow specification with `mlua`.

## Required Process

1. Refresh current evidence before designing:
   - Run the OpenAI Codex manual helper from `$openai-docs` or otherwise read current official Codex docs.
   - Check `openai/codex` GitHub sources when implementation details matter.
   - Check current `mlua` docs before choosing crate features or API patterns.
   - Inspect local workspace surfaces: `.agents/skills`, `.codex/prompts`, `.codex/agents`, `.codex/hooks.json`, `.agents/plugins/marketplace.json`, and relevant config.
2. Create a feature matrix before generation. Cover every relevant surface:
   - instructions and repo guidance: `AGENTS.md`
   - skills: `.agents/skills/<name>/SKILL.md`
   - slash prompt templates: `.codex/prompts/*.md`
   - custom agents and subagents: `.codex/agents/*.toml`, built-in `worker` and `explorer`, `/agent`
   - swarms and multi-model routing: explicit fan-out, model selection, reasoning effort, and consolidation
   - hooks and policy: `.codex/hooks.json`, `.codex/rules`, permissions, sandbox, approvals
   - MCP and apps/connectors: configured MCP servers, app/plugin dependencies
   - tools and helpers: shell commands, MCP tools, connector tools, generated Rust helpers, and Lua DSL helpers
   - plugins and marketplaces: `.agents/plugins/marketplace.json`, `.codex-plugin/plugin.json`
   - noninteractive loops: `codex exec --json`, `--output-schema`, `-o`, resume, stdin piping
   - app-server and SDK loops: thread, turn, item streams, schemas, approvals, interrupts
   - review, CI, GitHub Action, verification, memory, and final audit
3. Generate Rust+mlua output, not just markdown. Use `scripts/forge_codex_workflow.py` unless the repo already has a stronger generator.
4. Keep the generated Lua workflow declarative. Rust owns parsing, validation, rendering, and any shell execution. Lua owns the workflow graph, agents, tools, and policy declarations.
5. Validate the generated project:
   - Run `cargo fmt --check` and `cargo check` in the generated crate when dependencies can be fetched.
   - Run the generated binary against `workflows/main.lua` and inspect the JSON plan.
   - If full Cargo validation is not possible, run the generator and inspect the generated files plus explain the missing gate.

## Generator

Run:

```bash
python3 .agents/skills/codex-rust-forge/scripts/forge_codex_workflow.py \
  --name codex-workflow-forge \
  --output /tmp/codex-workflow-forge
```

The generator creates:

- `Cargo.toml` with `mlua = { version = "0.11", features = ["lua54", "vendored", "serde"] }`
- `src/main.rs`, a Rust workflow compiler
- `workflows/main.lua`, an exhaustive Codex workflow DSL example
- `schemas/codex-workflow.schema.json`, the emitted plan shape

## Output Contract

Every delivered workflow must include:

- A Rust crate that compiles the Lua workflow into JSON.
- A Lua file that declares agents, feature coverage, steps, dependencies, tools, outputs, and validation gates.
- A short explanation of how to run the generated crate.
- A verification note showing which gates passed.

If the user asks for a checked-in slash command, create or update `.codex/prompts/<command>.md` so it invokes `$codex-rust-forge` and passes the user's target workflow as arguments.

## References

Read `references/research.md` when you need the source-backed feature matrix or need to update it from fresher docs.
