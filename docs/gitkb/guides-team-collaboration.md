<!-- Source: https://gitkb.com/docs/guides/team-collaboration/ -->
<!-- Snapshot: 2026-07-02 -->

# Team Collaboration

## Why GitKB syncs differently than git

Organizations run on distributed software systems spanning many repositories. The artifacts representing persisted learning and operational decisions — specs, architecture records, task histories, incident reports, context documents — are far more vast than any single codebase. The idea that an engineer or agent working on a single task must clone all knowledge ever persisted by an organization in order to execute on one novel task breaks down almost immediately.

Actors within organizations have focus and intent for any particular action. GitKB is designed around this reality: deliver the most precise context for the actor’s intent, and motivate behaviors — in both humans and agents — that compound over time to produce more signal and less noise.

This is why GitKB uses sparse sync  — you pull only the documents you need, and each document tracks its own version history independently.

### Per-document commit chains

In git, commits form a single global DAG for the entire repository. Every commit references a tree snapshot of all files. This makes it impossible for two clients to push concurrently without one rebasing on top of the other.

GitKB takes a different approach. Each document has its own linear version chain  — a monotonically increasing version number and a BLAKE3 hash chain linking consecutive versions:

```
tasks/auth:
  v1  hash: aaa...  previous: null     (created)
  v2  hash: bbb...  previous: aaa...   (modified)
  v3  hash: ccc...  previous: bbb...   (modified)

specs/api:
  v1  hash: ddd...  previous: null     (created)
  v2  hash: eee...  previous: ddd...   (modified)
```

Two developers can modify different documents concurrently and push without conflicting — because version checks happen per-document, not globally. Conflicts only occur when two people modify the same  document.

### Sparse pull

When you run ` git-kb pull` , you don’t download the entire KB. You request specific documents, and the server sends only those:

```
Client                                 Server
  │                                      │
  │  "Give me tasks/auth since S5        │
  │   and anything matching type=task,   │
  │   status=active"                     │
  ├─────────────────────────────────────►│
  │                                      │
  │  ◄── Commits touching those docs     │
  │  ◄── Document content for matches    │
```

Pull supports multiple modes:

| Mode | Example | Use case |
| --- | --- | --- |
| By slug | `tasks/auth`, `specs/api` | Pull specific documents |
| By pathspec | `tasks/*`, `context/*` | Pull a category |
| By filter | `type=task`, `status=active` | Pull by metadata |
| By traversal | Root doc + graph neighbors | Pull a doc and its relationships |

Each document tracks its own sync marker  per remote — a cursor into the server’s commit stream. Different documents on the same client can be at different sync points. This is the expected state under sparse sync.

Live verification in this repository, 2026-07-02: `git-kb pull --help` accepts a required `<REMOTE>`, optional pathspecs, `--type`, `--status`, `--include-embeddings`, and `--wire-json`. The installed `git-kb 0.2.12` binary does not expose `git-kb pull --all`; running that command fails before sync with `unexpected argument '--all'`.

## Setting up remotes

Add a remote to enable push/pull:

```
git-kb remote add origin https://gitkb.com/org/my-kb
```

This stores the remote URL in ` .kb/config.toml` :

```
[sync.remotes.origin]
url = "https://gitkb.com/org/my-kb"
```

You can have multiple remotes — for example, one for production and one for staging:

```
git-kb remote add staging https://gitkb.com/org/my-kb-staging
```

List and remove remotes:

```
git-kb remote list
git-kb remote remove staging
```

Authenticate with a remote:

```
git-kb login origin
```

>

Pricing:  Local KB is free. Cloud sync (` git-kb push` /` git-kb pull`  to a hosted remote) is a paid feature. See gitkb.com/pricing  for plans.

Live verification in this repository:

- `git-kb remote list` reported no configured remotes.
- `git-kb remote add docs-temp https://gitkb.com/org/my-kb-staging` added a local config entry under `[sync.remotes.docs-temp]`.
- `git-kb remote remove docs-temp` removed that entry.
- The add/remove round trip rewrote the ordering of `.kb/config.toml`; the proof run restored the original order so no config churn remained.

## Push/pull workflow

### Pushing changes

After committing locally, push to share with the team:

```
git-kb commit -m "Add auth refactor task"
git-kb push origin
```

Push sends all locally-changed documents since the last push, grouped into their commits. The server validates each document’s version — if your base version doesn’t match the server’s current version, the push is rejected and you need to pull first.

Push is atomic per commit — if any document in a commit conflicts, the entire commit is rejected.

Sparse push  — push only specific documents:

```
git-kb push origin 'tasks/*' 'specs/api'
```

### Pulling changes

Bare pull  (default — no pathspec or ` --all` ): updates only documents already in your local KB. Safe for sparse workflows — won’t download documents you haven’t pulled before:

```
# Refresh locally-held documents from the remote
git-kb pull origin
```

Full pull: the upstream docs describe `git-kb pull origin --all` for fetching everything the remote has, but that flag is not available in the installed `git-kb 0.2.12` binary used by this repository. Use explicit pathspecs or metadata filters instead:

```
git-kb pull origin 'tasks/*'
```

Sparse pull  with pathspecs: fetch matching documents and their commits — even ones you don’t have yet. This is how you build up your local KB:

```
# Pull a specific document (and its full commit history)
git-kb pull origin tasks/auth-refactor

# Pull all tasks
git-kb pull origin 'tasks/*'

# Pull all context documents
git-kb pull origin 'context/*'

# Pull by filter
git-kb pull origin --type task --status active
```

