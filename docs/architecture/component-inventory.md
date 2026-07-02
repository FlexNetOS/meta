---
slug: docs/architecture/component-inventory
title: "Component Inventory"
type: inventory
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/automation-boundaries
  - docs/architecture/data-flows
  - docs/architecture/gitkb-generated-maps
---

# Component Inventory

## Meta-Managed Repos

`meta project list --json` reports 14 projects under `src/meta`; `.meta.yaml`
is the control-plane declaration.

| Project | Path | Remote | Provides | Depends on |
| --- | --- | --- | --- | --- |
| `loop_lib` | `loop_lib` | `git@github.com:FlexNetOS/loop_lib.git` | `loop-lib` | none |
| `meta_plugin_protocol` | `meta_plugin_protocol` | `git@github.com:FlexNetOS/meta_plugin_protocol.git` | `plugin-protocol` | none |
| `meta_core` | `meta_core` | `git@github.com:FlexNetOS/meta_core.git` | `meta-core` | none |
| `meta_git_lib` | `meta_git_lib` | `git@github.com:FlexNetOS/meta_git_lib.git` | `meta-git-lib` | none |
| `loop_cli` | `loop_cli` | `git@github.com:FlexNetOS/loop_cli.git` | binary crate | `loop-lib` |
| `meta_cli` | `meta_cli` | `git@github.com:FlexNetOS/meta_cli.git` | `meta-cli` | `meta-core`, `plugin-protocol`, `loop-lib` |
| `meta_git_cli` | `meta_git_cli` | `git@github.com:FlexNetOS/meta_git_cli.git` | plugin binary | `plugin-protocol`, `meta-git-lib`, `meta-cli`, `loop-lib` |
| `meta_project_cli` | `meta_project_cli` | `git@github.com:FlexNetOS/meta_project_cli.git` | plugin binary | `plugin-protocol`, `meta-cli`, `meta-git-lib` |
| `meta_rust_cli` | `meta_rust_cli` | `git@github.com:FlexNetOS/meta_rust_cli.git` | plugin binary | `plugin-protocol`, `meta-cli` |
| `meta_mcp` | `meta_mcp` | `git@github.com:FlexNetOS/meta_mcp.git` | MCP binary | `meta-cli` |
| `agent` | `agent` | `git@github.com:FlexNetOS/agent.git` | agent binary | standalone |
| `claude-plugins` | `claude-plugins` | `git@github.com:FlexNetOS/claude-plugins.git` | plugin assets | standalone |
| `codex-plugins` | `codex-plugins` | `git@github.com:FlexNetOS/codex-plugins.git` | plugin assets | standalone |
| `meta-plugins` | `meta-plugins` | `git@github.com:FlexNetOS/meta-plugins.git` | plugin assets | standalone |

## Wider FlexNetOS Source Repos

`find /home/flexnetos/FlexNetOS/src -maxdepth 2 -name .git` currently proves
these independent repos at workspace level:

- `beads_rust`
- `envctl`
- `flexnetos_runner`
- `loop_lib`
- `meta`
- `meta_plugin_protocol`
- `nu_plugin`
- `rtk-tokenkill`
- `yazelix-helix`
- `yazelix`

The overlap matters: `src/meta/.meta.yaml` manages the upstream meta workspace,
while the root `src/` workspace also hosts FlexNetOS runtime and release peers.

## Release Catalog Components

The authoritative release inventory is
`/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv`.

| Component | Kind | Source | Bins | Role |
| --- | --- | --- | --- | --- |
| `flexnetos_runner` | cargo | `src/flexnetos_runner` | `fxrun`, `fxrun-actions`, `fxrun-dispatch` | Local release runner and execution plane. |
| `meta` | cargo | `src/meta` | `meta`, `meta-git`, `meta-mcp`, `meta-project`, `meta-rust`, `loop` | Meta control plane and loop CLI. |
| `meta-agent` | cargo | `src/meta/agent` | `agent` | Meta agent binary outside the meta workspace package set. |
| `gitkb` | copy-bin | `usr/bin/git-kb` | `git-kb` | Local GitKB binary used by agent sessions. |
| `codex` | copy-bin | `/home/flexnetos/.codex/packages/standalone/current/bin/codex` | `codex` | Codex standalone binary. |
| `envctl` | cargo | `src/envctl` | `envctl`, `envctl-gui`, `secretd`, `secretctl` | Environment and local secrets/toolchain plane. |
| `beads_rust` | cargo | `src/beads_rust` | `br` | Local issue tracker. |
| `rtk-tokenkill` | cargo | `src/rtk-tokenkill` | `rtk` | Token compression/proxy CLI. |
| `yazelix` | cargo | `src/yazelix` | `yzx`, `yzx_control`, `yzx_core`, `yazelix_zellij_config_pack`, `yzx_repo_maintainer`, `yzx_repo_validator` | Local Yazelix runtime and support binaries. |
| `yazelix-helix` | cargo | `src/yazelix-helix` | `hx`, `hx-loader` | Yazelix Helix runtime. |
| `nu_plugin` | cargo | `src/nu_plugin` | `codedb`, `nu_plugin_codedb` | CodeDB/Nushell plugin workspace. |
| `loop_lib` | cargo | `src/loop_lib` | source-only | Standalone source-only compile check. |
| `meta_plugin_protocol` | cargo | `src/meta_plugin_protocol` | source-only | Standalone source-only compile check. |
| `bun` | copy-bin | `.toolchains/.bun/bin/bun` | `bun` | Workspace-owned Bun runtime. |

## Workspace-Owned Binaries

`/home/flexnetos/FlexNetOS/usr/bin` currently includes:

```
agent
bun
bunx
git-kb
kache-rustc-wrapper
loop
meta
meta-git
meta-mcp
meta-project
meta-release
meta-rust
```

## Agent Harnesses And Docs Surfaces

| Surface | Role |
| --- | --- |
| `.kb/AGENTS.md` | Project instructions for GitKB-first agent work. |
| `.kb/skills/` | Canonical GitKB workflows such as `gitkb`, `kb-start`, `kb-progress`, and code-intelligence skills. |
| `.codex/instructions/codex-rules.md` | Codex session rules: GitKB-first, code intelligence, scoped KB commits. |
| `.codex/instructions/gitkb-process.md` | Codex process discipline for session start, work, and completion. |
| `.context/` | Older context docs for meta project vision and task notes. |
| `docs/gitkb/` | Extracted GitKB docs and CLI/MCP/code-intelligence references. |
| `docs/architecture/` | This durable architecture docs KB. |
