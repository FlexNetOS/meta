<!-- Source: https://gitkb.com/docs/core-concepts/documents/ -->
<!-- Snapshot: 2026-07-02 -->

# Documents

Everything in GitKB is a document  — a Markdown file with structured YAML frontmatter.

## Document types

Type | Purpose | Example
`task` | Trackable work items | Feature implementations, bug fixes
`spec` | Design documents | Architecture decisions, API designs
`incident` | Issue tracking | Bug reports, outage reports
`note` | Freeform knowledge | Meeting notes, research findings
`context` | Project state | Active context, progress tracking
`view` | Saved query | Persistent board or list query

## Frontmatter

Every document starts with YAML frontmatter:

```
---
slug: tasks/my-task
title: "Implement auth flow"
type: task
status: active
priority: high
tags: [feature, auth, api]
parent: tasks/parent-epic
---
```

### Required fields

- slug  — Unique identifier and path (e.g., ` tasks/my-task` )

- title  — Human-readable title

- type  — Document type (see table above)

### Optional fields

- status  — Lifecycle state (` draft` , ` backlog` , ` active` , ` blocked` , ` completed` , ` resolved` )

- priority  — Importance level (` critical` , ` high` , ` medium` , ` low` )

- tags  — Categorization labels

- parent  — Slug of parent document (creates hierarchy)

## Lifecycle

Documents progress through statuses:

```
draft → backlog → active → blocked → completed
```

Use ` git-kb set < slug >  --status < status >`  to update, or edit the frontmatter directly.

## Querying documents

List documents with filters to find what you need:

```
❯ git-kb list --type task --tags performance
ID        SLUG                  TYPE  STATUS     TITLE
--------  --------------------  ----  ---------  ------------------------------------------------
01kje107  tasks/acme-14         task  draft      Migrate user store to Postgres
01kj98za  tasks/acme-12         task  active     Token refresh middleware
01kj98za  tasks/acme-11         task  blocked    Deploy to production cluster
01kj9e93  tasks/acme-7          task  completed  API rate limiting middleware
01kh7z48  tasks/acme-5          task  completed  Webhook delivery system
```

Filter by ` --type` , ` --status` , ` --tags` , ` --path` , or combine them. Assignment-aware filters:

Flag | Description
`--assigned-to < id >` | Show only documents assigned to this agent
`--unassigned` | Show only unassigned documents
`--unblocked` | Show only unblocked documents

Add ` --json`  for structured output that agents can parse programmatically.

Full-text search works across all document types — titles, frontmatter, and body content:

```
❯ git-kb search authentication
SLUG                                TYPE      TITLE
----------------------------------  --------  -----------------------------------------------
context/immutable/architecture      context   Architecture
specs/auth-architecture             spec      OAuth 2.0 with PKCE Flow
specs/session-management            spec      Session Management Architecture
specs/api-gateway-design            spec      API Gateway Design
tasks/auth-epic                     epic      Auth System: OAuth 2.0 with PKCE Flow
tasks/auth-1                        task      Implement PKCE challenge generation
tasks/auth-2                        task      Add token refresh middleware
incidents/inc-007-token-expiry      incident  Token Expiry During Long Sessions

8 result(s) for 'authentication'
```

Search returns results ranked by relevance. It matches across the full document — if “authentication” appears in the body of a context doc or deep in a spec, it still surfaces.

### Semantic search (experimental)

GitKB also supports semantic search  — find documents and code by meaning, not just keywords. This uses a local embedding model to rank results by conceptual similarity:

```
❯ git-kb ai semantic "token lifecycle"
Semantic search: "token lifecycle" (model: BAAI/bge-small-en-v1.5, 10 results)

  1. [72%] doc  specs/session-management  Session Management Architecture
  2. [68%] doc  specs/auth-architecture  OAuth 2.0 with PKCE Flow
  3. [64%] doc  incidents/inc-007-token-expiry  Token Expiry During Long Sessions
  4. [61%] doc  tasks/auth-2  Add token refresh middleware
  5. [58%] code src/auth/middleware.rs::fn  validate_token
  6. [57%] doc  specs/api-gateway-design  API Gateway Design
  7. [56%] code src/auth/session.rs::struct  SessionStore
  8. [55%] doc  tasks/auth-3  Session storage with encrypted cookies
  9. [54%] code src/auth/pkce.rs::fn  generate_challenge
  10. [52%] doc  context/immutable/architecture  Architecture

10 results
Use --expand to show matching code.
```

Semantic search finds conceptually related results even when they don’t contain the exact query terms. Notice it surfaces both documents and code symbols, ranked by similarity score. Use ` --expand`  to inline the matching code snippets.

>

Note:  Semantic search is experimental and requires the embedding system to be enabled in ` .kb/config.toml` . The daemon downloads and runs the embedding model locally — no data leaves your machine.

## Assignment

Documents can be assigned  to a specific agent using compare-and-swap semantics. This prevents two agents from picking up the same task simultaneously:

```
# Assign a task (fails if already assigned to someone else)
git-kb assign tasks/my-task agent-1

# Clear the assignment when done
git-kb unassign tasks/my-task
```

The ` assigned_to`  field in frontmatter tracks the current owner. Use ` --force`  to override an existing assignment.

## Views

A view  document (` type: view` ) stores a persistent query — a board layout, filter set, and sort order:

```
```gitkb-view
filter:
  type: [task]
  status: active
layout: board
group_by: priority
columns: [critical, high, medium, low]
sort_by: modified_at
sort_direction: desc
```
```

Create a view by saving a board query:

```
git-kb board --group-by priority --type task --save views/active-tasks
```

Execute it later:

```
git-kb view views/active-tasks
```

Views re-run their query live — they always reflect the current KB state.

## Relationships

Documents link to each other through:

- Wikilinks  — ` [[slug]]`  in Markdown body creates a ` references`  edge

- Parent field  — ` parent: slug`  in frontmatter creates a ` parent_of`  edge

- Code references  — ` [[code:path::Symbol]]`  links documents to code symbols

## Next steps

- Knowledge Graph  — How documents form a queryable graph

- Code Intelligence  — Linking code to knowledge
