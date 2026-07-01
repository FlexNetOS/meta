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
---

Validate GitKB graph traversal for the local MCP setup. This references [[tasks/gitkb-mcp-daemon-local-setup]], [[specs/gitkb-local-mcp-graph-architecture]], and [[incidents/gitkb-daemon-background-residency]]. It also links the code entrypoint [[code:meta_mcp/src/main.rs::function::main]]. Current root Git proof was taken at commit `e798ac9d7b3e`.

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
- `meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb init codex` verified
  Codex scaffold was present across all 16 targets.
- `meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb init claude`,
  `git-kb init cursor`, and `git-kb init windsurf` created the missing harness
  skill/rule links across child repos.
- `meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb code index --force
  --prune --index-only` indexed code across all 16 targets.
- `/home/flexnetos/FlexNetOS/var/tmp/gitkb-code-proof.sh` ran
  `git-kb code stats`, `git-kb code doctor`, `git-kb code callers`, and
  `git-kb code impact` in each target through `meta exec`.
- `meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb verify` returned `ok`
  for all 16 targets.
- `meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb doctor` passed all
  targets, with expected warnings for child repo discovery config and non-code
  plugin repos.

Observed graph edges include `references`, `references_code`, `implements`,
`depends_on`, `blocks`/`blocked_by`, and `parent_of`/`child_of`.

Installed-version notes for GitKB `0.2.12`:

- `--direction inbound` / `--direction outbound` from current docs is not
  accepted; this build uses `--direction in` / `--direction out`.
- `git-kb diff --commit` reports that commit-based diff is not implemented.
- `[[commit:<git-sha>]]` did not produce a visible `references_commit` edge in
  this build, so this task records Git commit proof as plain text instead of a
  graph edge.
- `resolves: [...]` was not retained in this task because this build did not
  emit a visible `resolves` edge; the incident relation is carried by a normal
  wikilink reference.
