<!-- Source: https://gitkb.com/docs/guides/agent-workflows/ -->
<!-- Snapshot: 2026-07-02 -->

# Agent Workflows

GitKB is designed for AI agents that lose context between sessions . Every session starts cold — GitKB provides the persistent memory layer.

GitKB supports Claude Code, Codex, Cursor, Windsurf, and generic MCP clients. The harness-specific setup differs, but the durable workflow is the same: read context, choose a task, make progress, and commit evidence back to the KB.

## The bootstrap flow

When an agent starts a new session, it follows this pattern:

1. Load context  — Read ` context/`  documents to understand the project

2. Check the board  — ` git-kb board`  to see active tasks and blockers

3. Claim work  — Pick up an active task or start a new one

4. Work with documentation  — Create/update documents as work progresses

5. Commit progress  — Save state so the next session can continue

The board gives agents (and humans) an instant snapshot of work state:

```
❯ git-kb board --titles
+------------------------------------+------------------------------------+------------------------------------+------------------------------------+
| DRAFT (8)                          | ACTIVE (3)                         | BLOCKED (1)                        | COMPLETED (12)                     |
+------------------------------------+------------------------------------+------------------------------------+------------------------------------+
| tasks/acme-15                      | tasks/acme-9                       | tasks/acme-11                      | tasks/acme-7                       |
|   Add WebSocket event streaming    |   OAuth 2.0 PKCE Integration       |   Deploy to production cluster     |   API rate limiting middleware     |
| tasks/acme-14                      | tasks/acme-10                      |                                    | tasks/acme-6                       |
|   Migrate user store to Postgres   |   Session encryption refactor      |                                    |   Batch job scheduler              |
| tasks/acme-13                      | tasks/acme-12                      |                                    | tasks/acme-5                       |
|   Add OpenTelemetry tracing        |   Token refresh middleware         |                                    |   Webhook delivery system          |
| tasks/acme-16                      |                                    |                                    | incidents/inc-003-token-expiry     |
|   GraphQL schema federation        |                                    |                                    |   Token expiry during long sessi…  |
+------------------------------------+------------------------------------+------------------------------------+------------------------------------+
```

An agent sees three active tasks, one blocked, and knows exactly where to pick up.

## AGENTS.md

GitKB projects include an ` AGENTS.md`  file in ` .kb/`  that instructs agents how to interact with the knowledge base. This file is loaded automatically by AI editors via MCP.

Key behaviors it establishes:

- Context validation  — Agents must load context before touching code

- Document-first workflow  — Create the task document before implementing

- Traceability  — Link commits to tasks with ` [[wikilinks]]`

## Skills and harnesses

GitKB skills are reusable workflow documents. The canonical skill source is ` .kb/skills/` ; Claude Code, Codex, Cursor, and Windsurf load assistant-specific forwarders or adapters from their own directories, while generic MCP clients use the same MCP tools with workflow instructions supplied by the project. This keeps the workflow consistent across agents.

Common skills used during real work:

Phase | Skills
Orient | ` gitkb` , ` kb-context` , ` kb-board` , ` kb-tasks`
Start work | ` kb-start` , ` kb-create` , ` kb-search`
Understand code | ` code-intelligence` , ` explore` , ` understand` , ` refactor-safety`
Track progress | ` kb-status` , ` kb-progress` , ` kb-review`
Finish | ` kb-close` , ` kb-commit` , ` kb-handoff`

## Context documents

Context documents in ` context/`  provide project understanding at three stability levels:

Level | Path | Changes | Examples
Immutable | ` context/immutable/` | Rarely | Project brief, architecture, patterns
Extensible | ` context/extensible/` | Sometimes | Product context, tech stack
Overridable | ` context/overridable/` | Often | Active work, progress tracking

## Task lifecycle

```
draft → backlog → active → blocked → completed
```

Agents update task status as they work, add progress logs, and check off acceptance criteria. This creates an audit trail that survives session restarts.

## Ready: deterministic task selection

Instead of reading the board manually, use ` git-kb ready`  to let GitKB pick the highest-priority unblocked task:

```
# Get the single best task to work on
git-kb ready

# Get top 3 candidates with score breakdown
git-kb ready --limit 3 --json

# Full context bundle: task body + graph neighbors + code refs
git-kb ready --context

# Include callers/callees of referenced symbols
git-kb ready --context --smart-code --budget 12000
```

The scoring algorithm considers priority, status, blocking relationships, and assignment. ` --json`  exposes the score breakdown for CI/orchestration:

```
# CI dispatch: pick next task and assign it
TASK=$(git-kb ready --json | jq -r '.[0].slug')
git-kb assign "$TASK" "$AGENT_ID"
# ... implement ...
git-kb unassign "$TASK"
```

## Context: bootstrap bundle

`git-kb context`  produces a focused context bundle for the current session — context documents, active tasks, and optionally code references:

```
# Basic context (context docs + active tasks)
git-kb context

# Focused on a specific task
git-kb context --task tasks/harmony-250

# Include code references resolved to symbol metadata
git-kb context --code-refs

# Cap token output for tight budgets
git-kb context --compact --token-budget 4000
```

Use this at the start of every session to orient the agent without reading every document manually.

## Multi-agent coordination

When multiple agents work concurrently, use ` assign` /` unassign`  to prevent duplicate work:

```
# Atomically claim a task (CAS — fails if someone else already has it)
git-kb assign tasks/my-task "$AGENT_ID"

# Work on the task...

# Release when done
git-kb unassign tasks/my-task
```

Combined with ` git-kb ready` , this creates a safe dispatch loop:

```
while true; do
  TASK=$(git-kb ready --json | jq -r '.[0].slug // empty')
  [ -z "$TASK" ] && break
  git-kb assign "$TASK" "$AGENT_ID" || continue  # retry if another agent grabbed it
  do_work "$TASK"
  git-kb unassign "$TASK"
done
```

## Events: real-time coordination

`git-kb events`  streams KB changes as NDJSON — useful for watchers, dashboards, and multi-agent signals:

```
# Watch for task changes
git-kb events --filter "document:*" --path "tasks/"

# Exit after 60 seconds idle
git-kb events --idle-timeout 60

# Exit after 10 events
git-kb events --count 10
```

Use events in CI to trigger downstream steps when a document status changes (e.g. when an agent marks a task completed).

## Next steps

- Team Collaboration  — Multi-agent coordination patterns

- Agent Harnesses &  Skills  — Supported harnesses and skill inventory

- Documents  — Document types and structure
