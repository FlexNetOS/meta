---
slug: docs/architecture/control-flows
title: "Control Flows"
type: architecture
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/data-flows
  - docs/architecture/diagrams
  - docs/architecture/automation-boundaries
---

# Control Flows

## Task Execution Flow

```
User objective
    |
    v
Find/choose KB task
    |
    v
git-kb context --task <slug> --code-refs
git-kb graph <slug> --json
git-kb checkout <slug>
    |
    v
Implement source/docs changes
    |
    v
Run verification commands
    |
    v
Update task progress/evidence/checklist
    |
    v
git-kb commit -m "... [[<slug>]]" <slug>
    |
    v
Only mark completed when evidence proves every acceptance criterion
```

This flow is the workflow used for [[tasks/meta-system-architecture-documentation]].

## Meta Command Routing Flow

`README.md` and `docs/architecture_overview.md` describe `meta` as a command
router on top of a loop engine:

```
meta <command> [args]
    |
    v
Parse CLI args
    |
    v
Load .meta.yaml / .meta.yml / .meta
    |
    v
Apply filters, tags, include/exclude
    |
    v
Discover subprocess plugins
    |
    +--> plugin claims command
    |       |
    |       v
    |   plugin returns execution plan
    |       |
    |       v
    |   loop_lib executes plan across dirs
    |
    +--> explicit meta exec -- <command>
            |
            v
        loop_lib executes command across selected dirs
```

Bare non-plugin commands are not the canonical documented path. Use plugin
commands such as `meta git status` or explicit `meta exec -- <command>`.

## GitKB Code Intelligence Flow

```
Need to understand code
    |
    v
git-kb code index / stats / doctor
    |
    v
Choose symbol/file
    |
    +--> git-kb code symbols --file <file> --json
    +--> git-kb code callers <symbol> --json
    +--> git-kb code callees <symbol> --json
    +--> git-kb code impact <file> --json
    +--> git-kb code entrypoints --refresh --json
    +--> git-kb code flows --refresh --json
    +--> git-kb code query hotspots --json
```

Example evidence:

- `meta_cli/src/main.rs::function::main` has zero callers and 20 callees.
- `git-kb code impact meta_cli/src/main.rs --json --compact` returned 9 direct
  caller entries for symbols in that file.
- `git-kb code query hotspots --json --limit 10` identified hotspots including
  `meta_core/src/lock.rs::method::LockGuard.path`, `agent/src/guard.rs::function::evaluate_command`,
  and `meta_cli/src/subprocess_plugins.rs::method::SubprocessPluginManager.new`.

## Local Release Flow

```
fxrun / local operator
    |
    v
src/flexnetos_runner/scripts/build-local-ubuntu-release.sh
    |
    v
Host check: Linux x86_64 Ubuntu 26.04 unless mismatch allowed
    |
    v
Read FXRUN_RELEASE_CATALOG or default catalog.tsv
    |
    +--> cargo component
    |       |
    |       v
    |   cargo build --release --manifest-path <manifest> --locked
    |       |
    |       v
    |   copy named bins into stage/bin
    |
    +--> copy-bin component
            |
            v
        copy executable payload into stage/bin
    |
    v
Stage provenance and optional assets
    |
    v
Create portable release archive
```

The release flow is catalog-driven. `FXRUN_RELEASE_COMPONENTS` is a filter, not
the source of truth.
