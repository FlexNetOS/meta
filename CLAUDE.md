## Project Architecture: Meta-Repo (NOT a monorepo)

This is a **meta-repo** — a workspace of independent git repositories managed by the `meta` CLI tool. Each directory listed in `.meta` (the project config) is a **separate git repo** with its own remote, commits, and history.

**Critical rules:**
- NEVER assume this is a monorepo. There is no single shared git history.
- Each workspace member (e.g., `meta_cli/`, `meta_core/`, `loop_lib/`) is its own git repo cloned from its own GitHub remote.
- The root `.gitignore` ignores all child repos because they are NOT part of the parent repo.
- The root `Cargo.toml` defines a Rust workspace for local development convenience, but each member builds and publishes independently.
- When creating a new crate/package, it MUST be initialized as a separate git repo, pushed to GitHub under `gitkb/`, and added to both `.meta` (projects config) and `.gitignore`.

**Project config (`.meta.yaml`):**
```yaml
projects:
  meta_cli:
    repo: git@github.com:gitkb/meta_cli.git
  meta_core:
    repo: git@github.com:gitkb/meta_core.git
```

**Nested meta repos:** Use `meta: true` when a child project contains its own `.meta.yaml`:
```yaml
projects:
  open-source:
    repo: git@github.com:org/open-source.git
    meta: true  # This directory has its own .meta.yaml
```

This enables recursive operations:
```bash
meta git update          # Clones nested meta repos automatically
meta project list -r     # Shows full tree
meta exec -r cargo test  # Runs across all nested repos
```

**What `meta` does:** Clones all child repos, runs commands across them in parallel (`meta exec`), manages git worktrees across the entire workspace (`meta worktree`), and provides project-level coordination.

## Logging & Debugging

The meta CLI uses the `log` crate with `env_logger`. Use `RUST_LOG` to control debug output:

```bash
# Debug the host CLI
RUST_LOG=meta=debug meta git push

# Debug the git plugin (subprocess)
RUST_LOG=meta_git_cli=debug meta git push

# Debug everything
RUST_LOG=debug meta git push

# Debug specific modules
RUST_LOG=meta_git_cli::ssh_setup=debug meta git push
```

**Crate names for RUST_LOG:**
- `meta` - Host CLI (meta_cli)
- `meta_git_cli` - Git plugin
- `meta_project_cli` - Project plugin
- `meta_rust_cli` - Rust plugin
- `meta_git_lib` - Git library
- `loop_lib` - Command execution library

**Architecture:** Subprocess plugins initialize their own logger via `meta_plugin_protocol::run_plugin()`, inheriting `RUST_LOG` from the parent process.

## GitKB

This project uses GitKB for knowledge management.

@.kb/AGENTS.md

<!-- rtk-instructions v2 -->
# RTK (Rust Token Killer) - Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged. This means RTK is always safe to use.

