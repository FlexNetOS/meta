---
id: 019f20b4-a4c7-7fd1-b437-3b84fde67149
slug: tasks/audit-meta-bootstrap-setup-gaps
title: "Audit Meta bootstrap setup gaps"
type: task
status: active
priority: high
parent: tasks/gitkb-local-agent-platform
tags: [bootstrap, hooks, agent, codex, claude, gitkb, meta]
---

# Overview

Audit the Meta workspace for setup/bootstrap gaps after discovering that the root Claude `PreToolUse` hook points at `./target/debug/agent guard`, while the `agent` crate is a separate child repository excluded from the root Cargo workspace.

# Questions

- Is the `agent guard` hook stale, unbuilt, or incorrectly initialized?
- Which configured hook commands are missing from the current environment?
- Which Meta/GitKB/Codex/Claude bootstrap surfaces disagree about command paths?
- What other init steps have not been applied yet?

# Acceptance Criteria

- Identify all configured hook command binaries and whether they resolve.
- Compare root `.claude/settings.json` with generated `meta_cli/src/init.rs` expectations.
- Check GitKB init/Codex/Claude surfaces for stale command forms.
- Check Meta release/frontdoor binaries expected by docs and context.
- Record actionable setup gaps with recommended fixes.

# Audit Findings

## 2026-07-02

### Confirmed setup gaps

1. **Root Claude guard hook points at a non-existent root build artifact.**
   - Configured command: `./target/debug/agent guard` in root `.claude/settings.json`.
   - Missing path: `/home/flexnetos/FlexNetOS/src/meta/target/debug/agent`.
   - Cause: `agent` is a separate Meta child repo and root `Cargo.toml` has `exclude = ["agent"]`, so root workspace builds do not produce `./target/debug/agent`.
   - Current generator in `meta_cli/src/init.rs` emits `agent guard`, not `./target/debug/agent guard`.
   - Recommended fix: install/build the standalone `agent` frontdoor and set hook command to `agent guard`, or use an explicit child path if intentionally local.

2. **Standalone `agent` command is not installed on ambient PATH or in `/home/flexnetos/FlexNetOS/usr/bin`.**
   - `agent --help` fails with `command not found`.
   - `/home/flexnetos/FlexNetOS/usr/bin/agent` is missing.
   - `agent/README.md` documents `agent guard` as the intended hook command.

3. **Root Claude GitKB service hook uses stale `git kb service` syntax.**
   - Root `.claude/settings.json` contains `git kb service status --quiet ... || git kb service start ...`.
   - Current installed GitKB rejects `service`: `error: unrecognized subcommand 'service'`.
   - Current working form is `git-kb daemon status/start`.
   - Recommended fix: remove the stale `git kb service` hook or replace it with the already-present `git-kb daemon ...` hook.

4. **Many root Claude/GitKB guidance files still contain stale `git kb` and `checkout --path` forms.**
   - Examples: `.claude/skills/gitkb/SKILL.md`, `.claude/commands/kb-context.md`, `.claude/rules/code-intelligence.md`, and older sections of `.kb/AGENTS.md`.
   - Current installed CLI for this workspace is `git-kb 0.2.12` and accepts `git-kb checkout context/`, not the stale `git kb ...` / `checkout --path` examples.
   - Recommended fix: run a focused surface-sync pass over `.claude`, `.kb`, and `meta_cli/.claude` GitKB docs.

5. **Workspace frontdoor binaries are not on ambient PATH in this Codex shell.**
   - Missing from ambient PATH: `meta`, `git-kb`, `meta-git`, `meta-project`, `meta-mcp`, `meta-rust`, `loop`, `agent`.
   - Present under `/home/flexnetos/FlexNetOS/usr/bin`: `meta`, `git-kb`, `meta-git`, `meta-project`, `meta-mcp`, `loop`.
   - This is why `git-kb doctor` initially warned that repo discovery found no repos; rerunning with `PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH` passed repo discovery.
   - Recommended fix: ensure Codex/Claude hook environments prepend `/home/flexnetos/FlexNetOS/usr/bin` or use absolute paths in hooks.

6. **`meta-rust` release/frontdoor remains missing.**
   - `/home/flexnetos/FlexNetOS/usr/bin/meta-rust` is missing.
   - `/home/flexnetos/FlexNetOS/usr/bin/meta rust --help` reports `unrecognized command 'rust'`.
   - This matches existing context gaps for `tasks/flexnetos-meta-release-repackage` and `incidents/meta-rust-release-install-surface-gap`.

