---
id: 019f1f24-04c2-7d62-a5bb-9faaa00f7391
slug: context/immutable/patterns
title: "System Patterns"
type: patterns
status: draft
priority: medium
---

# System Patterns

## Meta-Repo Pattern

This repository is a coordination root for independent peer repositories. The
root has its own Git history; each child project has a separate Git history.
Do not flatten peer repos into root commits, and do not use submodules as the
normal integration mechanism.

## Execution Pattern

`meta` follows a three-layer execution model:

1. `meta_cli` reads `.meta.yaml`, parses global flags, filters projects, and
   selects a command path.
2. Plugins plan specialized operations and return execution plans.
3. `loop_lib` runs commands across the selected directories and aggregates
   results.

## Plugin Pattern

Plugins are process-isolated executables. They support discovery through
`--meta-plugin-info` and execution through `--meta-plugin-exec`, with JSON as
the stable protocol format. This avoids ABI coupling and allows plugins to be
implemented in any language.

## Documentation Pattern

`.context/` contains legacy branch-local context. GitKB is the durable context
source for agent handoff. When GitKB has no `context/` documents, create the
seven required context documents and commit them before broad implementation.

## Branch Discipline

The clean-room branch is the source for this recovery lane. Do not inventory or
clone child repos from `main` when working this branch. A workspace containing
`rtk-tokenkill`, `shimmy`, `meta_plugin_api`, or `meta_dashboard_cli` in
`Cargo.toml` belongs to another branch context.

## Local Install Pattern

Workspace-local tools should be fronted from `/home/flexnetos/FlexNetOS/usr/bin`
when this workspace owns the install surface. Avoid `$HOME/.local/bin` for
GitKB/bootstrap work in this recovery lane.
