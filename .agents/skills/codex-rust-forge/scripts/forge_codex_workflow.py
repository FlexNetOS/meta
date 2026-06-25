#!/usr/bin/env python3
"""Generate a Rust + mlua Codex workflow forge project."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


MAIN_RS = r'''use std::{collections::HashSet, env, fs, path::PathBuf};

use mlua::{prelude::*, Table};
use serde::Serialize;

#[derive(Debug, Serialize)]
struct Workflow {
    name: String,
    objective: String,
    features: Vec<String>,
    agents: Vec<Agent>,
    steps: Vec<Step>,
    verification: Vec<String>,
}

#[derive(Debug, Serialize)]
struct Agent {
    id: String,
    role: String,
    model: Option<String>,
    instructions: String,
}

#[derive(Debug, Serialize)]
struct Step {
    id: String,
    kind: String,
    agent: Option<String>,
    instructions: String,
    depends_on: Vec<String>,
    tools: Vec<String>,
    outputs: Vec<String>,
    command: Option<String>,
    schema: Option<String>,
}

const REQUIRED_FEATURES: &[&str] = &[
    "instructions",
    "skills",
    "slash-prompts",
    "custom-agents",
    "subagents",
    "swarms",
    "multi-model-routing",
    "hooks",
    "permissions",
    "mcp",
    "apps",
    "tools",
    "helpers",
    "plugins",
    "codex-exec-json",
    "output-schema",
    "app-server",
    "sdk",
    "review",
    "ci-github",
    "memory",
    "verification",
];

fn main() -> LuaResult<()> {
    let script = env::args_os()
        .nth(1)
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from("workflows/main.lua"));
    let source = fs::read_to_string(&script).map_err(LuaError::external)?;

    let lua = Lua::new();
    install_forge_api(&lua)?;
    lua.load(&source)
        .set_name(script.to_string_lossy())
        .exec()?;

    let workflow_table: Table = lua.globals().get("WORKFLOW")?;
    let workflow = parse_workflow(workflow_table)?;
    validate_workflow(&workflow)?;
    println!(
        "{}",
        serde_json::to_string_pretty(&workflow).map_err(LuaError::external)?
    );
    Ok(())
}

fn install_forge_api(lua: &Lua) -> LuaResult<()> {
    let forge = lua.create_table()?;
    forge.set(
        "workflow",
        lua.create_function(|_, table: Table| Ok(table))?,
    )?;
    forge.set("agent", lua.create_function(|_, table: Table| Ok(table))?)?;
    forge.set("step", lua.create_function(|_, table: Table| Ok(table))?)?;
    lua.globals().set("forge", forge)?;
    Ok(())
}

fn parse_workflow(table: Table) -> LuaResult<Workflow> {
    Ok(Workflow {
        name: table.get("name")?,
        objective: table.get("objective")?,
        features: string_vec(&table, "features")?,
        agents: table_vec(&table, "agents", parse_agent)?,
        steps: table_vec(&table, "steps", parse_step)?,
        verification: string_vec(&table, "verification")?,
    })
}

fn parse_agent(table: Table) -> LuaResult<Agent> {
    Ok(Agent {
        id: table.get("id")?,
        role: table.get("role")?,
        model: table.get("model")?,
        instructions: table.get("instructions")?,
    })
}

fn parse_step(table: Table) -> LuaResult<Step> {
    Ok(Step {
        id: table.get("id")?,
        kind: table.get("kind")?,
        agent: table.get("agent")?,
        instructions: table.get("instructions")?,
        depends_on: string_vec(&table, "depends_on")?,
        tools: string_vec(&table, "tools")?,
        outputs: string_vec(&table, "outputs")?,
        command: table.get("command")?,
        schema: table.get("schema")?,
    })
}

fn table_vec<T>(
    parent: &Table,
    key: &str,
    parser: impl Fn(Table) -> LuaResult<T>,
) -> LuaResult<Vec<T>> {
    let Some(table) = parent.get::<Option<Table>>(key)? else {
        return Ok(Vec::new());
    };
    table
        .sequence_values::<Table>()
        .map(|entry| parser(entry?))
        .collect()
}

fn string_vec(parent: &Table, key: &str) -> LuaResult<Vec<String>> {
    let Some(table) = parent.get::<Option<Table>>(key)? else {
        return Ok(Vec::new());
    };
    table.sequence_values::<String>().collect()
}

fn validate_workflow(workflow: &Workflow) -> LuaResult<()> {
    let mut seen = HashSet::new();
    for step in &workflow.steps {
        if !seen.insert(step.id.as_str()) {
            return Err(LuaError::external(format!(
                "duplicate step id: {}",
                step.id
            )));
        }
    }

    for step in &workflow.steps {
        for dependency in &step.depends_on {
            if !seen.contains(dependency.as_str()) {
                return Err(LuaError::external(format!(
                    "step {} depends on missing step {}",
                    step.id, dependency
                )));
            }
        }
    }

    let features: HashSet<&str> = workflow.features.iter().map(String::as_str).collect();
    let missing: Vec<&str> = REQUIRED_FEATURES
        .iter()
        .copied()
        .filter(|feature| !features.contains(feature))
        .collect();
    if !missing.is_empty() {
        return Err(LuaError::external(format!(
            "workflow is missing required Codex features: {}",
            missing.join(", ")
        )));
    }

    if workflow.verification.is_empty() {
        return Err(LuaError::external(
            "workflow must declare verification gates",
        ));
    }

    Ok(())
}
'''


MAIN_LUA = r'''WORKFLOW = forge.workflow({
  name = "codex-workflow-forge",
  objective = "Compile an exhaustive Codex workflow into a validated Rust-owned JSON plan.",
  features = {
    "instructions",
    "skills",
    "slash-prompts",
    "custom-agents",
    "subagents",
    "swarms",
    "multi-model-routing",
    "hooks",
    "permissions",
    "mcp",
    "apps",
    "tools",
    "helpers",
    "plugins",
    "codex-exec-json",
    "output-schema",
    "app-server",
    "sdk",
    "review",
    "ci-github",
    "memory",
    "verification",
  },
  agents = {
    forge.agent({
      id = "root",
      role = "orchestrator",
      model = "current-codex-default",
      instructions = "Own requirements, source audit, planning, final integration, and completion proof.",
    }),
    forge.agent({
      id = "researcher",
      role = "explorer",
      model = "current-codex-default",
      instructions = "Read official OpenAI docs, GitHub sources, local config, and dependency docs.",
    }),
    forge.agent({
      id = "builder",
      role = "worker",
      model = "current-codex-default",
      instructions = "Generate Rust+mlua code, scripts, prompt templates, schemas, and tests.",
    }),
    forge.agent({
      id = "reviewer",
      role = "reviewer",
      model = "current-codex-default",
      instructions = "Review correctness, safety, feature coverage, and validation evidence.",
    }),
  },
  steps = {
    forge.step({
      id = "recall-context",
      kind = "memory",
      agent = "root",
      instructions = "Recall project memory and AGENTS.md instructions before work.",
      depends_on = {},
      tools = { "icm recall-context", "rg", "sed" },
      outputs = { "memory summary", "local constraints" },
    }),
    forge.step({
      id = "source-audit",
      kind = "research",
      agent = "researcher",
      instructions = "Refresh official Codex manual, openai/codex GitHub sources, app-server docs, and mlua docs.",
      depends_on = { "recall-context" },
      tools = { "openai-docs", "web", "context7", "gh", "rg" },
      outputs = { "source matrix", "feature matrix" },
    }),
    forge.step({
      id = "surface-inventory",
      kind = "inspect",
      agent = "researcher",
      instructions = "Inspect .agents, .codex, MCP, hooks, prompts, custom agents, plugins, and local slash command conventions.",
      depends_on = { "source-audit" },
      tools = { "rg", "find", "git status" },
      outputs = { "local surface inventory" },
    }),
    forge.step({
      id = "model-routing",
      kind = "multi-model",
      agent = "root",
      instructions = "Assign model and reasoning intent per agent or step, preserve current defaults unless the user requests pinned models, and consolidate results back through the root agent.",
      depends_on = { "surface-inventory" },
      tools = { "/model", ".codex/agents/*.toml", "model_reasoning_effort" },
      outputs = { "multi-model routing table", "swarm fan-in policy" },
    }),
    forge.step({
      id = "parallel-design",
      kind = "subagent",
      agent = "root",
      instructions = "Spawn a bounded swarm of focused subagents for research, implementation, safety, and validation when the host exposes subagent tools.",
      depends_on = { "model-routing" },
      tools = { "spawn_agent", "wait_agent", "/agent" },
      outputs = { "merged subagent findings" },
    }),
    forge.step({
      id = "generate-rust-mlua",
      kind = "build",
      agent = "builder",
      instructions = "Create the Rust crate, Lua DSL, schemas, and command specs. Keep Lua declarative and Rust authoritative.",
      depends_on = { "parallel-design" },
      tools = { "apply_patch", "cargo fmt", "cargo check" },
      outputs = { "Cargo.toml", "src/main.rs", "workflows/main.lua", "schemas/codex-workflow.schema.json" },
    }),
    forge.step({
      id = "noninteractive-loop",
      kind = "codex-exec",
      agent = "builder",
      instructions = "Emit commands for codex exec --json, --output-schema, -o, stdin piping, and resume-safe multi-stage loops.",
      depends_on = { "generate-rust-mlua" },
      tools = { "codex exec --json", "jq" },
      outputs = { "machine-readable Codex command specs" },
      command = "codex exec --json --output-schema schemas/codex-workflow.schema.json -o out/plan.json \"Execute the forged workflow\"",
      schema = "schemas/codex-workflow.schema.json",
    }),
    forge.step({
      id = "app-server-loop",
      kind = "app-server",
      agent = "builder",
      instructions = "Emit app-server JSON-RPC thread/start, turn/start, stream, interrupt, and completion integration notes.",
      depends_on = { "generate-rust-mlua" },
      tools = { "codex app-server generate-json-schema", "websocket or stdio JSONL" },
      outputs = { "app-server integration plan" },
    }),
    forge.step({
      id = "policy-hooks",
      kind = "hooks",
      agent = "builder",
      instructions = "Declare hook and permission checkpoints for SessionStart, PreToolUse, PostToolUse, SubagentStart, SubagentStop, Stop, sandbox, and approvals.",
      depends_on = { "generate-rust-mlua" },
      tools = { "/hooks", "/permissions", "hooks.json" },
      outputs = { "hook policy checklist" },
    }),
    forge.step({
      id = "plugin-packaging",
      kind = "distribution",
      agent = "builder",
      instructions = "If reuse beyond this repo is needed, package skill, prompts, MCP config, and hooks as a plugin marketplace entry.",
      depends_on = { "policy-hooks" },
      tools = { "$plugin-creator", "/plugins", ".codex-plugin/plugin.json" },
      outputs = { "plugin packaging plan" },
    }),
    forge.step({
      id = "review-verify",
      kind = "verification",
      agent = "reviewer",
      instructions = "Run fmt/check/tests, compile the Lua plan, review diff, and prove every required feature is covered.",
      depends_on = { "noninteractive-loop", "app-server-loop", "plugin-packaging" },
      tools = { "cargo fmt --check", "cargo check", "cargo run", "/review", "git diff" },
      outputs = { "verification report", "completion audit" },
    }),
  },
  verification = {
    "The Lua workflow includes every REQUIRED_FEATURES entry.",
    "Every dependency references an existing step.",
    "The Rust binary emits valid pretty JSON.",
    "cargo fmt --check passes.",
    "cargo check passes when dependency fetching is available.",
  },
})
'''


SCHEMA = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "title": "Codex Rust Forge Workflow",
    "type": "object",
    "required": ["name", "objective", "features", "agents", "steps", "verification"],
    "additionalProperties": False,
    "properties": {
        "name": {"type": "string"},
        "objective": {"type": "string"},
        "features": {"type": "array", "items": {"type": "string"}},
        "agents": {
            "type": "array",
            "items": {
                "type": "object",
                "required": ["id", "role", "instructions"],
                "additionalProperties": False,
                "properties": {
                    "id": {"type": "string"},
                    "role": {"type": "string"},
                    "model": {"type": ["string", "null"]},
                    "instructions": {"type": "string"},
                },
            },
        },
        "steps": {
            "type": "array",
            "items": {
                "type": "object",
                "required": [
                    "id",
                    "kind",
                    "agent",
                    "instructions",
                    "depends_on",
                    "tools",
                    "outputs",
                    "command",
                    "schema",
                ],
                "additionalProperties": False,
                "properties": {
                    "id": {"type": "string"},
                    "kind": {"type": "string"},
                    "agent": {"type": ["string", "null"]},
                    "instructions": {"type": "string"},
                    "depends_on": {"type": "array", "items": {"type": "string"}},
                    "tools": {"type": "array", "items": {"type": "string"}},
                    "outputs": {"type": "array", "items": {"type": "string"}},
                    "command": {"type": ["string", "null"]},
                    "schema": {"type": ["string", "null"]},
                },
            },
        },
        "verification": {"type": "array", "items": {"type": "string"}},
    },
}


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", value.strip().lower()).strip("-")
    if not slug:
        raise SystemExit("name must contain at least one alphanumeric character")
    return slug


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def generate(name: str, output: Path) -> None:
    crate = slugify(name)
    output.mkdir(parents=True, exist_ok=True)
    write(
        output / "Cargo.toml",
        f"""[package]
name = "{crate}"
version = "0.1.0"
edition = "2021"

[dependencies]
mlua = {{ version = "0.11", features = ["lua54", "vendored", "serde"] }}
serde = {{ version = "1", features = ["derive"] }}
serde_json = "1"
""",
    )
    write(output / "src/main.rs", MAIN_RS)
    write(output / "workflows/main.lua", MAIN_LUA.replace("codex-workflow-forge", crate))
    write(
        output / "schemas/codex-workflow.schema.json",
        json.dumps(SCHEMA, indent=2, sort_keys=True) + "\n",
    )
    write(
        output / ".gitignore",
        """/target
/out
""",
    )
    write(
        output / "RUN.md",
        f"""# {crate}

Run:

```bash
cargo fmt --check
cargo check
cargo run -- workflows/main.lua > out/plan.json
```

The workflow is declared in Lua and compiled by Rust through `mlua`.
""",
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--name", default="codex-workflow-forge")
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    generate(args.name, args.output)
    print(args.output)


if __name__ == "__main__":
    main()
