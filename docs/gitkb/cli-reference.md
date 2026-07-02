<!-- Source: https://gitkb.com/docs/cli-reference/ -->
<!-- Snapshot: 2026-07-02 -->

# CLI Reference

All ` git-kb`  commands. Click any row to expand its full help. This page is backed by ` src/lib/docs/cli-commands.ts` , generated from ` git-kb 0.2.6` .

This CLI reference mirrors command help for the generated git-kb 0.2.6 dataset. Output may differ for other installed GitKB versions. For the installed assistant dotfile and skill symlink layouts, see Agent Harnesses &  Skills .

```
git-kb --version          # Print version
git-kb --help             # Print help
git-kb <command> --help   # Help for a specific command
```

## Start a knowledge base

  ` git-kb init`  Initialize a new knowledge base

```
Initialize a new knowledge base

Usage: git-kb init [OPTIONS] [COMMAND]

Commands:
  claude    Install Claude Code integration files (.claude/, CLAUDE.md)
  codex     Install Codex integration files (.codex/, scripts, CODEX_HOME)
  cursor    Install Cursor integration files (.cursor/skills/, .cursor/rules/)
  windsurf  Install Hermes integration files (.hermes/skills/, .hermes/rules/) Install Windsurf integration files (.windsurf/skills/, .windsurf/rules/)
  git       Install git hooks (e.g., reference-transaction for branch symbol pruning)

Options:
      --remote <REMOTE>
          Optional remote URL to configure

      --cloud-remote <CLOUD_REMOTE>
          API remote/domain to use when --remote is an org slug

      --org <ORG>
          Organization/namespace for federation

      --instance <INSTANCE>
          Instance name within organization

      --name <NAME>
          Display name for this KB

      --no-verify
          Skip connectivity check with remote

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb doctor`  Diagnose common configuration problems

```
Diagnose common configuration problems

Usage: git-kb doctor [OPTIONS]

Options:
      --check <CHECK>
          Only run specific checks (comma-separated). Available: repos, code, kb

      --fix
          Apply safe local repairs for the detected KB issues, then rerun checks

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb repair`  Repair safe local KB state from canonical store data

```
Repair safe local KB state from canonical store data

Usage: git-kb repair [OPTIONS] <COMMAND>

Commands:
  projection    Rebuild SQLite projection state from the canonical file store
  manifest      Repair recomputable local manifest metadata from the canonical file store
  lineage       Inspect per-document lineage state and detached history
  canonicalize  Offline emergency repair for local authority KB history/frontmatter drift

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb upgrade`  Upgrade local KB storage format

```
Upgrade local KB storage format

Usage: git-kb upgrade [OPTIONS]

Options:
      --check
          Exit 0 if already upgraded, exit 1 if migration is needed

      --dry-run
          Print what would change without touching disk

      --repair
          Apply mechanically safe generic repairs during upgrade

      --adopt-current-live-state
          Explicitly adopt current live file bytes as one repair commit per affected document

      --accept-missing-body-as-delete
          Explicitly convert non-deleted document tips with missing current bodies into one deletion repair commit per document

      --drop-missing-body-commits
          Explicitly drop commits whose document history has no current body, plus affected fixture live files

      --adopt-uncommitted-docs
          Explicitly adopt live documents with no commit history by creating one v3 Created repair commit per document

      --drop-uncommitted-docs
          Explicitly drop live documents with no commit history from the upgrade work copy

      --drop-stale-duplicate-live-docs
          Explicitly drop stale duplicate live files when exactly one duplicate matches the document-tip slug

      --rollback
          Restore the latest v3 migration backup

      --cleanup
          Delete retained v3 migration backups

  -v, --verbose
          Print detailed migration summary

      --root <ROOT>
          Operate on this KB root instead of resolving from cwd/GITKB_ROOT

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb info`  Show KB statistics and storage info

```
Show KB statistics and storage info

Usage: git-kb info [OPTIONS]

Options:
      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Create and manage documents

  ` git-kb create`  Create a new document

```
Create a new document

Usage: git-kb create [OPTIONS] [TYPE]

Arguments:
  [TYPE]
          Document type (task, spec, note, decision, reference)

Options:
      --type <TYPE>
          Document type (task, spec, note, decision, reference)

      --title <TITLE>
          Document title (opens $EDITOR if not provided)

      --body <BODY>
          Document body content (only with --title)

      --status <STATUS>
          Initial status (draft/active/completed)

          [default: draft]

      --priority <PRIORITY>
          Priority (high/medium/low)

          [default: medium]

      --tags <TAGS>
          Comma-separated tags

      --assignee <ASSIGNEE>
          Assignee email

      --path <PATH>
          Path for the document (e.g., docs/api)

      --slug <SLUG>
          Explicit slug (overrides title-based generation)

      --template <TEMPLATE>
          Template to use

      --parent <PARENT>
          Parent document slug

      --component <COMPONENT>
          Component tag

      --blocks <BLOCKS>
          Link to existing document (blocks relationship)

      --blocked-by <BLOCKED_BY>
          Link to existing document (blocked-by relationship)

      --refs <REFS>
          Link to existing document (references relationship)

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version

TYPE is required and can be given positionally or with --type:
  git-kb create task --title "..."          (positional)
  git-kb create --type task --title "..."   (named flag)
```

 ` git-kb show`  Display a document

```
Display a document

Usage: git-kb show [OPTIONS] <PATHSPEC>...

Arguments:
  <PATHSPEC>...
          Pathspecs to display: document slugs/IDs, commit hashes, or slug@version

          Examples: git-kb show my-task           # Show single document git-kb show task-1 task-2     # Show multiple documents git-kb show abc123            # Show commit git-kb show my-task@3         # Show version 3 of document

Options:
      --json
          Output as JSON

      --related
          Also show summaries of related documents

      --no-body
          Show metadata only (no body)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb list`  List documents with filtering

```
List documents with filtering

Usage: git-kb list [OPTIONS] [TYPE]

Arguments:
  [TYPE]
          Filter by document type (single value; use --type for multi-value)