7. **`rusty-idd` hook dependency appears absent.**
   - `meta_cli/.claude/settings.json` runs `sh -lc 'root="$(git rev-parse --show-toplevel)"; exec rusty-idd next --base "$root"'`.
   - `rusty-idd` did not resolve in the audited PATH with the workspace frontdoor prepended.
   - Recommended fix: install `rusty-idd`, guard the hook with `command -v rusty-idd`, or remove it from default initialization until the dependency is managed.

### Healthy or expected surfaces

- With `/home/flexnetos/FlexNetOS/usr/bin` prepended, `git-kb doctor --json` reports all checks OK including 16 repos discovered.
- `codex doctor` reports `17 ok · 1 idle · 1 notes · 0 warn · 0 fail`.
- Hook JSON/TOML parsing passed for `.claude/settings.json`, `claude-plugin/hooks/hooks.json`, `codex-plugins/plugins/gitkb/hooks/hooks.json`, `.kb/config.toml`, and `.claude/agent-guard.toml`.
- Handoff hook scripts under child repos exist and are executable.

# Recommended repair order

1. Fix root `.claude/settings.json`: replace `./target/debug/agent guard` with `agent guard` only after installing/building `agent`, and remove stale `git kb service` hook.
2. Install or package `/home/flexnetos/FlexNetOS/usr/bin/agent` and `/home/flexnetos/FlexNetOS/usr/bin/meta-rust`.
3. Add `/home/flexnetos/FlexNetOS/usr/bin` to agent/hook PATH policy or convert hooks to explicit absolute paths.
4. Sync stale GitKB guidance from `git kb ...` to current `git-kb ...` forms across `.claude`, `.kb`, and `meta_cli/.claude`.
5. Decide whether `rusty-idd` is required; install it or guard/remove that hook.

# Repair Execution

## 2026-07-02 Makefile-first repair pass

1. **Makefile build first (requested starting point) — done.**
   - Initial `make build-all` failed because ambient PATH did not include Cargo.
   - Reran with `/nix/store/gps52hnp4dmfddkv9970q20lmycr2mb0-rust-mixed/bin` and `/home/flexnetos/FlexNetOS/usr/bin` prepended; `make build-all` passed.
   - Final cached rerun after repairs passed and refreshed `.meta/plugins/meta-git`, `.meta/plugins/meta-project`, and `.meta/plugins/meta-rust`.

2. **Repair item 1: root hook target — done.**
   - Replaced root `.claude/settings.json` `./target/debug/agent guard` with `/home/flexnetos/FlexNetOS/usr/bin/agent guard`.
   - Removed the stale root `git kb service ...` hook surface and kept the current `git-kb daemon ...` command form.

3. **Repair item 2: install missing frontdoors — done.**
   - Built standalone `agent` from `agent/Cargo.toml` and installed `/home/flexnetos/FlexNetOS/usr/bin/agent`.
   - Built `meta_rust_cli` through the Makefile and installed `/home/flexnetos/FlexNetOS/usr/bin/meta-rust`.
   - Verified `agent --help`, `meta rust --help`, and `.meta/plugins/meta-rust`.

4. **Repair item 3: hook PATH policy — done.**
   - Converted GitKB daemon hooks across discovered `.claude/settings.json` files to absolute `/home/flexnetos/FlexNetOS/usr/bin/git-kb`.
   - Converted root `meta context` hooks to `/home/flexnetos/FlexNetOS/usr/bin/meta`.
   - Hook audit now resolves all absolute frontdoors and handoff scripts without relying on ambient PATH.

5. **Repair item 4: GitKB command surface sync — done.**
   - Updated root `.claude`, `.kb`, and `meta_cli/.claude` guidance from stale `git kb ...` examples to current `git-kb ...` forms.
   - Replaced stale `checkout --path` examples with `git-kb checkout context/` / `kb_checkout context/` where applicable.
   - Repaired an accidental direct edit to `.kb/store` by restoring the canonical task body and commit content from SQLite, restoring the document tip, and validating with `git-kb verify --full --json`.

6. **Repair item 5: optional `rusty-idd` hook — done.**
   - Guarded the `meta_cli/.claude/settings.json` `rusty-idd` hook with `command -v rusty-idd` so missing optional tooling no longer breaks session startup.

7. **Repair item 6: hook audit and validation — done.**
   - JSON parsing passed for every discovered `.claude/settings.json`.
   - Hook audit checked every hook command in root and child `.claude/settings.json`: absolute frontdoors exist, handoff scripts are executable, and `rusty-idd` is guarded.
   - `git-kb verify --full --json` returned `ok: true` after the KB store repair.
   - `PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb doctor --json` reports repo discovery OK with 16 repos.
