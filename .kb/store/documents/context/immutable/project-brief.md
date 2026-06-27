---
id: 019ea99b-d008-7950-beff-a111c4bd410b
slug: context/immutable/project-brief
title: "Project Brief"
type: brief
status: active
priority: high
---

## Vision
Meta makes multi-repo architectures feel like monorepos without the downsides of monorepos. It treats repositories as independent peers while enabling cohesive batch operations.

## Core Purpose
- Bridge the gap between monorepo and multi-repo architectures.
- Enable parallel execution across dozens of repositories.
- Provide a robust plugin system for language-agnostic extensibility.
- Act as an AI-native foundation for autonomous agents navigating multi-repo codebases.

## Foundational Decisions
- **Rust-based**: For performance, safety, and single-binary distribution.
- **JSON-centric**: Communication between components and with external tools (AI) uses structured JSON.
- **Plugin/Host Separation**: The CLI routes commands; plugins plan them; the loop engine executes them.