Options:
      --type <TYPE>
          Filter by document type (repeat or comma-separate for multiple values)

      --status <STATUS>
          Filter by status (repeat or comma-separate for multiple values)

      --priority <PRIORITY>
          Filter by priority (repeat or comma-separate for multiple values)

      --tags <TAGS>
          Filter by tags (comma-separated)

      --path <PATH>
          Filter by path prefix

  -r, --recursive
          Include nested descendants (with --path)

      --in <CONTAINER>
          List ordered children of a container

  -n, --limit <LIMIT>
          Maximum number of results (default: no limit)

      --offset <OFFSET>
          Number of results to skip (for pagination)

      --sort <SORT>
          Sort by field: created, modified, title, priority

      --asc
          Sort ascending (default depends on field: asc for title/priority, desc for dates)

      --desc
          Sort descending (default depends on field: asc for title/priority, desc for dates)

      --since <SINCE>
          Filter: modified after date (ISO 8601 date or relative: 7d, 2w, 1m)

      --until <UNTIL>
          Filter: modified before date (ISO 8601 date or relative: 7d, 2w, 1m)

      --format <FORMAT>
          Output format (table, json, ids)

          Possible values:
          - table: Formatted table (default)
          - json:  JSON output for scripting
          - ids:   Document IDs only (one per line)

          [default: table]

      --json
          Output as JSON (shorthand for --format json)

      --unassigned
          Show only unassigned documents

      --assigned-to <ASSIGNED_TO>
          Show only documents assigned to this agent

      --unblocked
          Show only documents with no unresolved blockers

      --no-links
          Hide relationship column

      --save <SAVE>
          Save current list flags as a view document with this slug

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version

TYPE can be given positionally or with --type:
  git-kb list task            (positional)
  git-kb list --type task     (named flag)
```

 ` git-kb search`  Search documents by content

```
Search documents by content

Usage: git-kb search [OPTIONS] <QUERY>

Arguments:
  <QUERY>
          Search query (searches title, content, and tags)

Options:
      --limit <LIMIT>
          Maximum number of results

          [default: 20]

      --type <DOC_TYPE>
          Filter by document type

      --status <STATUS>
          Filter by status

      --offset <OFFSET>
          Number of results to skip

      --format <FORMAT>
          Output format (table, json, slugs)

          Possible values:
          - table: Formatted table (default)
          - json:  JSON output for scripting
          - slugs: Document slugs only (one per line)

          [default: table]

      --json
          Output as JSON (shorthand for --format json)

      --remote <REMOTE>
          Search a remote KB instead of the local one.

          Accepts a remote name (e.g., "origin") or a gitkb:// URL. Calls the cloud FTS endpoint through the gateway.

      --hybrid
          Use hybrid search (combines keyword + vector similarity).

          Hybrid search runs both full-text and semantic search, then combines results using weighted scoring. Falls back to keyword-only search if embeddings are unavailable.

      --vector-weight <VECTOR_WEIGHT>
          Weight for vector/semantic results (0.0 to 1.0, default 0.7). Only used with --hybrid when embeddings are available

          [default: 0.7]

      --keyword-weight <KEYWORD_WEIGHT>
          Weight for keyword results (0.0 to 1.0, default 0.3). Only used with --hybrid when embeddings are available

          [default: 0.3]

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb rm`  Delete documents

```
Delete documents

Usage: git-kb rm [OPTIONS] <PATHSPEC>...

Arguments:
  <PATHSPEC>...
          Document IDs, slugs, or glob patterns to delete

Options:
  -f, --force
          Force delete - skip documents that are not found

      --hard
          Hard delete - destructively purge matching documents and document-only commits

      --commit
          Unsupported with v3 hard-delete. Use normal rm + commit for audit-preserving deletion

  -m, --message <MESSAGE>
          Commit message (only with --hard --commit)

      --dry-run
          Dry run - resolve pathspecs and show what would be deleted without modifying the DB (only with --hard)

  -q, --quiet
          Quiet mode (suppress output)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb set`  Quick metadata update (workspace-first, commit separately)

```
Quick metadata update (workspace-first, commit separately)

Usage: git-kb set [OPTIONS] <PATHSPEC> <FIELD=VALUE>...

Arguments:
  <PATHSPEC>
          Document pathspec (ID, slug, or glob pattern)

  <FIELD=VALUE>...
          Field=value pairs to set (use +field:value to add, -field:value to remove from arrays)

Options:
  -n, --dry-run
          Preview changes without applying (dry-run)

  -q, --quiet
          Quiet mode (suppress output)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb assign`  Atomically assign a document to an agent (CAS)

```
Atomically assign a document to an agent (CAS)

Usage: git-kb assign [OPTIONS] <SLUG> <AGENT_ID>

Arguments:
  <SLUG>
          Document slug to assign

  <AGENT_ID>
          Agent or person ID to assign to

Options:
      --force
          Force assignment even if already assigned to someone else

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb unassign`  Clear the assignment on a document

```
Clear the assignment on a document

Usage: git-kb unassign [OPTIONS] <SLUG>

Arguments:
  <SLUG>
          Document slug to unassign

Options:
      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb mv`  Move or rename documents

```
Move or rename documents

Usage: git-kb mv [OPTIONS] <SOURCE> <DEST>

Arguments:
  <SOURCE>
          Source document ID, slug, or path

  <DEST>
          Destination slug or path

Options:
  -f, --force
          Force overwrite if destination exists

  -m, --message <MESSAGE>
          Custom commit message

  -q, --quiet
          Quiet mode (suppress output)

      --commit
          Immediately commit to database (default: workspace only)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb templates`  Manage document templates

```
Manage document templates

Usage: git-kb templates [OPTIONS] [COMMAND]

Commands:
  list    List available templates
  show    Show a template
  create  Create a new template
  edit    Edit an existing template
  delete  Delete a custom template

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Organize with relationships and views

  ` git-kb link`  Add a document to a container with ordering