**Important**: Even in command chains with `&&`, use `rtk`:
```bash
# ❌ Wrong
git add . && git commit -m "msg" && git push

# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## RTK Commands by Workflow

### Build & Compile (80-90% savings)
```bash
rtk cargo build         # Cargo build output
rtk cargo check         # Cargo check output
rtk cargo clippy        # Clippy warnings grouped by file (80%)
rtk tsc                 # TypeScript errors grouped by file/code (83%)
rtk lint                # ESLint/Biome violations grouped (84%)
rtk prettier --check    # Files needing format only (70%)
rtk next build          # Next.js build with route metrics (87%)
```

### Test (60-99% savings)
```bash
rtk cargo test          # Cargo test failures only (90%)
rtk go test             # Go test failures only (90%)
rtk jest                # Jest failures only (99.5%)
rtk vitest              # Vitest failures only (99.5%)
rtk playwright test     # Playwright failures only (94%)
rtk pytest              # Python test failures only (90%)
rtk rake test           # Ruby test failures only (90%)
rtk rspec               # RSpec test failures only (60%)
rtk test <cmd>          # Generic test wrapper - failures only
```

### Git (59-80% savings)
```bash
rtk git status          # Compact status
rtk git log             # Compact log (works with all git flags)
rtk git diff            # Compact diff (80%)
rtk git show            # Compact show (80%)
rtk git add             # Ultra-compact confirmations (59%)
rtk git commit          # Ultra-compact confirmations (59%)
rtk git push            # Ultra-compact confirmations
rtk git pull            # Ultra-compact confirmations
rtk git branch          # Compact branch list
rtk git fetch           # Compact fetch
rtk git stash           # Compact stash
rtk git worktree        # Compact worktree
```

Note: Git passthrough works for ALL subcommands, even those not explicitly listed.

### GitHub (26-87% savings)
```bash
rtk gh pr view <num>    # Compact PR view (87%)
rtk gh pr checks        # Compact PR checks (79%)
rtk gh run list         # Compact workflow runs (82%)
rtk gh issue list       # Compact issue list (80%)
rtk gh api              # Compact API responses (26%)
```

### JavaScript/TypeScript Tooling (70-90% savings)
```bash
rtk pnpm list           # Compact dependency tree (70%)
rtk pnpm outdated       # Compact outdated packages (80%)
rtk pnpm install        # Compact install output (90%)
rtk npm run <script>    # Compact npm script output
rtk npx <cmd>           # Compact npx command output
rtk prisma              # Prisma without ASCII art (88%)
```

### Files & Search (60-75% savings)
```bash
rtk ls <path>           # Tree format, compact (65%)
rtk read <file>         # Code reading with filtering (60%)
rtk grep <pattern>      # Search grouped by file (75%). Format flags (-c, -l, -L, -o, -Z) run raw.
rtk find <pattern>      # Find grouped by directory (70%)
```

### Analysis & Debug (70-90% savings)
```bash
rtk err <cmd>           # Filter errors only from any command
rtk log <file>          # Deduplicated logs with counts
rtk json <file>         # JSON structure without values
rtk deps                # Dependency overview
rtk env                 # Environment variables compact
rtk summary <cmd>       # Smart summary of command output
rtk diff                # Ultra-compact diffs
```

### Infrastructure (85% savings)
```bash
rtk docker ps           # Compact container list
rtk docker images       # Compact image list
rtk docker logs <c>     # Deduplicated logs
rtk kubectl get         # Compact resource list
rtk kubectl logs        # Deduplicated pod logs
```

### Network (65-70% savings)
```bash
rtk curl <url>          # Compact HTTP responses (70%)
rtk wget <url>          # Compact download output (65%)
```

### Meta Commands
```bash
rtk gain                # View token savings statistics
rtk gain --history      # View command history with savings
rtk discover            # Analyze Claude Code sessions for missed RTK usage
rtk proxy <cmd>         # Run command without filtering (for debugging)
rtk init                # Add RTK instructions to CLAUDE.md
rtk init --global       # Add RTK to ~/.claude/CLAUDE.md
```

## Token Savings Overview

| Category | Commands | Typical Savings |
|----------|----------|-----------------|
| Tests | vitest, playwright, cargo test | 90-99% |
| Build | next, tsc, lint, prettier | 70-87% |
| Git | status, log, diff, add, commit | 59-80% |
| GitHub | gh pr, gh run, gh issue | 26-87% |
| Package Managers | pnpm, npm, npx | 70-90% |
| Files | ls, read, grep, find | 60-75% |
| Infrastructure | docker, kubectl | 85% |
| Network | curl, wget | 65-70% |

Overall average: **60-90% token reduction** on common development operations.
<!-- /rtk-instructions -->
## Active-tool `~/.local/share` state — restart-gated migration to the Meta payload

**Status (2026-07-21).** Sole remaining `.local` residual in the FlexNetOS operational
environment. Meta-repo docs conformance and meta-root `.local` are already done
(meta PR #110; ~1.7G of dev-host `.local`/shadow state relocated to `meta/var/archives/`;
single nix-profile owner confirmed). This note records the one piece that a session-
internal agent structurally cannot finish.

**Subject.** The FlexNetOS agent tools `icm`, `rtk`, `yazelix`, `weave`, `env-ctl` keep
durable data under `~/.local/share/<tool>` because `XDG_DATA_HOME` is unset (→
`~/.local/share`). Under the single-profile path law and the RuVector blueprint (files
are projections; one canonical source), that durable tool state belongs in the Meta
payload `meta/var/xdg-data/<tool>` — the tier already hosting
`var/lib/{postgresql,ruvector,agentdb,envctl,gitkb}`.

**Why it cannot be eliminated from inside a running session (empirically verified).**
An agent running inside a yazelix session cannot remove the `.local` its own live
toolchain is bound to:
- Tools resolve their data dir from the session env at process start; the running
  process's env is immutable mid-session.
- `~/.local/share/yazelix` is written continuously by the **running zellij** that hosts
  the session (`YAZELIX_STATUS_BAR_CACHE_PATH`, `STARSHIP_CONFIG`) — un-movable without
  ending the session.
- ICM's `[store].path` config key is parsed but **ignored** for the default DB (only
  `--db` / `ICM_DB` / the XDG default apply — its docs say "the CLI reads the DB only
  from `--db`"; tested: a probe with `[store].path` set still landed in `~/.local`).
- `rtk` has no data-dir config (`[tracking]/[display]/[filters]/[tee]/[telemetry]/
  [hooks]/[limits]` only).
- envctl's `bootstrap_env_vars` table is inert without regeneration, and `envctl` is not
  on PATH from an in-session shell — so its committer path is unreachable in-session.
- Removing a dir → recreated on the next tool call (env still points there). Root
  bind-mount and symlinks are disallowed; a session cannot restart itself.

**The fix (owner action; one session restart).** Single lever = `XDG_DATA_HOME` /
`XDG_STATE_HOME`, owned by envctl's agent-env engine
(`meta/var/lib/envctl/tables/bootstrap_env_vars.csv`; rows currently point at
`~/.local/share` / `~/.local/state`):
1. `meta/var/ops/migrate-tool-state-off-dotlocal.sh migrate` — copy
   `~/.local/share/{tools}` → `meta/var/xdg-data` (+ `xdg-state`); verifies icm db
   integrity. (100M already staged; re-run to sync before restart.)
2. Via **envctl's committer** (sole authoritative committer — do NOT hand-edit the live
   table): `XDG_DATA_HOME` → `/home/flexnetos/meta/var/xdg-data`, `XDG_STATE_HOME` →
   `/home/flexnetos/meta/var/xdg-state`; add
   `ICM_DB=/home/flexnetos/meta/var/xdg-data/icm/memories.db`; leave `YAZELIX_STATE_DIR`
   unset (yzx baked default `/run/user/1001/yazelix/profile-runtime/yazelix`).
3. **Restart the yazelix session** so the agent env adopts the new roots.
4. `migrate-tool-state-off-dotlocal.sh verify` → `finalize` (removes
   `~/.local/share/{tools}` + `~/.local/state/env-ctl`; `finalize` refuses unless
   `XDG_DATA_HOME` is already redirected).

Full runbook: `meta/var/ops/README-migrate-tool-state.md`.
