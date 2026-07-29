---
title: Architecture Diagrams
status: draft
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
---

# Diagrams

## Workspace Topology

    FlexNetOS/
    |-- src/meta
    |   |-- .kb
    |   |-- .codex
    |   |-- docs
    |   |-- child repo links from .meta.yaml
    |-- src/envctl
    |-- src/nu_plugin
    |-- src/teri

## Control-Plane Command Flow

    user
      |
      v
    meta / git-kb / envctl
      |
      +--> plugin subprocess
      |
      +--> meta exec / loop engine
      |
      +--> generated output or KB mutation

## GitKB Task Flow

    draft -> active -> verified -> completed
      ^                         |
      |                         v
      +------ stale / blocked <-+

## Agent and MCP Flow

    agent session
      |
      +--> Codex config
      |
      +--> MCP server wrapper
      |
      +--> workspace tool/runtime

## Release Flow

    catalog + runner scripts
      |
      v
    dependency graph
      |
      v
    build/test/package
      |
      v
    install/update artifacts

## Yazelix Integration Flow

    workspace frontdoor
      |
      v
    Yazelix runtime
      |
      v
    toolchain + generated session state
