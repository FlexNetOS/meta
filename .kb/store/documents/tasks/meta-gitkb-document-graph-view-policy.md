---
id: 019f21fe-38b2-7393-a199-4db8e5a2e264
slug: tasks/meta-gitkb-document-graph-view-policy
title: "Define GitKB document graph and view policy"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Define the GitKB document, frontmatter, graph, and saved-view policy that agents and `meta-plugin` must follow when creating or updating KB content.

# Source Evidence

- `docs/gitkb/core-concepts-documents.md` defines document types, required and optional frontmatter, lifecycle, assignment, views, and relationships.
- `docs/gitkb/core-concepts-knowledge-graph.md` defines graph edge types, wikilinks, code refs, and graph-aware status/diff.
- `docs/gitkb/getting-started-quick-start.md` shows common document, workspace, board, search, graph, and sync flows.
- `docs/gitkb/guides-agent-workflows.md` defines context-first, document-first, traceability, task lifecycle, and ready/assign workflows.

# Document Model Covered

- Types: `task`, `spec`, `incident`, `note`, `context`, `view`
- Required frontmatter: `slug`, `title`, `type`
- Optional frontmatter: `status`, `priority`, `tags`, `parent`
- Lifecycle: `draft -> backlog -> active -> blocked -> completed`
- Relationships: `references`, `parent_of`, `implements`, `blocks`, `depends_on`, `resolves`, `references_code`, `references_commit`
- Wikilinks: `[[slug]]`, `[[code:path::Symbol]]`, `[[commit:...]]`
- Views: fenced `gitkb-view` blocks
- Assignment: `assigned_to`, `git-kb assign`, `git-kb unassign`
- Workspace path in docs: `.kb/workspace/`
- Workspace path observed in this repo: `.kb/workspaces/main/`

# Commands Covered

- `git-kb create --type task --slug ... --title ...`
- `git-kb show <slug>`
- `git-kb list --type task --status active`
- `git-kb checkout <slug>`
- `git-kb commit -m "..."`
- `git-kb board --group-by priority`
- `git-kb board --sort-by updated --sort-direction desc`
- `git-kb board --save <view>`
- `git-kb view <view>`
- `git-kb list --save <view>`
- `git-kb search <query>`
- `git-kb search --hybrid`
- `git-kb graph <slug> --direction both`
- `git-kb graph --critical-path`
- `git-kb graph --format plan`
- `git-kb status`
- `git-kb diff`
- `git-kb ready --json`
- `git-kb context --compact --token-budget 4000`

# Acceptance Criteria

- [x] Agent instructions require task/document creation before implementation.
- [x] Task updates include acceptance criteria and evidence before completion.
- [x] Commits and task docs use `[[slug]]` links for traceability.
- [x] Code-sensitive tasks use `[[code:...]]` references where useful.
- [x] Saved views use documented `gitkb-view` shape or live `git-kb board --save` output.
- [x] View/list/board saved query behavior is verified before generators create saved views.
- [x] Search policy covers keyword, remote, hybrid, vector-weight, and keyword-weight modes before automation uses them.
- [x] Agents use `--json` for machine parsing where available.
- [x] `ready`, `assign`, and `unassign` behavior is tested before multi-agent automation depends on it.
- [x] Agent instructions use the live workspace path proved in this repo, not a stale docs path.

# Policy

- Work starts from a KB task or document unless the user explicitly asks for read-only exploration.
- Completion requires acceptance criteria and completion evidence in the document body before status changes.
- Use `[[slug]]` relationships for traceability; add `[[code:...]]` links for code-sensitive tasks after code paths/symbols are known.
- Saved views and automated view creation require live `board/list/view --save` proof before generators write view documents.
- Search automation must prefer local keyword/search first. Remote, hybrid, vector-weight, and keyword-weight behavior require explicit live proof and remote/embedding readiness.
- Multi-agent assignment flows remain gated until `assign` and `unassign` are tested against a disposable or explicitly approved task.

# Completion Evidence

- 2026-07-02: `git-kb graph tasks/meta-gitkb-docs-command-config-extraction --json` showed the docs extraction task as the parent of the current task rail and preserved links to all child tasks.
- 2026-07-02: `git-kb ready --json` returned `tasks/meta-agent-architecture-codex-integration` as the current ready task, proving ready output shape without mutating assignments.
- 2026-07-02: `git-kb list --type task --status active --json` returned only the gated Claude retirement task from committed state, confirming this workflow should not depend on uncommitted active checkout state for board automation.
- 2026-07-02: The live workspace checkout path is `.kb/workspaces/main/`, not docs-stale `.kb/workspace/`.

# Progress Log

### 2026-07-02
- Completed document/graph/view policy with live graph, ready, list, and workspace-path proof.
