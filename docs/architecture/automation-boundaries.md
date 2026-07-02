---
slug: docs/architecture/automation-boundaries
title: "Automation Boundaries"
type: architecture
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/component-inventory
  - docs/architecture/control-flows
  - docs/architecture/evidence
---

# Automation Boundaries

## Boundary Matrix

| Area | Automated | Semi-automated | Manual or approval-gated | Not automated / gap |
| --- | --- | --- | --- | --- |
| GitKB task discovery | `git-kb board --json`, `git-kb ready`, `git-kb context --task`. | Agent chooses which active task to execute when user directs a priority. | Marking a task complete requires evidence and intentional status update. | Assignment field mismatch is still tracked by [[tasks/meta-gitkb-assignment-field-mismatch]]. |
| GitKB graph | Wikilinks and frontmatter references create graph edges on KB commit. | Agents decide which relationships to add. | Destructive KB reset/delete/filter require explicit care. | Docs outside GitKB need manual wikilink discipline. |
| Code intelligence | `git-kb code index`, `symbols`, `callers`, `callees`, `impact`, `entrypoints`, `flows`, `query`. | Agents choose target symbols and interpret unresolved-call health. | Refactor decisions require human/agent review of blast radius. | Markdown/config files are detected but not symbolized. |
| Meta repo discovery | `meta project list --json` reads `.meta.yaml` and returns the 14 declared peers. | Filters and command selection are operator/agent choices. | New crates must be created as independent repos and intentionally added to `.meta.yaml` and `.gitignore`. | Root `src/` peers outside `src/meta/.meta.yaml` are not all managed by the meta project list. |
| Command execution | `meta exec -- <command>` and plugin commands run plans across selected repos. | Plugin planning is automated; command choice is not. | Destructive commands should be reviewed and scoped. | Bare `meta <non-plugin-command>` is not the canonical path. |
| Plugin routing | `meta` discovers plugins and routes claimed commands. | Plugin install/update/search are command-driven. | Plugin trust and marketplace policy are governed by active plugin tasks. | Unified meta-plugin control plane is still in flight. |
| MCP | `meta-mcp` and `git-kb mcp` expose tools to assistants. | Client registration and ownership policy are configured. | `meta plugin doctor-mcp --server gitkb` validates the single-owner rule and reports owner/conflict files. | Stale live MCP processes still require runtime PID/session inspection before force restarts. |
| Release bundle | `build-local-ubuntu-release.sh` reads the release catalog and builds/stages selected rows. | `FXRUN_RELEASE_COMPONENTS` filters rows for proof runs. | Host mismatch and destructive release cleanup are explicit decisions. | GitKB source repo is a copied binary until a cataloged source peer exists. |
| Yazelix runtime | Catalog stages Yazelix binaries and selected runtime assets. | Runtime materialization and local generated state still need per-tool validation. | Desktop/session live tests are manual/interactive. | Generated runtime health is outside this meta docs task. |
| Codex workflow | `.codex/instructions/` requires GitKB-first and scoped commits. | Agent must select and run the right skill/CLI workflow. | User approval gates major recovery/destructive changes. | Cross-agent enforcement is policy plus hooks, not a proof of perfect compliance. |

## Practical Rules

- Use GitKB CLI for KB work, task state, context, and graph evidence.
- Use GitKB code intelligence before refactors or source changes.
- Use `meta project list --json` and `.meta.yaml` for meta-managed peer truth.
- Use the release catalog for portable release component truth.
- Do not hand-maintain maps that GitKB can generate; cite the generating command
  in [[docs/architecture/gitkb-generated-maps]].
- Do not invent missing architecture. Record gaps as follow-up tasks.

## Approval-Gated Examples

The following actions are intentionally not treated as routine automation:

- Destructive Git operations such as reset, hard delete, history rewrite, or
  forced push.
- Removing or replacing peer repo state.
- Changing global Codex/MCP/plugin ownership.
- Marking a KB task complete without checked acceptance criteria and completion
  evidence.
- Publishing PRs or releases when the user has requested a different publish
  policy.
