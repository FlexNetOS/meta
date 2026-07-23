---
id: 019f2142-35e7-7f41-b61b-0ed1cf22820f
slug: context/extensible/product
title: "Product Context"
type: context
status: draft
priority: medium
---

# Product Context

## Problem Space

Meta exists because multi-repo systems need cohesive operations without sacrificing independent git history, ownership boundaries, CI, and release flows. It aims to make multi-repo architectures feel operationally close to monorepos while preserving separate repositories.

## Product Capabilities

- Clone a meta repo and its declared children.
- Run commands across repositories with filtering, recursion, JSON output, and parallelism.
- Use plugins for domain-specific command routing such as git, project, and rust workflows.
- Capture/restore workspace snapshots for safer batch work.
- Expose MCP tools for AI agents to inspect, search, build, test, and coordinate repositories.
- Install Claude Code skills and rules for agent workflow guidance.

## Current Product State

README and docs describe a mature v0.2.x product with many completed roadmap items. The live installed version is 0.2.22. Remaining source-backed cleanup is around consistency and packaging rather than defining the product from scratch.

## Open Product Gaps From Source Scan

- Release/install artifacts appear to omit the built-in `meta-rust` plugin.
- Some docs and skills reference stale command forms.
- Legacy org references remain from earlier naming.
- Verification paths differ between CI, hooks, and Makefile.

## Source Evidence

README.md, docs/advanced_usage.md, docs/agent_workflows.md, docs/mcp_server.md, docs/claude_code_skills.md, CHANGELOG.md, and tasks/meta-clean-foundation-build-order.
