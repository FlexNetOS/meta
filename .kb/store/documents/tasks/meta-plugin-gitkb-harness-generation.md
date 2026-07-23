---
id: 019f21fc-56fa-79b0-b1b6-fd40bfe32132
slug: tasks/meta-plugin-gitkb-harness-generation
title: "Generate GitKB harness adapters from meta-plugin"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Design and implement `meta-plugin` generation for GitKB harness adapters so Claude, Codex, Cursor, Windsurf, and generic MCP clients share one policy and one workflow source.

# Source Evidence

- `docs/gitkb/reference-agent-harnesses.md` lists five harness paths: Claude Code, Codex, Cursor, Windsurf, and generic MCP clients.
- `docs/gitkb/getting-started-codex.md` documents repo-local `.codex/skills/` and `.codex/instructions/`.
- `docs/gitkb/getting-started-claude-code.md` documents `.claude/rules/`, `.claude/skills/`, `.claude/settings.json`, and `CLAUDE.md`.
- `docs/gitkb/reference-agent-harnesses.md` says assistant-specific directories are lightweight adapters around `.kb/skills/`.

# Commands And Configs Covered

- `git-kb init claude`
- `git-kb init codex`
- `git-kb init codex --install-home`
- `git-kb init cursor`
- `git-kb init windsurf`
- `git-kb init <harness> --dry-run`
- `git-kb init --remote <url>`
- `--cloud-remote`, `--org`, `--instance`, `--name`, `--no-verify`
- `.kb/skills/`
- `.claude/rules/`, `.claude/skills/`, `.claude/settings.json`, `CLAUDE.md`
- `.codex/skills/`, `.codex/instructions/`, `$CODEX_HOME`
- `.cursor/rules/`, `.cursor/skills/`, `.cursor/mcp.json`
- `.windsurf/rules/`, `.windsurf/skills/`
- `.hermes/skills/`, `.hermes/rules/`
- `.claude/skills/atc`, `.codex/skills/atc`

# Acceptance Criteria

- [x] Define a `meta-plugin` manifest/schema that describes GitKB harness assets once.
- [x] Generator emits or validates Claude adapter assets without hand-maintained drift.
- [x] Generator emits or validates Codex adapter assets without hand-maintained drift.
- [x] Cursor and Windsurf paths are represented as future adapter targets or explicitly out of scope.
- [x] The CLI reference's `.hermes/` text for the Windsurf initializer is verified live and either supported or logged as docs drift.
- [x] Generic MCP clients are represented as MCP config only, with workflow instructions supplied separately.
- [x] Generated adapters preserve `.kb/skills/` as the canonical GitKB workflow source.
- [x] Adapter generation depends on [[tasks/meta-gitkb-skill-inventory-adapter-parity]] for canonical skill inventory proof.
- [x] The generator has a dry-run mode that lists file additions/removals before writing.
- [x] The generator refuses to overwrite dirty adapter files unless an explicit backup/proof path is supplied.

# Progress Evidence

- 2026-07-02: `codex-plugins/README.md` and `claude-plugins/README.md` already describe assistant-specific publication surfaces with a long-term meta-owned integration control plane as source of truth.
- 2026-07-02: `codex-plugins/plugins/gitkb/README.md` says `git-kb init codex` remains the canonical repo-local GitKB Codex asset source, and that lifecycle hooks/MCP ownership stay with active Codex config or meta control-plane wrapper.
- 2026-07-02: Canonical skill inventory proof passed in [[tasks/meta-gitkb-skill-inventory-adapter-parity]].
- 2026-07-02 rerun: `git-kb init claude --dry-run` would create 14 missing `.claude/skills/*` symlinks and skip existing rules/settings/CLAUDE assets.
- 2026-07-02 rerun: `git-kb init codex --dry-run --install-home` would create `$CODEX_HOME/skills/meta-9f262555` and `$CODEX_HOME/instructions/meta-9f262555`, with 53 repo-local assets skipped as already present.
- 2026-07-02 rerun: `git-kb init cursor --dry-run` would create `.kb/rules/*`, `.cursor/skills/*`, and `.cursor/rules/*` adapter paths.
- 2026-07-02 rerun: `git-kb init windsurf --dry-run` would create `.kb/rules/*`, `.windsurf/skills/*`, and `.windsurf/rules/*`; it did not report `.hermes/*` writes, so the CLI help text mentioning Hermes is live docs/help drift.
- 2026-07-02: Implemented `meta plugin harness` in `meta_cli` commit `442c762` and documented the manifest/backup policy in root commit `e4b1440`.
- `meta plugin harness` uses one schema (`gitkb-harness-adapters`, `schema_version: 1`, canonical root `.kb/skills`) for Claude and Codex skill adapter symlinks.
- Dry-run proof: `meta plugin harness --harness all` exits 0 and lists `dirty`, `create`, and `valid` actions plus `removals: none`.
- Codex proof: `meta plugin harness --harness codex --json` exits 0 and reports all 17 Codex GitKB skill adapters as `valid` symlinks to `../../.kb/skills/<skill>`.
- Claude proof: dry-run reports 3 dirty direct skill directories (`.claude/skills/gitkb`, `.claude/skills/explore`, `.claude/skills/understand`) and 14 missing GitKB skill adapter symlinks; no Claude files were overwritten.
- Overwrite safety proof: `meta plugin harness --harness all --write` exits 1 with `refusing to overwrite dirty adapter file(s) without --backup-dir: .claude/skills/gitkb, .claude/skills/explore, .claude/skills/understand`.
- Test proof: `cargo test -p meta harness_generation --locked -- --test-threads=1` passed 3 focused tests covering dry-run planning, symlink creation, and dirty adapter refusal.
- Code-intelligence proof: `git-kb code index meta_cli/src/main.rs meta_cli/src/harness_generation.rs --force --index-only` indexed 83 symbols from the 2 changed files; `git-kb code symbols --file meta_cli/src/harness_generation.rs --json` reported the new manifest, plan, apply, and test symbols.
- Diff proof: `git -C meta_cli diff --check -- src/main.rs src/harness_generation.rs` and `git diff --check -- docs/agent_plugin_control_plane.md` both passed.

# Progress Log

### 2026-07-02
- Added the manifest-backed `meta plugin harness` generator/validator with dry-run, JSON output, additive removals reporting, and backup-gated dirty overwrite behavior.
- Documented the GitKB harness adapter manifest and safe write policy in `docs/agent_plugin_control_plane.md`.
- Earlier rerun of harness initializer dry-runs recorded `.hermes`/Windsurf drift before the generator existed.
- Earlier control-plane policy evidence showed why this task needed a real generator/validator instead of more hand-maintained notes.
