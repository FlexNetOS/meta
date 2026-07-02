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

Live verification in this repository, 2026-07-02:

```
git-kb board --titles --width 28
git-kb board --json
git-kb board --summary
```

The local board returned `16 draft`, `4 active`, `0 blocked`, and `60 completed` documents. The active tasks were `tasks/meta-plugin-gitkb-harness-generation`, `tasks/meta-plugin-kb-hooks-config-policy`, `tasks/meta-plugin-mcp-single-owner-policy`, and `tasks/meta-retire-stale-claude-kb-commands`.

## AGENTS.md

GitKB projects include an `AGENTS.md` file in `.kb/` that instructs agents how to interact with the knowledge base. The local `.kb/AGENTS.md` declares `context_source: gitkb`, primary MCP access, fallback CLI access, and seven required context documents.

Local caveat, 2026-07-02: this repository's `.kb/AGENTS.md` still contains legacy `git kb` examples and the old `.kb/workspace/` wording. The verified command surface is `git-kb ...`, and checked-out documents currently live under `.kb/workspaces/main/`.

Key behaviors it establishes:

- Context validation  — Agents must load context before touching code

- Document-first workflow  — Create the task document before implementing

- Traceability  — Link commits to tasks with ` [[wikilinks]]`

## Skills and harnesses

GitKB skills are reusable workflow documents. The canonical skill source is `.kb/skills/`; Claude Code, Codex, Cursor, and Windsurf load assistant-specific forwarders or adapters from their own directories, while generic MCP clients use the same MCP tools with workflow instructions supplied by the project. This keeps the workflow consistent across agents.

Common skills used during real work:

| Phase | Skills |
| --- | --- |
| Orient | `gitkb`, `kb-context`, `kb-board`, `kb-tasks` |
| Start work | `kb-start`, `kb-create`, `kb-search` |
| Understand code | `code-intelligence`, `explore`, `understand`, `refactor-safety` |
| Track progress | `kb-status`, `kb-progress`, `kb-review` |
| Finish | `kb-close`, `kb-commit`, `kb-handoff` |

Live verification in this repository found 17 canonical skills under `.kb/skills/`: `code-intelligence`, `explore`, `gitkb`, `kb-board`, `kb-close`, `kb-commit`, `kb-context`, `kb-create`, `kb-handoff`, `kb-progress`, `kb-review`, `kb-search`, `kb-start`, `kb-status`, `kb-tasks`, `refactor-safety`, and `understand`.

## Context documents

Context documents in `context/` provide project understanding at three stability levels:

| Level | Path | Changes | Examples |
| --- | --- | --- | --- |
| Immutable | `context/immutable/` | Rarely | Project brief, architecture, patterns |
| Extensible | `context/extensible/` | Sometimes | Product context, tech stack |
| Overridable | `context/overridable/` | Often | Active work, progress tracking |

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

The scoring algorithm considers priority, status, blocking relationships, and assignment. `--json` exposes the score breakdown for CI/orchestration.

Live verification in this repository, 2026-07-02:

- `git-kb ready` selected `tasks/meta-agent-architecture-codex-integration` with score `75.0`.
- `git-kb ready --limit 3 --json` returned `tasks/meta-agent-architecture-codex-integration`, `tasks/meta-resolve-peer-dirty-trees`, and `tasks/meta-design-codex-hook-parity`, all with score `75.0` and `priority_weight: 75.0`.
- `git-kb ready --context` returned the selected task body and an empty graph with token usage `132` of budget `8000`.
- `git-kb ready --context --smart-code --budget 12000` returned the same task; `smart_code` was empty because that task has no code references.

```
# CI dispatch: pick next task and assign it
TASK=$(git-kb ready --json | jq -r '.[0].slug')
git-kb assign "$TASK" "$AGENT_ID"
# ... implement ...
git-kb unassign "$TASK"
```

## Context: bootstrap bundle

`git-kb context` produces a focused context bundle for the current session — context documents, active tasks, and optionally code references:

```
# Basic context (context docs + active tasks)
git-kb context

# Focused on a specific task
git-kb context --task tasks/meta-plugin-gitkb-harness-generation

# Include code references resolved to symbol metadata
git-kb context --code-refs

# Cap token output for tight budgets
git-kb context --compact --token-budget 4000
```

Use this at the start of every session to orient the agent without reading every document manually.

Live verification in this repository:

- `git-kb context --compact --token-budget 4000` returned a compact JSON board bundle with context documents and active tasks.
- `git-kb context --task tasks/meta-plugin-gitkb-harness-generation --code-refs --compact --token-budget 4000` returned the task body plus the directly linked task `tasks/meta-gitkb-skill-inventory-adapter-parity`; metadata reported `documents_included: 1`, `code_symbols_included: 0`, and `total_tokens: 724`.
- `git-kb context --task tasks/harmony-250 --compact --token-budget 4000` failed locally with `Document 'unknown' not found`, so examples must use a real slug from the current KB.

## Multi-agent coordination

When multiple agents work concurrently, use `assign`/`unassign` to prevent duplicate work:

```
# Atomically claim a task (CAS — fails if someone else already has it)
git-kb assign tasks/my-task "$AGENT_ID"

# Work on the task...

# Release when done
git-kb unassign tasks/my-task
```

Combined with `git-kb ready`, this creates a safe dispatch loop:

```
while true; do
  TASK=$(git-kb ready --json | jq -r '.[0].slug // empty')
  [ -z "$TASK" ] && break
  git-kb assign "$TASK" "$AGENT_ID" || continue  # retry if another agent grabbed it
  do_work "$TASK"
  git-kb unassign "$TASK"
done
```

Local caveat, 2026-07-02: assignment is not yet a safe round trip in this repository. `git-kb assign tasks/meta-gitkb-assignment-field-mismatch agent-workflow-repeat --json` wrote `assignee: agent-workflow-repeat`, but `git-kb unassign tasks/meta-gitkb-assignment-field-mismatch --json` returned `changed:false` and left the workspace dirty. The tracked fix task is `tasks/meta-gitkb-assignment-field-mismatch`.

## Events: real-time coordination

`git-kb events` streams KB changes as NDJSON — useful for watchers, dashboards, and multi-agent signals:

```
# Watch for task changes
git-kb events --filter "document:*" --path "tasks/"

# Exit after 60 seconds idle
git-kb events --idle-timeout 60

# Exit after 10 events
git-kb events --count 10
```

Use events in CI to trigger downstream steps when a document status changes (e.g. when an agent marks a task completed).

Live verification in this repository:

- `git-kb events --filter "document:*" --path "tasks/" --idle-timeout 1` exited cleanly after the idle timeout.
- `git-kb events --count 10 --idle-timeout 1` emitted subscription and `code:watcher_ready` NDJSON records before the idle timeout. In a quiet KB, `--count 10` by itself can wait indefinitely; automation should pair it with `--idle-timeout` unless it intentionally wants a long-running stream.

## Next steps

- Team Collaboration  — Multi-agent coordination patterns

- Agent Harnesses &  Skills  — Supported harnesses and skill inventory

- Documents  — Document types and structure
