<!-- Source: https://gitkb.com/docs/core-concepts/knowledge-graph/ -->
<!-- Snapshot: 2026-07-02 -->

# Knowledge Graph

GitKB documents don’t exist in isolation — they form a knowledge graph  of relationships you can traverse and query.

## Edge types

Edge | Created by | Example
`references` | ` [[wikilink]]`  in body | Task references a spec
`parent_of` | ` parent:`  in frontmatter | Epic contains child tasks
`implements` | ` implements:`  in frontmatter | Task implements a spec
`blocks` | ` blocks:`  in frontmatter | Task blocks another task
`depends_on` | ` depends_on:`  in frontmatter | Task depends on another
`resolves` | ` resolves:`  in frontmatter | Task resolves an incident
`references_code` | ` [[code:...]]`  in body | Document references a code symbol
`references_commit` | ` [[commit:...]]`  in body | Document references a git commit

## Querying the graph

```
# Show all relationships for a document
git-kb graph tasks/my-task

# Show inbound edges only (who references this?)
git-kb graph tasks/my-task --direction in

# Show outbound edges only (what does this reference?)
git-kb graph tasks/my-task --direction out
```

Live verification in this repository, 2026-07-02:

```
git-kb graph tasks/meta-plugin-gitkb-harness-generation --json
git-kb graph tasks/meta-plugin-gitkb-harness-generation --direction in --json
git-kb graph tasks/meta-plugin-gitkb-harness-generation --direction out --json
git-kb graph --scope active --json
```

The current CLI accepts `--direction out`, `--direction in`, and `--direction both`. The older `inbound` and `outbound` values fail validation. The local harness task graph returned 4 nodes and 4 edges, inbound returned 3 nodes and 3 edges, outbound returned 2 nodes and 1 edge, and the active task graph returned 9 nodes and 11 edges. JSON edge records expose the relationship name as `rel_type`.

Additional graph formats are available:

```
git-kb graph tasks/meta-plugin-gitkb-harness-generation --format dot
git-kb graph tasks/meta-plugin-gitkb-harness-generation --format plan
```

The DOT output includes labeled relationship edges. The plan output summarized the local task tree as 4 total tasks: 3 completed and 1 active.

For an epic with child tasks, specs, and code references, the graph reveals the full web of relationships:

```
❯ git-kb graph tasks/auth-epic
tasks/auth-epic (Auth System: OAuth 2.0 with PKCE Flow)
├── parent_of
│   ├── tasks/auth-1 (Implement PKCE challenge generation)
│   ├── tasks/auth-2 (Add token refresh middleware)
│   ├── tasks/auth-3 (Session storage with encrypted cookies)
│   └── tasks/auth-4 (Rate limiting on auth endpoints)
├── references
│   ├── specs/auth-architecture (OAuth 2.0 with PKCE Flow)
│   ├── specs/session-management (Session Management Architecture)
│   ├── incidents/inc-007-token-expiry (Token Expiry During Long Sessions)
│   └── tasks/api-gateway (API Gateway Implementation)
├── referenced_by
│   ├── tasks/auth-1 (Implement PKCE challenge generation)
│   ├── tasks/auth-2 (Add token refresh middleware)
│   ├── tasks/auth-3 (Session storage with encrypted cookies)
│   └── specs/session-management (Session Management Architecture)
└── references_code
    ├── code:src/auth/pkce.rs::generate_challenge (code)
    ├── code:src/auth/middleware.rs::validate_token (code)
    ├── code:src/auth/session.rs::SessionStore (code)
    └── code:src/auth/rate_limit.rs::RateLimiter (code)
```

Every ` [[wikilink]]`  in a document body, every ` parent:`  field in frontmatter, and every ` [[code:...]]`  reference creates a traversable edge. Agents use this to understand what a task depends on, what it affects, and which code implements it.

## Wikilinks

Create relationships by writing ` [[slug]]`  anywhere in your document body:

```
This task implements the design described in [[specs/auth-design]].
It resolves the timeout issue reported in [[incidents/inc-005]].
```

GitKB’s extractor pipeline parses these at commit time and creates graph edges automatically.

## Graph-aware status

`git-kb status`  doesn’t just show which documents have changed — it previews how the graph itself  will change when you commit. If you add wikilinks, change a parent, or remove a reference, you see the edge diff before it lands:

```
❯ git-kb status
On commit a1b2c3d

Changes to be committed:
  (use "git-kb reset" to unstage)

        modified:  specs/auth-architecture

Graph changes (on commit):
        + references: specs/auth-architecture -> specs/session-management
        + references: specs/auth-architecture -> specs/api-gateway-design
        + references: specs/auth-architecture -> incidents/inc-007-token-expiry
        - references: specs/auth-architecture -> specs/legacy-auth-flow
```

The ` +`  and ` -`  prefixes show edges that will be created or removed. This makes it easy to verify that your wikilinks resolved correctly and that you haven’t accidentally broken a relationship before committing.

Use ` git-kb diff`  to see the content changes that produced those graph changes:

```
diff --kb a/specs/auth-architecture b/specs/auth-architecture
--- a/specs/auth-architecture
+++ b/specs/auth-architecture
@@ -12,8 +12,9 @@ ## Design
 The auth system uses OAuth 2.0 with PKCE for all public clients.
-See [[specs/legacy-auth-flow]] for the previous implementation.
+See [[specs/session-management]] for session handling details
+and [[specs/api-gateway-design]] for the gateway integration.

 ## Token Lifecycle

-Tokens are validated at the edge.
+Tokens are validated at the edge. The timeout issue tracked in
+[[incidents/inc-007-token-expiry]] informed the refresh strategy.
```

Together, ` status`  and ` diff`  give you a full picture: what edges will change, and exactly which content edits caused them.

Live verification in this repository: adding a temporary `[[views/active-tasks]]` wikilink to `tasks/meta-gitkb-assignment-field-mismatch` made `git-kb status` preview a new `references` edge to `views/active-tasks`, and `git-kb diff` showed the content line that created it. The temporary line was removed before committing this documentation update.

## Next steps

- Code Intelligence  — Code-level relationship tracking

- Agent Workflows  — How agents navigate the graph
