## Project Architecture: Meta-Repo (NOT a monorepo)

This is a **meta-repo** — a workspace of independent git repositories managed by the `meta` CLI tool. Each directory listed in `.meta` (the project config) is a **separate git repo** with its own remote, commits, and history.

**Critical rules:**
- NEVER assume this is a monorepo. There is no single shared git history.
- Each workspace member (e.g., `meta_cli/`, `meta_core/`, `loop_lib/`) is its own git repo cloned from its own GitHub remote.
- The root `.gitignore` ignores all child repos because they are NOT part of the parent repo.
- The root `Cargo.toml` defines a Rust workspace for local development convenience, but each member builds and publishes independently.
- When creating a new crate/package, it MUST be initialized as a separate git repo, pushed to GitHub under `FlexNetOS/`, and added to both `.meta` (projects config) and `.gitignore`.

**Project config (`.meta.yaml`):**
```yaml
projects:
  meta_cli:
    repo: git@github.com:FlexNetOS/meta_cli.git
  meta_core:
    repo: git@github.com:FlexNetOS/meta_core.git
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

## Environment manager: envctl

`envctl` is a first-class meta peer member (registered in `.meta.yaml`, `tags: [tools, env]`) and **meta's agentic environment manager**. Every tool, dependency, provider, vendor, CLI, and config that meta uses is installed **into meta** by envctl — `meta/.toolchains/` under `$META_ROOT` — with **no system-depth or user-global installs**. Anything meta uses lives in meta, portable wherever meta is cloned; global paths (`~/.local/bin`, `~/.config`, `~/.claude`) hold only symlinks pointing INTO meta, never the reverse. See `envctl/` and the portability ADRs (`envctl/docs/adr-install-locations-and-local-state.md`, `adr-meta-tool-location-and-portability.md`).

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

## FlexNetOS

This project uses FlexNetOS for knowledge management.

@.kb/AGENTS.md

<!-- vox:start -->
After completing a significant task, call `vox "short summary in English"` to give a spoken summary.
<!-- vox:end -->

## Harness: Handoff Continuity (FIX-6 enforcement kit)

**Goal:** the handoff kernel (`hf` + `.handoff/`) is the only continuity path — packets are rendered from the witnessed ledger, never hand-written.

**Trigger:** for any session start/end, checkpoint, resume, or handoff work, use the `handoff-discipline` skill (slash commands: `/handoff` `/resume` `/mint` `/checkpoint` `/fleet`). Verifying a CLI change → `verifier-cli` skill. Deciding a queued approval → `handoff-steward` agent (witnessed verdicts only, scope law applies).

**Change history:**
| Date | Change | Target | Reason |
|------|--------|--------|--------|
| 2026-06-12 | Initial kit | 5 commands, 2 skills, steward agent, 2 hook scripts, guard file-rule, p7-conformance CI, HARNESS-UPGRADE-KIT v2 | FIX-6: owner-flagged handoff-convention drift; ADR-0004 enforcement |

## Auto-merge + pre-push preflight gate

**Standing rule:** every PR gets GitHub auto-merge armed (`gh pr merge <n> --auto --squash`) — the pipeline is push → PR → self-merge on green. A PR self-blocks (`mergeStateStatus=BLOCKED`) when any *required* check fails, and the usual silent culprit is **Format** (`cargo fmt --check`) failing while tests are green.

**The gate:** `scripts/preflight.sh` runs the fast required checks locally (`cargo fmt`, then clippy — which covers `Check`). It is deliberately a *subset* of CI (never stricter, so it can't false-block); tests/audit/deny stay in CI. The clippy step **mirrors each repo's OWN CI clippy flags** (per-repo CI mirror, see below) so it is an exact subset of *that* repo's clippy gate — never stricter, never weaker. `scripts/install-preflight-hooks.sh` installs it as a `pre-push` hook into every Rust repo (idempotent; honors an existing `core.hooksPath`; never clobbers a foreign hook). Wired into `scripts/bootstrap.sh` phase 6 so fresh clones get it.

**Package scoping (important):** Cargo walks *up* to the outermost workspace, so inside the meta tree a member repo's `cargo fmt --all`/`clippy --workspace` would lint the **entire** meta workspace (other sibling repos) — far stricter than that repo's standalone CI (which clones it alone). The gate therefore selects only packages belonging to **this git repo** (those whose manifest shares the repo's `git rev-parse --show-toplevel`, which also excludes nested child repos) and scopes `cargo fmt -p …` / `cargo clippy -p …` to them. A virtual meta-root manifest (members all nested repos) resolves to zero own packages and is skipped.

**Per-repo CI mirror (important):** the clippy step is an exact *subset-mirror* of each repo's own CI clippy invocation — never stricter than that repo's CI, never weaker. It greps the repo's `.github/workflows/*.yml` for the `cargo clippy` line and mirrors its flags:
- **`--all-targets`** — if the repo's CI uses it (e.g. **handoff**, `cargo clippy --workspace --all-targets -- -D warnings`), preflight adds it too. `--all-targets` **lints test code**; without mirroring it, a test-code lint (e.g. a needless `&borrow` inside a `#[cfg(test)]` assert) passes preflight but **fails CI** — exactly the gap that sank PR #30. The old gate hard-coded "no `--all-targets`" assuming it was always stricter than CI; that's only true for repos whose CI *doesn't* use it, so it must be decided **per repo**. A blanket `--all-targets` would be wrong too — it would false-block repos whose CI omits it.
- **default behavior** — if no CI clippy line is detectable (or no `.github/workflows`), the gate keeps the `--all-features` strategy below unchanged, so repos without detectable CI never regress.

**Feature strategy (the `--all-features` axis, important):** the clippy step tries `--all-features` first (strictest useful combo; what repos like prompt_hub require in CI). But `--all-features` can enable combos a repo's CI never uses and that don't even compile — mutually-exclusive backends (weave's `sqlite`+`libsql` → `E0255`/`compile_error!`) or deprecated empty features whose cfg'd code references removed modules (shimmy's `llama` → `E0433`). Those are feature-combo artifacts, not lint failures. So if `--all-features` fails, the gate retries with **default features**; if default passes, the failure was an `--all-features` artifact and is **not** blocked (the gate must be a strict *subset* of CI, never stricter — genuine `--all-features`-only issues are CI's job). It blocks only if **default features** also fail. The mirrored `--all-targets` flag is carried into **both** attempts and is **not** subject to this fallback (an `--all-targets` failure is a real test-code lint that IS in CI and should block).

- Install/refresh across the workspace: `bash scripts/install-preflight-hooks.sh`
- Bypass once (emergency): `SKIP_PREFLIGHT=1 git push` or `git push --no-verify`
- A repo whose `main` genuinely fails its real clippy gate will have pushes blocked until main is green — that's correct (it can't auto-merge either); fix main or bypass.