```
Add a document to a container with ordering

Usage: git-kb link [OPTIONS] <CHILD>

Arguments:
  <CHILD>
          Document to link (ID or slug)

Options:
      --to <CONTAINER>
          Container to link to

      --position <POSITION>
          Position: first, last (default), after:<slug>, before:<slug>

          [default: last]

      --code <CODE>
          Code symbol to link (e.g., src/auth.rs::login)

      --repo <REPO>
          Repository name for commit linking (must match [repos] in config.toml)

      --commit <COMMIT>
          Commit SHA for commit linking (requires --repo)

  -q, --quiet
          Quiet mode (suppress output)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb unlink`  Remove a document from a container

```
Remove a document from a container

Usage: git-kb unlink [OPTIONS] --from <CONTAINER> <CHILD>

Arguments:
  <CHILD>
          Document to unlink (ID or slug)

Options:
      --from <CONTAINER>
          Container to unlink from

  -q, --quiet
          Quiet mode (suppress output)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb reorder`  Reorder a document within a container

```
Reorder a document within a container

Usage: git-kb reorder [OPTIONS] --position <POSITION> <CONTAINER> <CHILD>

Arguments:
  <CONTAINER>
          Container document (ID or slug)

  <CHILD>
          Child document to reorder (ID or slug)

Options:
      --position <POSITION>
          New position: first, last, after:<slug>, before:<slug>

  -q, --quiet
          Quiet mode (suppress output)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb graph`  Visualize document relationships

```
Visualize document relationships

Usage: git-kb graph [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document pathspec(s) (ID, slug, or glob pattern). Multiple pathspecs produce a merged graph

Options:
  -d, --depth <DEPTH>
          How many levels of relationships to traverse

          [default: 1]

  -D, --direction <DIRECTION>
          Which direction to traverse relationships

          Possible values:
          - out:  Follow outgoing relationships only (this doc -> others)
          - in:   Follow incoming relationships only (others -> this doc)
          - both: Follow both directions

          [default: both]

  -t, --rel-type <REL_TYPE>
          Filter by relationship type (can specify multiple)

  -f, --format <FORMAT>
          Output format

          Possible values:
          - tree:          Tree-style ASCII output
          - json:          JSON output for tooling
          - dot:           DOT format for Graphviz
          - mermaid-gantt: Mermaid gantt chart syntax
          - plan:          Dependency-ordered execution plan (JSON)

          [default: tree]

      --json
          Output as JSON (shorthand for --format json)

      --critical-path
          Compute and highlight the longest dependency chain (critical path)

      --scope <SCOPE>
          Graph all tasks with this status (e.g., --scope active)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb board`  Display ASCII kanban board

```
Display ASCII kanban board

Usage: git-kb board [OPTIONS]

Options:
      --type <DOC_TYPE>
          Filter to specific document type

          By default, board shows only task and incident types. Use this to filter to a specific type, or use --all to show all types.

      --tags <TAGS>
          Filter by tags

      --priority <PRIORITY>
          Filter by priority

      --all
          Show all items and types (don't truncate, include all document types)

      --group-by <GROUP_BY>
          Group by a frontmatter property instead of status

          Groups documents into columns by the specified property value. For example, --group-by priority creates columns for each priority level. Array properties like tags place documents in multiple columns.

      --columns <COLUMNS>
          Explicit column order (comma-separated, requires --group-by)

          Controls which columns appear and in what order. Values not in this list appear as additional columns at the end.

      --sort-by <SORT_BY>
          Sort items within columns by a frontmatter property

      --sort-direction <SORT_DIRECTION>
          Sort direction: "asc" or "desc" (default: asc)

      --unassigned
          Show only unassigned documents

      --assigned-to <ASSIGNED_TO>
          Show only documents assigned to this agent

      --unblocked
          Show only documents with no unresolved blockers

      --json
          Output as JSON (for tooling)

      --titles
          Show document titles below each slug

          [aliases: --title]

      --width <WIDTH>
          Column width for board display (auto-detected from terminal if not set)

      --save <SAVE>
          Save current board flags as a view document with this slug

      --summary
          Print one compact line of non-zero status counts (e.g., "22 active · 3 blocked")

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb view`  Execute a saved view

```
Execute a saved view

Usage: git-kb view [OPTIONS] <SLUG>

Arguments:
  <SLUG>
          View document slug to execute

Options:
      --json
          Output as JSON

      --limit <LIMIT>
          Override limit for list/table/timeline layouts

      --offset <OFFSET>
          Override offset for pagination

      --no-body
          Show metadata only (no body). Only applies when falling back to show

      --related
          Also show summaries of related documents. Only applies when falling back to show

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Workspace

  ` git-kb checkout`  Materialize documents to workspace

```
Materialize documents to workspace

