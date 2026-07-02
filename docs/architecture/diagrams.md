---
slug: docs/architecture/diagrams
title: "Architecture Diagrams"
type: architecture
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/component-inventory
  - docs/architecture/data-flows
  - docs/architecture/control-flows
---

# Architecture Diagrams

## Workspace Topology

```
/home/flexnetos/FlexNetOS
|
+-- usr/bin/
|   +-- git-kb
|   +-- meta
|   +-- meta-git
|   +-- meta-mcp
|   +-- meta-project
|   +-- meta-rust
|   +-- loop
|   +-- agent
|   +-- bun
|   +-- bunx
|
+-- release/
|   +-- staging/<release>/provenance/catalog.tsv
|
+-- src/
    +-- meta/                  control-plane repo
    |   +-- .meta.yaml          14 peer declarations
    |   +-- .kb/                GitKB store, skills, context
    |   +-- .codex/             Codex instructions and skill adapters
    |   +-- docs/
    |   |   +-- gitkb/
    |   |   +-- architecture/
    |   +-- loop_lib/           meta-managed peer checkout
    |   +-- meta_cli/           meta-managed peer checkout
    |   +-- ...
    |
    +-- flexnetos_runner/       release runner repo
    +-- envctl/                 environment/secrets/toolchain repo
    +-- yazelix/                runtime repo
    +-- yazelix-helix/          editor runtime repo
    +-- beads_rust/             issue tracker repo
    +-- rtk-tokenkill/          RTK repo
    +-- nu_plugin/              CodeDB/Nushell repo
```

## Meta Project Dependency Shape

```
Foundation:
  loop_lib              -> provides loop-lib
  meta_plugin_protocol  -> provides plugin-protocol
  meta_core             -> provides meta-core
  meta_git_lib          -> provides meta-git-lib

Mid-level:
  loop_cli              -> loop-lib
  meta_cli              -> meta-core + plugin-protocol + loop-lib

Top-level:
  meta_git_cli          -> plugin-protocol + meta-git-lib + meta-cli + loop-lib
  meta_project_cli      -> plugin-protocol + meta-cli + meta-git-lib
  meta_rust_cli         -> plugin-protocol + meta-cli
  meta_mcp              -> meta-cli

Standalone/assets:
  agent
  claude-plugins
  codex-plugins
  meta-plugins
```

## Command Routing

```
User / Codex
    |
    v
meta CLI
    |
    +-- reads .meta.yaml
    |
    +-- discovers plugins
    |
    +-- applies filters
    |
    +-- plugin command -------------------+
    |                                     |
    |                                     v
    |                              subprocess plugin
    |                                     |
    |                                     v
    |                              execution plan
    |
    +-- meta exec -- command -------------+
                                          |
                                          v
                                      loop_lib
                                          |
                                          v
                            selected independent repos
```

## GitKB Task And Graph Flow

```
Task doc with frontmatter and body
    |
    +-- [[wikilinks]]
    +-- parent / references / blocks fields
    +-- [[code:path::symbol]]
    |
    v
git-kb commit
    |
    +-- document version
    +-- graph edges
    +-- board/search/context indexes
    |
    v
git-kb graph / board / context / ready
```

## Agent Harness And MCP Flow

```
Codex session
    |
    +-- .codex/instructions/codex-rules.md
    +-- .codex/instructions/gitkb-process.md
    |
    v
GitKB-first workflow
    |
    +-- git-kb CLI
    +-- optional git-kb MCP
    +-- GitKB skills under .kb/skills/
    |
    v
KB task/context/code intelligence
    |
    v
source/docs edits with [[task]] traceability
```

## Release Build Flow

```
src/flexnetos_runner/release/catalog.tsv
    |
    v
build-local-ubuntu-release.sh
    |
    +-- cargo row
    |     +-- cargo build --release --manifest-path ... --locked
    |     +-- copy named target/release bins
    |
    +-- copy-bin row
    |     +-- copy executable from workspace/global path
    |
    +-- asset profile
          +-- copy runtime assets, e.g. yazelix-runtime
    |
    v
release/staging/<release>/
    |
    +-- bin/
    +-- provenance/catalog.tsv
    +-- provenance/components/<component>/source.env
    |
    v
flexnetos-ubuntu-26.04-x86_64-<timestamp>.tar.gz
```

## Yazelix Runtime Inclusion

```
src/yazelix
    |
    +-- Cargo manifest: rust_core/Cargo.toml
    +-- runtime assets: assets, configs, shells, zellij_config, yazi
    |
    v
release catalog row: yazelix
    |
    +-- yzx
    +-- yzx_control
    +-- yzx_core
    +-- yazelix_zellij_config_pack
    +-- yzx_repo_maintainer
    +-- yzx_repo_validator
    +-- asset_profile=yazelix-runtime
    |
    v
release stage share/yazelix + bin payloads
```
