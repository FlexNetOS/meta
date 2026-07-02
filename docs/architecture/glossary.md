---
slug: docs/architecture/glossary
title: "FlexNetOS Meta Glossary"
type: reference
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/component-inventory
  - docs/architecture/gitkb-generated-maps
---

# Glossary

## Core Terms

| Term | Definition | Evidence |
| --- | --- | --- |
| FlexNetOS | The local workspace rooted at `/home/flexnetos/FlexNetOS`, containing peer source repos, workspace-owned binaries in `usr/bin`, local release output, toolchains, and runtime state. | `find /home/flexnetos/FlexNetOS/src -maxdepth 2 -name .git`; `find /home/flexnetos/FlexNetOS/usr/bin -maxdepth 1 -type f -executable`. |
| Meta | The multi-repo control plane in `src/meta`. It reads `.meta.yaml`, discovers plugins, filters projects, and runs commands across independent repos. | `README.md`; `docs/architecture_overview.md`; `.meta.yaml`; `meta project list --json`. |
| Meta-repo | A repository that declares and coordinates independent child repos. It is not a monorepo. Each child has separate `.git`, remotes, commits, and history. | `AGENTS.md`; `.meta.yaml`; `meta project list --json`. |
| Peer repo | Any independent Git repo under `src/` or declared by `src/meta/.meta.yaml`. Examples: `loop_lib`, `meta_plugin_protocol`, `envctl`, `yazelix`. | `.meta.yaml`; `find /home/flexnetos/FlexNetOS/src -maxdepth 2 -name .git`. |
| Control plane | The orchestration layer that turns user/agent intent into repo discovery, command plans, GitKB task state, release builds, and runtime actions. | `README.md`; `docs/architecture_overview.md`; [[docs/architecture/control-flows]]. |
| GitKB | The local knowledge-base tool and binary at `/home/flexnetos/FlexNetOS/usr/bin/git-kb`. It owns KB tasks, context, document graph, code intelligence, workspace checkout, and KB commits. | `.kb/AGENTS.md`; `.codex/instructions/gitkb-process.md`; `git-kb context --task ...`. |
| KB task | A GitKB document of type `task`, with frontmatter, status, acceptance criteria, progress, evidence, and wikilinks. | [[tasks/meta-system-architecture-documentation]]; `.kb/skills/gitkb/SKILL.md`. |
| Wikilink | A `[[slug]]` link that GitKB can extract into graph edges at commit time. Docs use the same notation for durable traversal. | `docs/gitkb/core-concepts-knowledge-graph.md`; `git-kb graph tasks/meta-system-architecture-documentation --json`. |
| Code intelligence | GitKB's code index: symbols, callers, callees, impact, dead code, entrypoints, flows, hotspots, refs, stats, and doctor. | [[docs/architecture/gitkb-generated-maps]]. |

## Agent And Tool Terms

| Term | Definition | Evidence |
| --- | --- | --- |
| Codex | Local agent runtime using `.codex/instructions/`, `.codex/skills/`, MCP tools, and workspace policies to work through GitKB and source code. | `.codex/instructions/codex-rules.md`; `.codex/instructions/gitkb-process.md`. |
| MCP | Model Context Protocol. Meta exposes `meta-mcp`; GitKB exposes `git-kb mcp`; Codex can connect to MCP servers for tools. | `docs/mcp_server.md`; `docs/gitkb/getting-started-mcp-setup.md`; `docs/gitkb/reference-mcp-tools.md`. |
| Agent harness | The assistant-specific rules, skills, and MCP config that teach an agent to use GitKB and code intelligence. | `docs/gitkb/reference-agent-harnesses.md`; `.codex/instructions/`. |
| Meta-plugin | A meta-owned plugin/control-plane direction intended to unify plugin, marketplace, MCP, and harness assets across agents. | `docs/agent_plugin_control_plane.md`; [[tasks/meta-unified-agent-plugin-control-plane]]. |
| Beads | Local issue/task tracker shipped by release catalog as `br` from `src/beads_rust`. | `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv`. |
| RTK | Token compression/proxy CLI shipped as `rtk` from `src/rtk-tokenkill`. | `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv`. |

## Release And Runtime Terms

| Term | Definition | Evidence |
| --- | --- | --- |
| Release catalog | Tab-separated component manifest at `src/flexnetos_runner/release/catalog.tsv`; it declares Cargo builds and copy-bin payloads for local Ubuntu release bundles. | `src/flexnetos_runner/release/catalog.tsv`. |
| flexnetos_runner | Local release runner and GitHub/local execution plane. Catalog builds `fxrun`, `fxrun-actions`, and `fxrun-dispatch`. | `src/flexnetos_runner/release/catalog.tsv`; `scripts/build-local-ubuntu-release.sh`. |
| Portable state | Release output that stages workspace-owned binaries and provenance so installs avoid relying on user globals or Nix store paths. | [[tasks/meta-release-catalog-portable-tools]]; `src/flexnetos_runner/scripts/build-local-ubuntu-release.sh`. |
| Yazelix | Local runtime surface cataloged from `src/yazelix`, including `yzx`, `yzx_control`, config pack, validators, and runtime assets. | `src/flexnetos_runner/release/catalog.tsv`; [[docs/architecture/component-inventory]]. |
| envctl | Environment manager and local secrets/toolchain plane cataloged from `src/envctl`. | `src/flexnetos_runner/release/catalog.tsv`. |
| Bun frontdoor | Workspace-owned Bun runtime staged from `.toolchains/.bun/bin/bun` and exposed through `usr/bin/bun`/`usr/bin/bunx`. | `src/flexnetos_runner/release/catalog.tsv`; `find /home/flexnetos/FlexNetOS/usr/bin`. |