Start with the context documents you need, add tasks as you pick up work, and pull specs when you need to reference a design. Your local KB grows incrementally based on what you’re actually working on.

Local sync proof, 2026-07-02: because this repository has no configured `origin`, `git-kb pull origin`, `git-kb pull origin 'tasks/*'`, `git-kb pull origin --type task --status active`, and `git-kb push origin --dry-run --json` all stopped with `Remote 'origin' not found`. That proves the command parser and local remote resolution path, but it does not prove hosted GitKB Cloud transfer or authentication.

### The two-layer model: pull vs checkout

GitKB has two layers of sparseness:

1. Pull  — which documents exist in your local store (synced from the remote)

2. Checkout  — which documents are materialized in ` .kb/workspaces/main/`  for editing

```
# Pull specific documents into your local store
git-kb pull origin 'context/*'
git-kb pull origin tasks/auth-refactor

# Check out for editing
git-kb checkout tasks/auth-refactor
# Edit .kb/workspaces/main/tasks/auth-refactor.md
git-kb commit -m "Update task"
git-kb push origin
```

You can query, search, and view any document in your local DB. Checkout materializes a document to the filesystem so you can edit it in your editor and commit changes back.

## Multi-agent coordination

When multiple AI agents (or developers) work on the same KB, use atomic assignment and the board to coordinate.

### Claiming tasks with assign/unassign

Use ` git-kb assign`  to atomically claim a task — it fails if another agent already holds the task:

```
# Atomically claim a task (fails if already assigned)
git-kb assign tasks/auth-refactor "$AGENT_ID"
git-kb push origin

# Work on the task...

# Release when done
git-kb unassign tasks/auth-refactor
git-kb push origin
```

You can also use status for softer coordination:

```
git-kb set tasks/auth-refactor status=active
git-kb commit -m "Claim auth refactor task"
git-kb push origin
```

`git-kb set` uses `FIELD=VALUE` arguments. `git-kb set <slug> --status active` is not valid in `git-kb 0.2.12`; use `git-kb set <slug> status=active`. The local dry-run `git-kb set tasks/meta-plugin-gitkb-harness-generation status=active --dry-run` succeeded with `No changes to apply` because the task was already active.

Other agents see assignment and status on the board:

```
git-kb board --unassigned   # Show only unassigned tasks
git-kb board --assigned-to "$AGENT_ID"  # Show your tasks
```

Local caveat, 2026-07-02: assignment is not yet a reliable round trip in this repository. `git-kb assign tasks/meta-gitkb-assignment-field-mismatch agent-workflow-repeat --json` wrote `assignee: agent-workflow-repeat`, but `git-kb unassign tasks/meta-gitkb-assignment-field-mismatch --json` returned `changed:false` and left the workspace dirty. The tracked fix task is `tasks/meta-gitkb-assignment-field-mismatch`.

### Task board for coordination

The board gives a view of who’s working on what:

```
# Default: group by status
git-kb board

# Group by priority to focus on what matters
git-kb board --group-by priority

# Sort by most recently updated
git-kb board --group-by status --sort-by updated --sort-direction desc
```

Live verification: `git-kb board --unassigned --summary` returned `16 draft · 4 active · 60 completed`; `git-kb board --assigned-to agent-workflow-repeat --json` returned empty columns; `git-kb board --group-by priority --summary` returned `59 high · 20 medium · 1 (unset)`. Grouping by status with `--sort-by updated` returned an additional `(unset)` column for a non-task/view document, so agents should prefer `--json` when dispatching work.

### Commit-and-push cadence

Push frequently when collaborating so others see your progress:

```
git-kb commit -m "Complete auth token validation"
git-kb push origin
```

Frequent pushes reduce the chance of conflicts — and since conflicts are per-document, they’re rare when team members work on different documents.

## Conflict resolution

Conflicts happen when two people modify the same document and both push. The second push is rejected because the document’s version on the server has moved forward.

GitKB uses a rebase workflow  — consistent with the git-like protocol:

```
# 1. Push is rejected — pull first to trigger rebase
git-kb pull origin

# 2. Inspect conflicting documents
git-kb conflict show tasks/auth-refactor

# 3. Edit the workspace file to resolve the conflict, then accept
git-kb conflict accept tasks/auth-refactor

# 4. Continue the rebase after resolving all conflicts
git-kb rebase origin --continue

# Or abandon and restore pre-rebase state
git-kb rebase origin --abort
```

Live verification: `git-kb conflict show --json` returned `{"conflicts":[],"count":0}` in the clean local KB. `git-kb rebase origin --continue` and `git-kb rebase origin --abort` are valid commands, but without an active rebase state both return `No rebase in progress. Nothing to continue or abort.`

GitKB uses three-way merge when possible: frontmatter fields merge independently (one person changes ` status` , another changes ` priority`  — no conflict), and body text uses line-level merge with conflict markers when needed.

Reducing conflicts:

- Work on different documents — per-document versioning means unrelated work never conflicts

- Push frequently to minimize divergence

- Use ` git-kb assign`  to claim tasks before starting work

## Shared .kb/AGENTS.md

Commit a ` .kb/AGENTS.md`  file to ensure all AI agents on the team behave consistently:

- Same document creation workflow

- Same commit message conventions

- Same context loading process

- Same task management patterns

When one team member improves the agent instructions, everyone benefits after the next pull.

## Next steps

- Configuration  — Configure remotes and sync settings

- Agent Workflows  — Single-agent workflow patterns

- Migration &  Adoption  — Rolling out GitKB to your team
