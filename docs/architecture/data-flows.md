---
slug: docs/architecture/data-flows
title: "Data Flow Graphs"
type: architecture
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/component-inventory
  - docs/architecture/control-flows
  - docs/architecture/diagrams
  - docs/architecture/gitkb-generated-maps
---

# Data Flow Graphs

## GitKB Document And Task Data

```
User / Codex request
    |
    v
git-kb context --task <slug> --code-refs
    |
    +--> .kb/store/commits/*.json
    +--> .kb/store/refs/document-tips.json
    +--> .kb/.cache/gitkb.db
    |
    v
.kb/workspaces/main/<slug>.md
    |
    v
git-kb commit -m "... [[task]]" <slug>
    |
    +--> frontmatter/body persisted
    +--> wikilinks extracted as graph edges
    +--> status/board/context become queryable
```

Generated maps for this flow are owned by `git-kb graph`, `git-kb board`,
`git-kb list --json`, and `git-kb context`. See
[[docs/architecture/gitkb-generated-maps]].

## Code Intelligence Data

```
Rust source files under src/meta peer dirs
    |
    v
git-kb code index
    |
    +--> symbols
    +--> call edges
    +--> imports
    +--> entrypoints
    +--> flows
    |
    v
git-kb code symbols/callers/callees/impact/doctor/query
    |
    v
docs and tasks cite generated evidence instead of copying full maps
```

Current proof from `git-kb code stats --json`:

- `symbol_count`: 1429
- `file_count`: 314
- `call_edge_count`: 2787
- `unresolved_call_count`: 11517
- deep support for Rust; Markdown, YAML, JSON, TOML, Makefile, and Bash are
  detected but not symbolized.

## Meta Control Data

```
.meta.yaml
    |
    v
meta project list --json
    |
    +--> 14 declared projects
    +--> project paths
    +--> SSH remotes
    |
    v
meta plugin routing / meta exec -- <command>
    |
    v
loop_lib execution plan over selected repos
```

The key invariant is that `.meta.yaml` describes independent repos. The root
Cargo workspace is a build convenience, not a monorepo boundary.

## Release Data

```
src/flexnetos_runner/release/catalog.tsv
    |
    v
scripts/build-local-ubuntu-release.sh
    |
    +--> cargo rows: build --release --manifest-path <manifest> --locked
    +--> copy-bin rows: copy executable payloads
    +--> asset profiles: copy runtime assets such as yazelix-runtime
    |
    v
release/staging/<release>/bin
release/staging/<release>/provenance/catalog.tsv
release/staging/<release>/provenance/components/<name>/source.env
    |
    v
portable release tarball
```

The release catalog is the source of truth for what must compile or be staged.
Do not infer release membership from local PATH alone.

## Codex And MCP Data

```
.codex/instructions/*.md
    |
    v
Codex session behavior
    |
    +--> GitKB CLI commands
    +--> GitKB MCP tools when registered
    +--> source edits through workspace files
    |
    v
KB commits and source commits with [[task]] traceability
```

The current Codex instruction surface says: GitKB first, use code intelligence
instead of text-only caller searches, and scope each KB commit to the touched
document.
