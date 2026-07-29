<!-- Source: https://gitkb.com/docs/reference/configuration/ -->
<!-- Snapshot: 2026-07-02 -->

# Configuration

GitKB stores its configuration in ` .kb/config.toml` , created when you run ` git-kb init` . This file lives alongside the KB database inside the ` .kb/`  directory.

## Minimal config

A freshly initialized KB starts with an empty config. GitKB works with sensible defaults — you only need to add settings you want to customize.

```
[identity]
# Uses your git config name/email by default
```

## Full annotated reference

### `[identity]`

Override the author identity used for KB commits. If omitted, GitKB reads from your git config (` user.name`  and ` user.email` ).

```
[identity]
name = "Alice"
email = "alice@example.com"
```

### `[sync.remotes. < name > ]`

Define named remotes for pushing and pulling KB state. Each remote needs a ` url`  pointing to a GitKB sync endpoint.

```
[sync.remotes.origin]
url = "https://gitkb.com/my-org/my-kb"

[sync.remotes.staging]
url = "gitkb://gitkb.com/my-org/my-kb"
```

Use ` git-kb remote add < name >  < url >`  to add remotes via the CLI instead of editing this file directly.

### `[repos]`

Configure repository discovery strategy. This controls how GitKB finds and manages repositories in your project.

```
[repos]
strategy = "meta"   # Use meta-repo discovery (for multi-repo workspaces)
# strategy = "auto"  # Default — auto-detect single repo
```

Value | Description
`"auto"` | Default. Single repository, discovered by searching upward for ` .git/` .
`"meta"` | Multi-repo workspace managed by ` meta` . GitKB discovers repos via ` .meta`  configuration.

### `[code]`

Configure the code intelligence indexer.

```
[code]
index_threads = 0            # 0 = auto (num_cpus / 2, min 1)
default_branch = "main"      # Default branch for single-repo indexing

[code.repo_default_branch_map]
"api/" = "main"              # Per-repo branch overrides (multi-repo)
"frontend/" = "develop"
```

Key | Type | Default | Description
`index_threads` | integer | ` 0` | Number of threads for code indexing. ` 0`  uses half of available CPU cores (minimum 1).
`default_branch` | string | auto-detected | Default branch for code indexing in single-repo setups. Detected at ` git-kb init`  or via ` git-kb code detect-default-branches` .
`repo_default_branch_map` | table | ` {}` | Per-repo branch map for multi-repo setups. Keys are repo paths relative to KB root. Populated by ` git-kb code detect-default-branches` .

### `[embeddings]`

Configure the embedding engine for semantic search. Embeddings are disabled by default — enable them to use ` git-kb ai semantic`  and the ` kb_semantic`  MCP tool.

```
[embeddings]
enabled = true
backend = "candle"
model = "BAAI/bge-small-en-v1.5"   # optional model override
batch_size = 16
queue_size = 64
batch_delay_ms = 0
```

Key | Type | Default | Description
`enabled` | boolean | ` false` | Enable embedding generation and semantic search.
`backend` | string | ` "candle"` | Embedding backend: ` "candle"`  (Metal/CUDA/CPU) or ` "mlx"`  (Apple Silicon, experimental).
`model` | string | backend default | Override the default model for the selected backend. Only set this to use a different model (e.g., a code-specific model).
`batch_size` | integer | ` 16` | Maximum texts per GPU forward pass. Lower this if you experience system freezes during embedding.
`queue_size` | integer | ` 64` | Bounded channel capacity for the embedding queue. Controls backpressure between indexer and embedding consumer.
`batch_delay_ms` | integer | ` 0` | Safety-net delay between GPU forward passes in milliseconds. Set nonzero only as a fallback if your machine becomes unresponsive.

### `[embeddings.index]`

Configure where the vector index is stored on disk.

```
[embeddings.index]
path = ".kb/cache/index"
```

Key | Type | Default | Description
`path` | string | ` ".kb/cache/index"` | Directory for the vector similarity index. Relative to the KB root.

### `[auth]`

Configure authentication for the sync server (used when running ` git-kb serve` ).

```
[auth]
mode = "optional"   # or "required"

[auth.api_keys]
# key_name = "key_value"
```

Key | Type | Default | Description
`mode` | string | ` "optional"` | ` "optional"`  allows unauthenticated access. ` "required"`  enforces API key authentication.
`api_keys` | table | ` {}` | Named API keys for authenticating sync requests.

### `[pager]`

Configure external pagers for rendering output. GitKB supports two pager types for different output kinds.

```
[pager]
markdown = "glow -t -w 0"   # For `git-kb show` output
plain = "less -FRX"          # For `git-kb log`, `list`, `board`, `diff`
```

Key | Type | Default | Description
`markdown` | string | none | Command to pipe Markdown output through (used by ` git-kb show` ). glow  works well. If unset, Markdown renders as plain text.
`plain` | string | none | Command to pipe plain/tabular output through (used by ` git-kb log` , ` list` , ` board` , ` diff` ). ` less -FRX`  is a good choice.

### `[hooks]`

Feature toggles for GitKB lifecycle hooks. Harness adapters (Claude Code, Codex, Cursor, etc.) read these to control which automation features are active.

```
[hooks]
context_injection = true     # Inject task context on session start
auto_commit_link = true      # Auto-link git commits to active task
auto_worktree_bind = true    # Match worktree branches to task slugs
auto_progress = false        # Append progress entries on session end
prompt_context = false       # Inject relevant KB docs on each prompt
```

Key | Type | Default | Description
`context_injection` | boolean | ` true` | Inject task context on session start and agent spawn.
`auto_commit_link` | boolean | ` true` | Automatically link git commits to the active task via ` [[slug]]`  wikilinks.
`auto_worktree_bind` | boolean | ` true` | Match worktree branch names to task slugs for automatic task resolution.
`auto_progress` | boolean | ` false` | Append progress entries to the active task document on session end.
`prompt_context` | boolean | ` false` | Inject relevant KB documents into each prompt for additional context.

## Example: full config

```
[identity]
name = "Alice"
email = "alice@example.com"

[sync.remotes.origin]
url = "https://gitkb.com/acme/main-kb"

[repos]
strategy = "auto"

[code]
index_threads = 0
default_branch = "main"

[embeddings]
enabled = true
backend = "candle"
batch_size = 16
queue_size = 64
batch_delay_ms = 0

[embeddings.index]
path = ".kb/cache/index"

[auth]
mode = "optional"

[auth.api_keys]

[pager]
markdown = "glow -t -w 0"
plain = "less -FRX"

[hooks]
context_injection = true
auto_commit_link = true
auto_worktree_bind = true
auto_progress = false
prompt_context = false
```

## Next steps

- CLI Reference  — Commands that read and modify configuration

- Daemon  — Background service configured via these settings

- Team Collaboration  — Using remotes for team workflows
