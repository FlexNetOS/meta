---
id: 019f2141-bd43-7541-96a8-1c790838f1de
slug: context/immutable/project-brief
title: "Project Brief"
type: brief
status: draft
priority: medium
---

# Project Brief

Meta is the upstream gitkb/meta control-plane repository for a Rust multi-repository management CLI. It lets independent repositories keep their own git histories while being operated as one coordinated workspace through the `meta` CLI.

## Core Purpose

- Manage a graph of independent child repositories declared in `.meta.yaml`.
- Clone, inspect, build, test, query, snapshot, and coordinate those repositories without turning them into a monorepo.
- Provide subprocess plugins and MCP integration so humans and agents can work safely across multi-repo systems.

## Foundational Constraints

- This root is a meta-repo, not a monorepo.
- Each `.meta.yaml` project is an independent git repository with its own remote, commits, and history.
- The root Cargo workspace exists for local build convenience only.
- New crates/packages must be separate repos under gitkb and then added to `.meta.yaml` and `.gitignore`.
- The root mirror should stay aligned with upstream gitkb/meta unless making an explicit upstream change.
- Do not add `.codex` to the root mirror; it is not part of upstream source.

## Primary Users

- Engineers maintaining multi-repo Rust and mixed-language workspaces.
- AI agents that need structured, safe, observable access to multi-repo operations.

## Source Evidence

AGENTS.md, CLAUDE.md, README.md, .meta.yaml, docs/architecture_overview.md, docs/agent_workflows.md, and .kb/AGENTS.md.
