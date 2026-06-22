---
name: meta-exec
description: Execute commands across all repos — parallel, filtered, dry-run modes.
---

# Meta Exec Skill

Execute any command across all repositories in the workspace. Meta extends `loop`, a tool for running commands across directories.

## The Execution Model

`rtk meta exec` runs a command in each repo directory:

```bash
# Run 'make build' in every repo
rtk meta exec -- rtk make build

# Run any shell command
rtk meta exec -- rtk ls -la

# Commands with arguments
rtk meta exec -- rtk npm install --save-dev typescript
```

The `--` separates meta options from the command to execute. The `--` is optional unless your command starts with `-`.

```bash
# These are equivalent:
rtk meta exec rtk make test
rtk meta exec -- rtk make test

# Use -- when command starts with dash:
rtk meta exec -- rtk --version
```

## Parallel vs Sequential

By default, commands run sequentially with live output. Use `--parallel` for concurrent execution:

```bash
# Sequential (default) - see output as it happens
rtk meta exec -- rtk cargo build

# Parallel - faster, grouped output after completion
rtk meta --parallel git status
```

Parallel mode:
- Uses rayon thread pool for bounded concurrency
- Shows spinners during execution (if TTY)
- Captures and displays output grouped by repo after completion

## Filtering Options

Control which repos run the command. These options come from `loop`:

```bash
# Only include specific directories (overrides config)
rtk meta --include api,worker git status

# Exclude specific directories (adds to ignores)
rtk meta --exclude legacy-service git push

# Filter by tag (meta-specific, applied before loop filtering)
rtk meta --tag backend exec -- rtk make deploy

# Combine: tag filter + directory filter
rtk meta --tag backend --include api git status
```

**Filter precedence:**
1. `--tag` filters projects by tag (meta level)
2. `--include` limits to specific directories (loop level)
3. `--exclude` removes directories (loop level)

## Dry Run

Preview what would happen without executing:

```bash
rtk meta --dry-run exec -- rtk rm -rf node_modules
```

Shows which repos would run the command, with `[DRY RUN]` prefix.

## JSON Output

Get structured output for parsing:

```bash
rtk meta --json exec -- rtk git rev-parse HEAD
```

Returns JSON with:
```json
{
  "success": true,
  "results": [
    {
      "directory": "./api",
      "command": "rtk git rev-parse HEAD",
      "success": true,
      "exit_code": 0,
      "stdout": "abc123...\n"
    }
  ],
  "summary": {
    "total": 5,
    "succeeded": 5,
    "failed": 0,
    "dry_run": false
  }
}
```

## Silent Mode

Suppress all output:

```bash
rtk meta --silent exec -- rtk npm install
```

## Global Options Reference

| Option | Description |
|--------|-------------|
| `--parallel` | Run commands concurrently |
| `--include <dirs>` | Only run in these directories |
| `--exclude <dirs>` | Skip these directories |
| `--tag <tags>` | Filter by project tag(s) |
| `--dry-run` | Preview without executing |
| `--json` | Structured JSON output |
| `--silent` | Suppress output |
| `--verbose` | Show detailed execution info |
| `--recursive` | Include nested meta repos |

## Practical Examples

### Build Everything
```bash
rtk meta exec -- rtk cargo build --release
```

### Run Tests (Parallel for Speed)
```bash
rtk meta --parallel git status
rtk meta --parallel exec -- rtk cargo test
```

### Update Dependencies Selectively
```bash
# Only frontend repos
rtk meta --tag frontend exec -- rtk npm update

# Exclude slow repos
rtk meta exec -- rtk cargo update --exclude large-monorepo
```

### Find Files Across Repos
```bash
rtk meta exec -- rtk find . -name "*.rs" -type f | rtk head -20
```

### Clean Build Artifacts
```bash
rtk meta exec -- rtk cargo clean
rtk meta exec -- rtk rm -rf node_modules dist
```

## When to Use Exec vs Plugins

| Use `rtk meta exec` | Use Plugin (e.g., `rtk meta git`) |
|-----------------|-------------------------------|
| Generic shell commands | Git operations |
| Build/test commands | Commands needing special handling |
| One-off scripts | Operations with meta-specific logic |
| npm/cargo/make | Clone, update, snapshot |

Plugins intercept command patterns and provide enhanced behavior. `rtk meta git clone` doesn't run `rtk git clone` in each repo—it reads `.meta` and clones the entire graph.

## Worktree Context Detection

When your cwd is inside a `.worktrees/<name>/` directory, `rtk meta exec` automatically scopes to the worktree's repos instead of the primary checkout:

```bash
cd .worktrees/auth-fix/backend
rtk meta exec -- rtk cargo test    # runs in auth-fix's repos

# Override with --primary to use primary checkout paths
rtk meta exec --primary -- rtk cargo test
```

This is filesystem-based detection—no store dependency. See `meta-worktree.md` for full worktree management.

## Efficiency Tips

- **Target precisely**: Use `--include`/`--exclude`/`--tag` to run commands in exactly the repos you need — avoids running commands you'll have to undo
- **Dependency order**: Use `--ordered` for dependency-aware build/test order (respects `depends_on` in `.meta.yaml`)
- **Avoid unnecessary parallel**: Don't use `--parallel` for operations with cross-repo dependencies — sequential with `--ordered` is safer
- **Dry run first**: `rtk meta --dry-run exec -- rtk dangerous-command` shows what would happen before committing
