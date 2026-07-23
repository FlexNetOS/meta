---
id: 019f2138-90d2-7291-8bac-4cf82ab99db3
slug: tasks/meta-clean-foundation-build-order
title: "Build meta from clean upstream foundation"
type: task
status: completed
priority: high
tags: [meta, setup, clean-foundation, gitkb]
---

# Overview

Use GitKB as the execution rail for setting up and building the upstream gitkb/meta workspace. The goal is to preserve the clean root mirror, avoid ad hoc overlays, and execute work in documented order.

This task is grounded in the upstream source files already present in the root mirror: AGENTS.md, CLAUDE.md, .kb/AGENTS.md, .meta.yaml, .context, and docs/.

## Constraints

- Root /home/flexnetos/FlexNetOS/src/meta stays an exact gitkb/meta mirror unless an explicit upstream change is being made.
- Do not create .codex in the root mirror.
- Treat this as a meta-repo, not a monorepo.
- Each child directory listed in .meta.yaml is an independent git repo with its own branch, remote, commits, and history.
- Use /home/flexnetos/FlexNetOS/usr/bin/git-kb until git-kb is exposed on PATH for git kb compatibility.

## Execution Order

1. Bootstrap the seven required GitKB context documents from upstream source docs only.
2. Validate KB context with list/show/status before build work.
3. Verify root mirror state: remote, branch, HEAD equals origin/main, clean tree.
4. Verify meta project inventory from .meta.yaml and meta project list.
5. Verify child repo cleanliness and branch state with meta exec.
6. Build/test in dependency order from .meta.yaml provides/depends_on.
7. Record build results and any blockers in this task before changing source.
8. Only after source-backed context and build evidence exist, decide whether any additive setup belongs upstream, in a child repo, or outside the mirror.

## Acceptance Criteria

- [x] Required GitKB context docs exist under context/ and are sourced from upstream docs only.
- [x] GitKB context can be loaded and shown without errors.
- [x] Root repo remains clean and aligned with gitkb/meta origin/main before build changes.
- [x] Child repos are checked independently, not as monorepo paths.
- [x] Build/test command order follows .meta.yaml dependency declarations.
- [x] Any failure is recorded here with command, repo, and next step.
- [x] No .codex or unrelated overlay structure is added to the root mirror.

## Source References

- AGENTS.md: meta-repo rule and .kb/AGENTS.md requirement.
- CLAUDE.md: independent child repo rules and logging guidance.
- .kb/AGENTS.md: GitKB context and task discipline.
- .meta.yaml: project inventory and dependency declarations.
- .context/: legacy/static project context and task notes.
- docs/: architecture, agent workflows, MCP, plugin, loop, FAQ, and contribution docs.

## Progress Log

### 2026-07-02

- Loaded GitKB state: KB clean at head 019f213a-6580-77d1-8902-8a20d6677ac1 before this update.
- Loaded active task `tasks/meta-clean-foundation-build-order`; board has one active task and no draft/blocked/completed tasks.
- Checked required GitKB context path with `/home/flexnetos/FlexNetOS/usr/bin/git-kb list --path context/ --json`; result is still empty (`[]`), so PATH A context bootstrap remains incomplete.
- Re-walked root source guard files: AGENTS.md, CLAUDE.md, and .meta.yaml.
- Re-walked tracked requested source areas: .kb/AGENTS.md, .kb/config.toml, .kb/.gitignore, .context/, docs/, and docs/assets/README.md.
- Confirmed `.kb/AGNENT.md` does not exist; upstream instruction file is `.kb/AGENTS.md`.
- Confirmed `.codex` does not exist in the upstream root mirror.
- Confirmed root git status remains `main...origin/main` clean.
- Confirmed `meta exec -- git status --short` reports root and all 14 child repos clean; child repos are independent repos, mostly on `codex/clean-room-foundation-base-20260628`.

## Completion Evidence

### GitKB foundation

- Created the seven required context docs from upstream source material only:
  - `context/immutable/project-brief`
  - `context/immutable/patterns`
  - `context/immutable/architecture`
  - `context/extensible/product`
  - `context/extensible/tech`
  - `context/overridable/active`
  - `context/overridable/progress`
- Committed the context bootstrap as KB commit `019f2143-86a6-7e71-8cdd-3cc3d5cd2a9d` (`Initial meta context setup`).
- Validated all seven docs with `git-kb show <slug> --json`.

### Follow-up tasks loaded

- `tasks/meta-rust-release-packaging`
- `tasks/meta-command-surface-docs-reconciliation`
- `tasks/meta-org-migration-cleanup`
- `tasks/meta-verification-parity`
- `tasks/meta-lockfile-version-drift`

Follow-up tasks were committed in KB commits:
- `019f2144-4798-7bd2-9c5d-a24cf5bfb443` (`Load meta follow-up foundation tasks`)
- `019f2147-21c2-7481-8d74-f3563899f41a` (`Record meta lockfile verification drift`)

### Root and child repo state

