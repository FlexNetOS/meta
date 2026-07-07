---
title: Architecture Glossary
status: draft
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
---

# Glossary

- meta: the control-plane CLI and plugin workspace.
- meta repo: the src/meta repository itself.
- peer repo: an independent repo registered in .meta.yaml.
- plugin: a subprocess-backed command surface such as git, project, or rust.
- meta exec: the pass-through path that runs arbitrary shell commands.
- GitKB: the durable task, context, and document store.
- KB task: a tracked work item in GitKB with workflow state and evidence.
- architecture docs: source-derived docs that explain the system in linked form.
- Yazelix: the workspace and toolchain frontdoor used for some local runtime work.
- envctl: the meta-owned environment manager and table source of truth.
- MCP: Model Context Protocol, used for agent-facing tool surfaces.
- release catalog: the repo inventory and packaging metadata used by release tooling.
