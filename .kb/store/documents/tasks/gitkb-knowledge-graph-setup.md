---
id: 019f1f77-19e7-7592-a067-5f34bf094edf
slug: tasks/gitkb-knowledge-graph-setup
title: "Set up GitKB knowledge graph proof"
type: task
status: active
priority: high
parent: tasks/gitkb-local-agent-platform
tags: [gitkb, graph, mcp]
blocked_by: [tasks/gitkb-mcp-daemon-local-setup]
implements: [specs/gitkb-local-mcp-graph-architecture]
depends_on: [tasks/gitkb-mcp-daemon-local-setup]
resolves: [incidents/gitkb-daemon-background-residency]
---

Validate GitKB graph traversal for the local MCP setup. This references [[tasks/gitkb-mcp-daemon-local-setup]], [[specs/gitkb-local-mcp-graph-architecture]], and [[incidents/gitkb-daemon-background-residency]]. It also links the code entrypoint [[code:meta_mcp/src/main.rs::function::main]] and current meta Git commit [[commit:868edfee4e5104a18c6818f2fb604305598fb01c]].

## Verification

Commands run with `/home/flexnetos/FlexNetOS/usr/bin/git-kb` from
`/home/flexnetos/FlexNetOS/src/meta`:

- `git-kb status` and `git-kb status --json` previewed graph additions before
  commit.
- `git-kb diff tasks/gitkb-knowledge-graph-setup` showed the body/frontmatter
  changes that created graph edges.
- `git-kb graph tasks/gitkb-knowledge-graph-setup` showed the full local graph.
- `git-kb graph tasks/gitkb-knowledge-graph-setup --direction in` showed
  inbound edges.
- `git-kb graph tasks/gitkb-knowledge-graph-setup --direction out` showed
  outbound edges.
- `git-kb graph tasks/gitkb-knowledge-graph-setup --json` produced structured
  graph output.
- `git-kb graph tasks/gitkb-local-agent-platform --depth 2` showed the epic
  view.
- `git-kb graph tasks/gitkb-knowledge-graph-setup --rel-type references_code`
  showed the code-symbol edge.
- `git-kb graph --scope active --json` showed active-task graph scope.
- `git-kb log -n 5` is the supported local form for limited history.

Observed graph edges include `references`, `references_code`, `implements`,
`depends_on`, `blocks`/`blocked_by`, and `parent_of`/`child_of`.

Installed-version notes for GitKB `0.2.12`:

- `--direction inbound` / `--direction outbound` from current docs is not
  accepted; this build uses `--direction in` / `--direction out`.
- `git-kb diff --commit` reports that commit-based diff is not implemented.
- `[[commit:<git-sha>]]` is accepted by status as `commit:<sha>` under
  `references`, but graph display does not show a separate `references_commit`
  edge and commit emits one unresolved target warning.
- `resolves: [...]` remained in frontmatter but did not appear in graph output.
