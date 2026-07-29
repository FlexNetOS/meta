---
title: Automation Boundaries
status: draft
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
---

# Automation Boundaries

| Area | Mode | Notes |
| --- | --- | --- |
| KB task tracking | Semi-automated | GitKB writes the source of truth, but status changes still need verification. |
| Repo inventory | Automated | meta project list exposes the peer graph. |
| Command routing | Automated | meta dispatches to plugin or meta exec paths. |
| Build/test gates | Automated | CI and local commands verify repo health. |
| Architecture docs | Semi-automated | Content can be derived, but source evidence and graph links must be curated. |
| Risky updates | Approval-gated | Destructive or topology-changing work should be explicitly reviewed. |
| Runtime config materialization | Automated after declarative input | Config should be rendered from tables or source-owned inputs. |

## Rules

- Keep source-owned files separate from generated runtime state.
- Prefer table-driven or manifest-driven updates over ad hoc config edits.
- Treat KB status as a claim that must be proven with current evidence.
