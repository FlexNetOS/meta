---
id: 019ea99b-d03b-74d2-86d0-fba4c197634d
slug: context/immutable/patterns
title: "System Patterns"
type: patterns
status: active
priority: high
---

## Design Patterns

### 1. Peer-to-Peer Repositories
Unlike git submodules which are hierarchical and often fragile, Meta treats repositories as independent peers. The `.meta` file is the source of truth for repository location and relationship, but the repositories themselves remain standard git repos.

### 2. Planning vs. Execution (Plugin-Host Pattern)
- **Plugins** (e.g., `meta-git`) are "planners". They receive a command and project list, then return an execution plan (JSON).
- **Host** (`meta_cli`) and **Loop Engine** (`loop_lib`) are "executors". They take the plan and run the actual shell commands.
This separation ensures that plugins are pure functions and execution logic is centralized and optimized (parallelism, output capture).

### 3. AI-First Integration
Meta provides an MCP server and JSON output for every command. This pattern ensures that AI agents can interact with the system as easily as humans, using structured data instead of fragile screen scraping.

### 4. Recursive Discovery
Meta supports nested meta-repos. Using the `--recursive` flag, the CLI can descend into child repositories that also contain a `.meta` file, enabling hierarchical organization without losing the peer-to-peer flat structure benefits.

### 5. Manual Configuration as Source of Truth
Project addition and modification are driven by the `.meta.yaml` file. The CLI does not provide "magic" add commands that modify your config; instead, it provides `meta project check` and `meta git update` to synchronize the local filesystem with the desired state defined in the configuration.

### 6. Orphan Detection (Auto-Adoption)
When the CLI detects a `.meta` file in a subdirectory that is not tracked by the current workspace, it triggers "Orphan Detection". It warns the user and provides the exact snippet needed to "adopt" that repository into the meta-repo, maintaining workspace integrity.

### 7. Hybrid Workspace Integration (Meta-Repo vs Monorepo)
To balance build performance and independence, the meta-repo uses a hybrid Cargo workspace strategy:
- **Single-Package Repos**: Repos containing only a single `Cargo.toml` package (e.g., `rtk`, `teri`, `shimmy`) are added to the root `Cargo.toml` workspace `members`. This allows for unified `cargo build` and testing.
- **Multi-Package Workspaces**: Repos that are themselves Cargo workspaces (e.g., `RuVector`, `icm`, `weave`) are **excluded** from the root workspace. This prevents dependency version conflicts between large, independent projects.
- **Unified Orchestration**: Regardless of their inclusion in the root Cargo workspace, all projects are built via the `Makefile` and `meta exec`, ensuring that `make build-all` correctly builds every component in the ecosystem.

