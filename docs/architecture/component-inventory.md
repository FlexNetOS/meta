---
title: Component Inventory
status: draft
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
---

# Component Inventory

## Workspace Repos

- agent
- claude-plugins
- codex-plugins
- loop_cli
- loop_lib
- meta-plugins
- meta_cli
- meta_core
- meta_git_cli
- meta_git_lib
- meta_mcp
- meta_plugin_protocol
- meta_project_cli
- meta_rust_cli

## Core Binaries and Surfaces

- meta
- meta-git
- meta-project
- meta-rust
- meta-mcp
- loop
- git-kb
- envctl
- yzx

## Functional Roles

| Component | Role |
| --- | --- |
| meta_cli | Parse args, load config, route commands |
| meta_core | Shared storage, locking, data-dir helpers |
| meta_plugin_protocol | JSON plugin contract |
| loop_lib | Multi-directory command execution engine |
| meta_git_cli | Git operations and workspace snapshots |
| meta_project_cli | Project inventory and health |
| meta_rust_cli | Rust/Cargo operations |
| meta_mcp | MCP tool server for agents |