Usage: git-kb checkout [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document IDs, slugs, or glob patterns to checkout (e.g., 'tasks/*', 'docs/**')

Options:
      --type <DOC_TYPE>
          Checkout all documents of a type

      --status <STATUS>
          Checkout documents by status

      --flat
          All files in workspace root (no subdirs)

      --force
          Discard uncommitted changes (dangerous)

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb status`  Show KB state (uncommitted changes, etc.)

```
Show KB state (uncommitted changes, etc.)

Usage: git-kb status [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document pathspecs to check (slugs, globs, or IDs). Shows all if not specified

Options:
  -s, --short
          Show short format

  -q, --quiet
          Suppress output (exit code only)

      --json
          Output as JSON

      --no-graph
          Hide graph changes (relationship edge additions/removals)

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb diff`  Show changes between workspace and DB

```
Show changes between workspace and DB

Usage: git-kb diff [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document pathspecs to diff (slugs, globs, or IDs). Diffs all if not specified

Options:
      --commit <COMMIT>
          Commit or range to diff (e.g., abc1234, abc1234..def5678)

      --stat
          Show summary only (files changed, not content)

      --name-only
          Show only changed document names

  -q, --quiet
          Suppress output when no changes

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb commit`  Create a KB commit from workspace changes

```
Create a KB commit from workspace changes

Usage: git-kb commit [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document pathspecs to commit (slugs, globs, or IDs)

Options:
  -m, --message <MESSAGE>
          Commit message (opens $EDITOR if not provided)

  -a, --all
          Commit all changed documents (required when multiple documents are changed without pathspecs)

      --close
          Remove committed files from workspace after commit

      --amend
          Amend previous commit

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb stash`  Stash workspace changes

```
Stash workspace changes

Usage: git-kb stash [OPTIONS] [COMMAND]

Commands:
  list   Show stash stack
  pop    Apply and remove top stash
  apply  Apply but keep stash
  drop   Remove top stash without applying
  show   Show changes in stash
  clear  Remove all stashes

Options:
  -m, --message <MESSAGE>
          Custom stash message

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb reset`  Discard workspace changes

```
Discard workspace changes

Usage: git-kb reset [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document pathspecs to reset (slugs, globs, or IDs). With `--hard --to <COMMIT>`: pass a single document slug to reset that document. Resets all workspace changes if not specified (without --hard)

Options:
      --hard
          Hard reset a single document tip. Usage: git-kb reset --hard <SLUG> --to <COMMIT>

      --to <TO>
          Target commit for per-document reset. Moves the specified document's canonical tip to this commit

      --dry-run
          Dry run - show what would change without modifying the DB (only with --hard)

      --force
          Skip confirmation prompt for destructive operation

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb clear`  Remove documents from workspace

```
Remove documents from workspace

Usage: git-kb clear [OPTIONS] [PATHSPEC]...

Arguments:
  [PATHSPEC]...
          Document pathspecs to clear (slugs, globs, or IDs). Clears all if not specified

Options:
  -f, --force
          Clear even if there are uncommitted changes

      --dry-run
          Show what would be cleared without doing it

  -q, --quiet
          Suppress output

      --type <DOC_TYPE>
          Filter by document type (e.g., task, spec, incident). Repeatable for OR logic

      --status <STATUS>
          Filter by document status (e.g., done, completed, active). Repeatable for OR logic

      --priority <PRIORITY>
          Filter by priority (e.g., low, medium, high, critical). Repeatable for OR logic

      --tag <TAGS>
          Filter by tag (repeatable — all specified tags must be present)

      --path <PATH>
          Filter by path prefix (e.g., "tasks/", "specs/"). Repeatable for OR logic

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb log`  Show commit history

```
Show commit history

Usage: git-kb log [OPTIONS] [PATHSPEC]

Arguments:
  [PATHSPEC]
          Show history for specific document (ID, slug, or glob pattern)

Options:
  -n, --count <COUNT>
          Limit number of commits shown

      --offset <OFFSET>
          Skip this many commits (for pagination)

      --oneline
          Compact format (one line per commit, shorthand for --format oneline)

      --stat
          Show document change counts

  -p, --patch
          Show patch (line-level diffs) for each change

      --format <FORMAT>
          Output format (full, oneline, json)

          Possible values:
          - full:    Full commit details (default)
          - oneline: One line per commit
          - json:    JSON output for scripting

          [default: full]

      --json
          Output as JSON (shorthand for --format json)

      --since <SINCE>
          Show only commits after this date (ISO 8601 date or relative: 7d, 2w, 1m)

      --until <UNTIL>
          Show only commits before this date (ISO 8601 date or relative: 7d, 2w, 1m)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Collaborate and sync

  ` git-kb remote`  Manage sync remotes

```
Manage sync remotes

Usage: git-kb remote [OPTIONS] <COMMAND>

Commands:
  add     Add a new remote
  remove  Remove a remote
  list    List configured remotes

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb push`  Push changes to a remote

```
Push changes to a remote

Usage: git-kb push [OPTIONS] <REMOTE> [PATHSPEC]...

Arguments:
  <REMOTE>
          Remote name or URL (e.g., origin, https://sync.gitkb.io, gitkb://gitkb.com/org/kb)

  [PATHSPEC]...
          Document slugs or glob patterns to push (e.g., 'tasks/*', 'specs/api')

Options:
      --include-embeddings
          Include embeddings (L1) in sync

      --wire-json
          Use JSON wire format instead of binary (for debugging)

  -v, --verbose
          Verbose output

      --force
          Force push, overwriting remote conflicts

      --auto-rebase
          Attempt a local pull/rebase/retry when the push is stale/diverged

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb pull`  Pull changes from a remote

```
Pull changes from a remote

Usage: git-kb pull [OPTIONS] <REMOTE> [PATHSPEC]...

Arguments:
  <REMOTE>
          Remote name or URL (e.g., origin, https://sync.gitkb.io, gitkb://gitkb.com/org/kb)

  [PATHSPEC]...
          Document slugs or glob patterns to pull (e.g., 'tasks/*', 'specs/api')

Options:
      --include-embeddings
          Include embeddings (L1) in sync

      --wire-json
          Use JSON wire format instead of binary (for debugging)

  -v, --verbose
          Verbose output

      --type <DOC_TYPE>
          Pull documents of a specific type

      --status <STATUS>
          Pull documents by status

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb conflict`  Manage sync conflicts

```
Manage sync conflicts

Usage: git-kb conflict [OPTIONS] <COMMAND>

Commands:
  show    Show conflicts
  accept  Accept a resolution

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb rebase`  Manage rebase state (continue/abort)

```
Manage rebase state (continue/abort)

Usage: git-kb rebase [OPTIONS] [REMOTE]

Arguments:
  [REMOTE]
          Remote name or URL (optional; defaults to the remote stored in rebase state)

Options:
      --continue
          Continue rebase after conflict resolution

      --abort
          Abort rebase and restore pre-rebase state

      --include-embeddings
          Include embeddings (L1) in sync

      --wire-json
          Use JSON wire format instead of binary (for debugging)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb bundle`  Package or apply a `.kbbundle` (cross-KB commit replay).

```
Package or apply a `.kbbundle` (cross-KB commit replay).

`bundle create` packages a selected subset of commit history into a portable `.kbbundle` file. `bundle apply` replays the commits onto another KB. See [[tasks/harmony-557]].

Usage: git-kb bundle [OPTIONS] <COMMAND>

Commands:
  create  Package a subset of commit history into a `.kbbundle`
  apply   Apply a `.kbbundle` to this KB

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb bundle create`  Package a subset of commit history into a `.kbbundle`

```
Package a subset of commit history into a `.kbbundle`

Usage: git-kb bundle create [OPTIONS]

Options:
  -o, --output <OUTPUT>
          Output path. Use `-` to write the tar bytes to stdout

          [default: delta.kbbundle]

      --slugs <SLUG>...
          Restrict to commits touching these slugs (or glob pathspecs). Composes with `--commits`, `--since`, and `--author` via AND

      --commits <RANGE>
          Git-style range `A..B` or comma-separated commit IDs. May be passed multiple times

      --since <RFC3339>
          Include commits with `committed_at >= <RFC3339>`

      --author <EMAIL>
          Restrict by commit author email

      --json
          Emit JSON to stdout (manifest summary + base64 bytes), suitable for scripting. Suppresses the human-readable next-actions block

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb bundle apply`  Apply a `.kbbundle` to this KB

```
Apply a `.kbbundle` to this KB

Usage: git-kb bundle apply [OPTIONS] <INPUT>

Arguments:
  <INPUT>
          Path to the `.kbbundle` (or `.kbbundle.gz`). Use `-` to read from stdin

Options:
      --dry-run
          Show the per-commit plan without mutating any state

      --force
          Override the dirty-workspace guard

      --no-verify
          Skip the post-apply `verify` pass

      --json
          Emit a JSON response (status + per-commit plan + next_actions)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb login`  Shortcut for auth login

```
Shortcut for auth login

Usage: git-kb login [OPTIONS] [SERVER]

Arguments:
  [SERVER]
          Remote name, domain, or gitkb:// URL to authenticate against (default: GITKB_DOMAIN, active cloud domain, then gitkb.com)

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb logout`  Shortcut for auth logout

```
Shortcut for auth logout

Usage: git-kb logout [OPTIONS] [SERVER]

Arguments:
  [SERVER]
          Remote name, domain, or gitkb:// URL to log out from (default: GITKB_DOMAIN, active cloud domain, then gitkb.com)

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb auth`  Authentication (login, logout, token)

```
Authentication (login, logout, token)

Usage: git-kb auth [OPTIONS] <COMMAND>

Commands:
  login   Authenticate with a GitKB remote via OIDC device flow
  logout  Clear stored authentication tokens
  token   Print current access token to stdout
  status  Show active cloud domain selection
  use     Switch the active cloud domain without logging in

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb whoami`  Show current user and org memberships

```
Show current user and org memberships

Usage: git-kb whoami [OPTIONS]

Options:
      --remote <REMOTE>
          Remote name, domain, or gitkb:// URL (default: GITKB_DOMAIN, active cloud domain, then gitkb.com)

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb ping`  Check API reachability and version

```
Check API reachability and version

Usage: git-kb ping [OPTIONS]

Options:
      --remote <REMOTE>
          Remote name, domain, or gitkb:// URL (default: GITKB_DOMAIN, active cloud domain, then gitkb.com)

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb org`  Manage organizations

```
Manage organizations

Usage: git-kb org [OPTIONS] <COMMAND>

Commands:
  create  Create a new organization
  list    List your organizations
  show    Show org details and its knowledge bases
  delete  Delete an organization (owner-only)

Options:
      --remote <REMOTE>
          Remote name, domain, or gitkb:// URL (default: GITKB_DOMAIN, active cloud domain, then gitkb.com)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Export and recover

  ` git-kb export`  Export documents in various formats

```
Export documents in various formats

Usage: git-kb export [OPTIONS]

Options:
  -o, --output-dir <OUTPUT_DIR>
          Output directory for markdown files (creates one file per document)

  -f, --format <FORMAT>
          Export format (default: markdown for --output-dir, jsonl for stdout)

          Possible values:
          - markdown: Markdown with YAML frontmatter
          - json:     Single JSON array
          - jsonl:    One JSON object per line (for streaming)

  -t, --type <DOC_TYPE>
          Filter by document type

  -s, --status <STATUS>
          Filter by status

      --tag <TAG>
          Filter by tag

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb backup`  Create full KB backup (documents + commits + stashes)

```
Create full KB backup (documents + commits + stashes)

Usage: git-kb backup [OPTIONS]

Options:
  -o, --output <OUTPUT>
          Output file path (default: .kb/backups/YYYY-MM-DDTHH-mm-ss.json)

      --stdout
          Output to stdout instead of file

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb restore`  Restore KB from backup file

```
Restore KB from backup file

Usage: git-kb restore [OPTIONS] <FILE>

Arguments:
  <FILE>
          Path to backup file

Options:
      --skip-documents
          Skip restoring documents

      --skip-commits
          Skip restoring commits

      --skip-stashes
          Skip restoring stashes

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb filter`  Rewrite history to remove matching documents

```
Rewrite history to remove matching documents

Usage: git-kb filter [OPTIONS] --rm <PATHSPEC>...

Options:
      --rm <PATHSPEC>...
          Document slugs or glob patterns to destructively purge

      --force
          Skip confirmation prompt for destructive operation

  -q, --quiet
          Suppress output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb schema`  Generate JSON Schema for document types

```
Generate JSON Schema for document types

Usage: git-kb schema [OPTIONS] [NAME]

Arguments:
  [NAME]
          Schema name to generate (frontmatter, document-type, external-ref) If not specified, lists available schemas

Options:
      --format <FORMAT>
          Output format (json or yaml)

          Possible values:
          - json: JSON output (default)
          - yaml: YAML output

          [default: json]

      --json
          Output as JSON (shorthand for --format json)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb reindex`  Rebuild index from file store

```
Rebuild index from file store

Usage: git-kb reindex [OPTIONS]

Options:
  -v, --verbose
          Print progress as documents/commits are processed

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb verify`  Verify file store integrity

```
Verify file store integrity

Usage: git-kb verify [OPTIONS]

Options:
      --full
          Also verify that the index matches the file store

  -v, --verbose
          Print detailed information about each check

      --json
          Output as JSON

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb fsck`  Check local KB integrity and fail on invariant issues

```
Check local KB integrity and fail on invariant issues

Usage: git-kb fsck [OPTIONS]

Options:
      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb uncommit`  Turn a KB commit back into workspace changes

```
Turn a KB commit back into workspace changes

Usage: git-kb uncommit [OPTIONS] <COMMIT_ID>

Arguments:
  <COMMIT_ID>
          Commit ID to turn back into uncommitted workspace changes

Options:
      --json
          Emit the full operation result as JSON

  -q, --quiet
          Suppress human-readable output

  -v, --verbose
          Enable verbose output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Integrations

  ` git-kb daemon`  Manage the GitKB daemon

```
Manage the GitKB daemon

Usage: git-kb daemon [OPTIONS] <COMMAND>

Commands:
  start        Start the GitKB daemon
  stop         Stop a running daemon
  status       Check daemon status
  restart      Restart the daemon
  await-event  Wait for a daemon event (for test synchronization)

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb events`  Stream real-time events as NDJSON

```
Stream real-time events as NDJSON

Usage: git-kb events [OPTIONS]

Options:
      --filter <FILTER>
          Event pattern filter (e.g., "document:*", "commit:created", "*")

          [default: *]

      --path <PATH>
          Filter document events by slug prefix (e.g., "tasks/")

          Applied client-side since the daemon's EventFilter only matches event types. Non-document events (commit:created, daemon:heartbeat, etc.) pass through unfiltered.

      --idle-timeout <IDLE_TIMEOUT>
          Exit after N seconds of no events (0 = never)

          [default: 0]

      --count <COUNT>
          Maximum number of events to receive before exiting (0 = unlimited)

          [default: 0]

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb serve`  Start HTTP server for sync operations

```
Start HTTP server for sync operations

Usage: git-kb serve [OPTIONS]

Options:
      --port <PORT>
          Port to listen on

          [default: 8080]

      --host <HOST>
          Host/IP to bind to

          [default: 127.0.0.1]

      --no-embeddings
          Disable embedding service (search will not be available)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb mcp`  Run MCP server for Claude Code / Cursor integration

```
Run MCP server for Claude Code / Cursor integration

Usage: git-kb mcp [OPTIONS]

Options:
  -f, --force
          Force start, killing any existing MCP server for this KB

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb context`  Get bootstrap context bundle for AI agent sessions

```
Get bootstrap context bundle for AI agent sessions

Usage: git-kb context [OPTIONS]

Options:
      --task <TASK>
          Specific task to include in context (slug or pathspec)

      --compact
          Compact mode - omit document content (only slugs and metadata)

  -n, --commits <COMMITS>
          Number of recent commits to include

          [default: 5]

      --code-refs
          Include code references from the task (enriched with symbol details)

      --smart-code
          Enable smart code context assembly (requires --task)

          Automatically assembles optimal context using: - Signal extraction from task (code refs, doc refs, file paths) - Call graph traversal for callers/callees - Token-budgeted prioritization

      --token-budget <TOKEN_BUDGET>
          Token budget for smart context (default: 8000)

          [default: 8000]

      --expand-callers
          Include callers of referenced symbols in smart context

      --expand-callees
          Include callees of referenced symbols in smart context

      --call-depth <CALL_DEPTH>
          Call graph traversal depth for smart context (default: 2)

          [default: 2]

      --include-semantic
          Include semantic search results (requires embeddings)

      --semantic-limit <SEMANTIC_LIMIT>
          Maximum number of semantic search results (default: 10)

          [default: 10]

      --min-score <MIN_SCORE>
          Minimum relevance score for smart context items (default: 0.3)

          [default: 0.3]

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb ready`  Show highest-scored ready task

```
Show highest-scored ready task

Usage: git-kb ready [OPTIONS]

Options:
      --limit <LIMIT>
          Maximum number of candidates to return

          [default: 1]

      --json
          Output as JSON (includes score and breakdown)

      --context
          Include full context bundle (task body, graph neighbors, code refs)

      --smart-code
          Additionally include callers/callees of referenced symbols (requires --context)

      --budget <BUDGET>
          Token budget for context bundle (default: 8000, requires --context)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb resolve`  Resolve which task the current agent should work on

```
Resolve which task the current agent should work on

Usage: git-kb resolve [OPTIONS]

Options:
      --env
          Resolve from GITKB_TASK environment variable

      --branch <BRANCH>
          Fuzzy-match a branch name to a task slug

      --auto
          Auto-resolve: env var → agent binding → worktree binding → branch → empty

      --fallback-recent
          When --auto finds no binding or branch match, fall back to the most recently modified active task. Off by default. Only valid with --auto

      --json
          Output as JSON (for tooling)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb repo`  Manage repository discovery and aliases

```
Manage repository discovery and aliases

Usage: git-kb repo [OPTIONS] <COMMAND>

Commands:
  list  List discovered repos with aliases and remotes

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb config`  Read configuration values from .kb/config.toml

```
Read configuration values from .kb/config.toml

Usage: git-kb config [OPTIONS] <COMMAND>

Commands:
  get  Get a config value by dot-separated key path

Options:
  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Code intelligence

  ` git-kb code index`  Index source code symbols from files

```
Index source code symbols from files

Usage: git-kb code index [OPTIONS] [PATHS]...

Arguments:
  [PATHS]...
          Paths to index (files or directories). Defaults to current directory

Options:
      --force
          Force reindexing even if content hasn't changed

      --dry-run
          Show what would be indexed without actually storing

      --prune
          Remove symbols for files that no longer exist

      --language <LANGUAGE>
          Only index files of this language

      --include-deps
          Include dependency directories (target/, node_modules/, etc.)

      --index-only
          Only extract and store symbols (skip embedding)

      --embed-only
          Only embed files (skip symbol extraction). Requires prior indexing

      --branch <BRANCH>
          Branch to tag symbols with (overrides auto-detection). Auto-detected via `git branch --show-current` when not specified

      --worktree <WORKTREE>
          Worktree path: sets root_override to the given directory's git repo root and auto-detects the branch from that worktree. Use when indexing files from a git worktree outside GITKB_ROOT

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version

IGNORE PATTERNS:
  Indexing respects both .gitignore and .gitkbignore files.

  .gitignore   Standard Git ignore patterns — files ignored by Git are also
               skipped during indexing (e.g. target/, node_modules/).

  .gitkbignore GitKB-specific ignore patterns — use this to exclude files from
               code indexing that you still want tracked by Git. Supports the
               same glob syntax as .gitignore.

               Place .gitkbignore in your project root or any subdirectory.
               Patterns are relative to the directory containing the file.

  Example .gitkbignore:
    fixtures/          # test fixture data
    *.generated.rs     # generated code
    vendor/            # vendored dependencies
```

 ` git-kb code symbols`  Query indexed code symbols

```
Query indexed code symbols

Usage: git-kb code symbols [OPTIONS] [QUERY]

Arguments:
  [QUERY]
          Search query (matches symbol names)

Options:
      --file <FILE>
          Filter by file path

      --kind <KIND>
          Filter by symbol kind (function, method, struct, class, etc.)

      --language <LANGUAGE>
          Filter by language (rust, python, typescript, etc.)

      --path <PATH>
          Filter by file path glob pattern (e.g., "**/sync/**", "crates/**/*.rs"). Case-sensitive. Uses `*` for any chars and `?` for single char

      --parent <PARENT>
          Filter by parent type name (e.g., "Store", "ListArgs")

      --limit <LIMIT>
          Maximum number of results (-1 for no limit)

          [default: 50]

      --offset <OFFSET>
          Number of results to skip

      --body
          Show full symbol bodies (incompatible with --group-by)

      --count
          Show symbol count only

      --json
          Output format as JSON

      --compact
          Compact JSON output (omits indexing internals). Only affects --json

      --group-by <GROUP_BY>
          Group output by a field. Supported values: "file"

      --branch <BRANCH>
          Filter to a specific branch. When omitted, queries the configured default branch only. Pass an explicit branch to apply overlay semantics (feature branch symbols for re-indexed files, default branch symbols for all other files)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code callers`  Find callers of a function/method

```
Find callers of a function/method

Usage: git-kb code callers [OPTIONS] <SYMBOL>

Arguments:
  <SYMBOL>
          Symbol name or symbol_id to query. When the name matches multiple symbols, results for all matches are shown (use --strict to error instead)

Options:
      --depth <DEPTH>
          Maximum traversal depth (0 = direct only)

          [default: 0]

      --limit <LIMIT>
          Maximum number of results (-1 for no limit)

          [default: 50]

      --json
          Output as JSON

      --strict
          Error on ambiguous symbol (exit 38) instead of showing all matches

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code callees`  Find functions/methods called by a symbol

```
Find functions/methods called by a symbol

Usage: git-kb code callees [OPTIONS] <SYMBOL>

Arguments:
  <SYMBOL>
          Symbol name or symbol_id to query. When the name matches multiple symbols, results for all matches are shown (use --strict to error instead)

Options:
      --depth <DEPTH>
          Maximum traversal depth (0 = direct only)

          [default: 0]

      --limit <LIMIT>
          Maximum number of results (-1 for no limit)

          [default: 50]

      --json
          Output as JSON

      --strict
          Error on ambiguous symbol (exit 38) instead of showing all matches

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code impact`  Analyze change impact for a file via call graph

```
Analyze change impact for a file via call graph

Usage: git-kb code impact [OPTIONS] <FILE_PATH>

Arguments:
  <FILE_PATH>
          File path to analyze impact for

Options:
      --depth <DEPTH>
          Maximum traversal depth (0 = direct only)

          [default: 0]

      --limit <LIMIT>
          Maximum number of results (-1 for no limit)

          [default: 50]

      --format <FORMAT>
          Output format: text (default) or json

          Possible values:
          - text: Human-readable text output (default)
          - json: JSON output for scripting and automation

          [default: text]

      --json
          Output as JSON (shorthand for --format json)

      --compact
          Compact JSON output (omits indexing internals). Only affects JSON output

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code dead`  Find potentially dead code (symbols with no callers)

```
Find potentially dead code (symbols with no callers)

Usage: git-kb code dead [OPTIONS]

Options:
      --file <FILE>
          Filter by file path (optional)

      --kind <KIND>
          Filter by symbol kind (e.g., "function", "method")

      --include-tests
          Include test functions in results

      --limit <LIMIT>
          Maximum results to return (-1 for no limit)

          [default: 100]

      --offset <OFFSET>
          Number of results to skip

      --format <FORMAT>
          Output format: text (default) or json

          Possible values:
          - text: Human-readable text output (default)
          - json: JSON output for scripting and automation

          [default: text]

      --json
          Output as JSON (shorthand for --format json)

      --compact
          Compact JSON output (omits indexing internals). Only affects JSON output

      --group-by <GROUP_BY>
          Group output by a field. Supported values: "file"

      --exclude-tests
          Exclude test symbols from output

      --branch <BRANCH>
          Filter to a specific branch. When omitted, defaults to the configured default branch (code.default_branch)

      --include-entrypoints
          Include inferred entrypoints in results

      --include-public
          Include public/exported symbols in results

      --explain
          Include classification evidence in JSON and query-template output

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code refs`  Find documents referencing a code symbol

```
Find documents referencing a code symbol

Usage: git-kb code refs [OPTIONS] <SYMBOL>

Arguments:
  <SYMBOL>
          Symbol ID to find references for (e.g., "src/auth.rs::login")

Options:
      --json
          Output as JSON with per-match confidence scores

      --textual
          Only show textual matches, skip wikilinks

      --wikilinks-only
          Only show wikilink matches (current default behaviour)

      --include-maybe
          Include low-confidence `[maybe]` hits (suppressed by default)

      --strict
          Require file-path anchor for every textual match (drops standalone name citations)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code stats`  Show code index statistics

```
Show code index statistics

Usage: git-kb code stats [OPTIONS]

Options:
      --branch <BRANCH>
          Filter statistics to a specific branch. When omitted, aggregates across all branches

      --format <FORMAT>
          Output format: text (default) or json

          Possible values:
          - text: Human-readable text output (default)
          - json: JSON output for scripting and automation

          [default: text]

      --json
          Output as JSON (shorthand for --format json)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code doctor`  Diagnose code-intelligence index health

```
Diagnose code-intelligence index health

Usage: git-kb code doctor [OPTIONS]

Options:
      --branch <BRANCH>
          Filter diagnostics to a specific branch

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code entrypoints`  Inspect inferred code entrypoints

```
Inspect inferred code entrypoints

Usage: git-kb code entrypoints [OPTIONS]

Options:
      --refresh
          Refresh inferred entrypoints before listing

      --branch <BRANCH>
          Filter to a specific branch

      --limit <LIMIT>
          Maximum number of results

          [default: 100]

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code flows`  List traced execution flows

```
List traced execution flows

Usage: git-kb code flows [OPTIONS]

Options:
      --refresh
          Refresh flows before listing

      --branch <BRANCH>
          Filter to a specific branch

      --depth <DEPTH>
          Maximum traversal depth when refreshing

          [default: 8]

      --limit <LIMIT>
          Maximum number of flows to list

          [default: 50]

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code flow`  Inspect one traced execution flow

```
Inspect one traced execution flow

Usage: git-kb code flow [OPTIONS] <FLOW_ID>

Arguments:
  <FLOW_ID>
          Flow id to inspect

Options:
      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code query`  Run typed code graph query templates

```
Run typed code graph query templates

Usage: git-kb code query [OPTIONS] <TEMPLATE>

Arguments:
  <TEMPLATE>
          Query template to run

          [possible values: hotspots, public-api, entrypoints, unresolved-by-reason, cross-service-impact, dead-code-explain]

Options:
      --target <TARGET>
          Optional target string for templates that need one

      --branch <BRANCH>
          Filter to a specific branch

      --limit <LIMIT>
          Maximum result count

          [default: 50]

      --depth <DEPTH>
          Maximum traversal depth for templates that traverse

      --include-docs
          Include related KB document information where supported

      --refresh
          Refresh derived tables before running templates that support it

      --json
          Output as JSON

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code dump-ast`  Print the tree-sitter parse tree for a file

```
Print the tree-sitter parse tree for a file

Usage: git-kb code dump-ast [OPTIONS] <PATH>

Arguments:
  <PATH>
          Path to the file to parse

Options:
      --language <LANGUAGE>
          Override language detection (e.g., "rust", "python")

      --lines <LINES>
          Only show nodes overlapping this line range (e.g., "10-25"). Lines are 1-indexed

      --json
          Output as JSON instead of indented text

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code prune`  Remove stale branch symbols from the code index

```
Remove stale branch symbols from the code index

Usage: git-kb code prune [OPTIONS]

Options:
      --worktree <WORKTREE>
          Prune symbols for the branch associated with the given worktree path. Derives branch from `git -C <path> rev-parse --abbrev-ref HEAD`. The worktree directory must still exist

      --branch <BRANCH>
          Prune symbols for the named branch

      --repo <REPO>
          Scope `--branch` pruning to a single repo (matched by file_path prefix). Use when the same branch name exists across multiple repos in a meta workspace

      --stale
          Scan all branches in the DB and prune those with no live git ref or active worktree

      --dry-run
          Show what would be pruned without actually deleting

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb code detect-default-branches`  Detect default git branches for all repos and write to [code.repo_default_branch_map]

```
Detect default git branches for all repos and write to [code.repo_default_branch_map]

Usage: git-kb code detect-default-branches [OPTIONS]

Options:
      --dry-run
          Preview what would be written without modifying config.toml

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## AI-powered features

  ` git-kb ai embed`  Generate embeddings for documents and code

```
Generate embeddings for documents and code

Usage: git-kb ai embed [OPTIONS] [COMMAND]

Commands:
  stats    Show vector index statistics
  rebuild  Rebuild vector index from stored embeddings

Options:
      --scope <SCOPE>
          Scope: documents, code, or all

          [default: all]

      --force
          Re-generate even if content hasn't changed

      --dry-run
          Report what would be embedded without generating

      --doc-type <type>
          Filter by document type (only for document scope)

      --language <LANGUAGE>
          Filter by programming language (only for code scope)

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

 ` git-kb ai semantic`  Semantic search across documents and code

```
Semantic search across documents and code

Usage: git-kb ai semantic [OPTIONS] <QUERY>

Arguments:
  <QUERY>
          Natural language query

Options:
      --limit <LIMIT>
          Maximum number of results

          [default: 10]

      --threshold <THRESHOLD>
          Minimum similarity threshold (0.0 to 1.0)

          [default: 0.5]

      --scope <SCOPE>
          Search scope: documents, code, or all

          [default: all]

      --doc-type <type>
          Filter by document type (only for document scope)

      --language <LANGUAGE>
          Filter by programming language (only for code scope)

      --file-path <FILE_PATH>
          Filter by file path prefix (only for code scope)

      --format <FORMAT>
          Output format: table or json

          Possible values:
          - table: Formatted table (default)
          - json:  JSON output for scripting

          [default: table]

      --json
          Output as JSON (shorthand for --format json)

      --remote
          Include results from configured remote (federated search).

          When set, searches both local and remote indices, merging results. Requires a remote to be configured (see `git-kb init --remote <url>`).

      --expand
          Expand code hits with source content read from disk

  -v, --verbose
          Enable verbose output

  -q, --quiet
          Suppress non-essential output

      --color <COLOR>
          Color output mode

          Possible values:
          - auto:   Auto-detect TTY
          - always: Always use colors
          - never:  Never use colors

          [default: auto]

      --log-format <LOG_FORMAT>
          Log output format (pretty, compact, json)

          Possible values:
          - pretty:  Human-readable with colors (default)
          - compact: Compact single-line format
          - json:    JSON format for machine parsing

          [default: pretty]

      --no-pager
          Disable pager for commands that support it

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Environment variables

 ` GITKB_ROOT`  Override KB root discovery. Uses this path instead of searching upward for ` .kb/` .   Migration &  Adoption  MCP Tools