- `rtk git status --short --branch` reported `## main...origin/main` with no changes.
- `rtk git remote -v` reported `origin https://github.com/gitkb/meta.git` for fetch and push.
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb status --json` was clean before final task completion update.
- `/home/flexnetos/FlexNetOS/usr/bin/meta exec -- git status --short --branch` reported root and all 14 child repos clean as independent repositories.

### Build and test results

- Plain `cargo` was not on PATH in this shell; verification used an ephemeral Nix stable Rust toolchain:
  - `nix shell nixpkgs#cargo nixpkgs#rustc -c cargo metadata --no-deps --format-version 1`
  - `nix shell nixpkgs#cargo nixpkgs#rustc -c cargo build --workspace`
  - `nix shell nixpkgs#cargo nixpkgs#rustc -c cargo test --workspace`
  - `bats tests/*.bats`
- `cargo metadata` succeeded and confirmed the workspace package set.
- `cargo build --workspace` succeeded, compiling the packages in dependency order resolved from the `.meta.yaml` workspace shape.
- `cargo test --workspace` succeeded.
- `bats tests/*.bats` passed all 323 tests.

### Recorded failure and next task

`cargo build --workspace --locked` failed because tracked `Cargo.lock` would need to change. Unlocked build/test both succeeded but rewrote `Cargo.lock` from stale `0.2.20` workspace package entries to current `0.2.22` entries and added newer resolved packages. The generated lockfile change was restored to keep the root source mirror clean.

Next task: `tasks/meta-lockfile-version-drift`.

## Remaining Repo Scan Gaps

These were found by scanning the rest of the tracked root mirror files after the initial `.kb`, `.context`, and `docs` walk. They must be handled through GitKB before source changes.

### Packaging and release artifacts omit `meta-rust`

Evidence:
- `README.md`, `docs/architecture_overview.md`, `.context/CONTEXT.md`, and `.meta.yaml` describe `meta_rust_cli` / `meta-rust` as a built-in Rust/Cargo plugin.
- `Makefile` builds, installs, and uninstalls `meta-rust`.
- `meta plugin list` in the current workspace shows `rust 0.2.22` installed at `/home/flexnetos/FlexNetOS/usr/bin/meta-rust`.
- `install.sh`, `install.ps1`, `distribution/homebrew/meta-cli.rb`, and `.github/workflows/release.yml` package/install `meta`, `meta-git`, `meta-project`, `meta-mcp`, and `loop`, but not `meta-rust`.
- `.github/workflows/release.yml` clones `meta_rust_cli` but does not build/package/publish it.

Task to load:
- Add a dedicated task to reconcile `meta-rust` release packaging, installers, Homebrew formula, and publish workflow, with tests or CI evidence.

### Docs and skills reference stale or invalid commands

Evidence:
- `.claude/settings.json` and `.claude/skills/gitkb/SKILL.md` reference `git kb service status/start/stop`.
- Installed GitKB rejects `service`; the available management surface is `daemon`.
- `.claude/agents/meta-worker.md` says `meta project list --jsons`; current command is `--json`.
- `.claude/skills/meta-exec.md`, `.claude/skills/meta-safety.md`, and matching `claude-plugin/skills/*` files reference `meta --ordered exec`.
- Current installed `meta` rejects `--ordered`.
- `README.md` shows `meta exec npm install`, `meta exec cargo test`, and related examples, while `meta exec --help`, architecture docs, and plugin docs use `meta exec -- <command>`.
- README, FAQ, and Claude skills still describe `meta git setup-ssh` as SSH multiplexing setup, but current help treats `setup-ssh` as a generic pass-through `git setup-ssh` command.

Task to load:
- Add a dedicated docs/skills command-surface reconciliation task covering README, docs, `.claude`, and `claude-plugin` examples against the actual `meta` and `git-kb` command surfaces.

### Org migration residue remains in tracked source

Evidence:
- `.context/CONTEXT.md` and `.context/tasks/cicd-distribution-gaps.md` still reference `harmony-labs` install, Homebrew, release, and tap URLs.
- `Makefile` test clone targets still use `git@github.com:mateodelnorte/meta.git`.
- `claude-plugin/.claude-plugin/plugin.json` uses author name `Harmony Labs` and URL `https://github.com/harmony-labs`, while homepage/repository point at `gitkb/meta`.
- Current root remote and most docs point to `gitkb/meta`.

Task to load:
- Add a dedicated org migration cleanup task to replace or intentionally document legacy `harmony-labs` and `mateodelnorte` references.

### CI and local checks are not symmetric

Evidence:
- CI uses `cargo test --workspace`, `cargo clippy --workspace --all-targets -- -D warnings`, Bats tests, and child repo cloning.
- `.githooks/pre-push` runs `cargo fmt`, `cargo clippy --all-targets --all-features -- -D warnings`, and `cargo test --workspace`, but does not run Bats integration tests.
- `Makefile test` uses `cargo nextest run --workspace`; CI uses `cargo test --workspace`.
- Bats tests cover exec/git/context/help/init/plugin/project/worktree surfaces extensively, but there is no obvious release packaging test asserting expected binaries include `meta-rust`.

Task to load:
- Add a dedicated verification parity task to decide the canonical local/CI verification matrix and add a release artifact/package content check for built-in plugins.
