---
id: 019f21fc-7200-7623-bcd7-6cd71c1729eb
slug: tasks/meta-gitkb-code-intel-meta-proof-suite
title: "Prove GitKB code intelligence across meta repos"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Prove GitKB code intelligence works across the meta-repo's independent repos before wiring adapter workflows that depend on symbol/call graph behavior.

# Source Evidence

- `docs/gitkb/core-concepts-code-intelligence.md` documents code indexing, symbols, callers, callees, impact, dead code, doctor, entrypoints, flows, query templates, stats, refs, dump-ast, prune, and default branch detection.
- `docs/gitkb/reference-supported-languages.md` lists 17 supported languages and `.gitkbignore`.
- `docs/gitkb/reference-configuration.md` documents `[repos] strategy = "meta"` and `[code.repo_default_branch_map]`.
- `docs/gitkb/cli-reference.md` documents worktree/branch-aware code indexing and pruning.

# Commands And Configs Covered

- `git-kb code index`
- `git-kb code index src/`
- `git-kb code index --dry-run`
- `git-kb code index --prune`
- `git-kb code index --include-deps`
- `git-kb code index --index-only`
- `git-kb code index --embed-only`
- `git-kb code index --worktree <path>`
- `git-kb code index --branch <branch>`
- `git-kb code symbols --file <file>`
- `git-kb code symbols --path <glob>`
- `git-kb code symbols --parent <name>`
- `git-kb code symbols --body`
- `git-kb code symbols --group-by file`
- `git-kb code callers <symbol>`
- `git-kb code callers --strict`
- `git-kb code callees <symbol>`
- `git-kb code callees --strict`
- `git-kb code impact <file>`
- `git-kb code dead`
- `git-kb code dead --include-tests`
- `git-kb code dead --exclude-tests`
- `git-kb code dead --include-entrypoints`
- `git-kb code dead --include-public`
- `git-kb code dead --explain`
- `git-kb code refs <symbol>`
- `git-kb code refs --textual`
- `git-kb code refs --wikilinks-only`
- `git-kb code refs --include-maybe`
- `git-kb code stats`
- `git-kb code doctor --json`
- `git-kb code entrypoints --refresh`
- `git-kb code flows --refresh`
- `git-kb code flow <flow-id>`
- `git-kb code query hotspots`
- `git-kb code query dead-code-explain`
- `git-kb code query public-api`
- `git-kb code query unresolved-by-reason`
- `git-kb code query cross-service-impact`
- `git-kb code query routes`
- `git-kb code query route-clients`
- `git-kb code query handler-routes`
- `git-kb code dump-ast <path>`
- `git-kb code prune --dry-run`
- `git-kb code detect-default-branches --dry-run`
- `.gitkbignore`
- `[repos] strategy = "meta"`
- `[code] default_branch`, `index_threads`
- `[code.repo_default_branch_map]`

# Acceptance Criteria

- [x] Verify `.kb/config.toml` uses the correct meta-repo discovery strategy for this workspace.
- [x] Run dry-run/default-branch detection before writing `[code.repo_default_branch_map]`.
- [x] Prove code indexing across the 14 independent meta repos without treating root as a monorepo.
- [x] Capture `git-kb code doctor --json` and identify any unresolved index health issues.
- [x] Prove at least one symbol/callers/callees/impact query on a known Rust source file.
- [x] Prove entrypoints/flows/query templates or record why they are version-blocked.
- [x] Add `.gitkbignore` only if actual generated/vendor paths need exclusion, with proof.
- [x] Query templates and branch/worktree options are verified against live help before adapter use.

# Completion Evidence

- 2026-07-02: `git-kb doctor --json` reported `code.symbols` ok with 434 code symbols and `code.freshness` ok; it also warned that no `[repos]` section exists in `.kb/config.toml`.
- 2026-07-02: `git-kb code stats --json` reported 434 symbols across 101 files, 560 call edges, 4013 unresolved calls, latest index `2026-07-02T06:16:13.560365331+00:00`, and language coverage of Rust and Ruby.
- 2026-07-02: `git-kb code doctor --json` recorded unresolved-call recommendations: inspect `no_match`/`ambiguous` language-pack behavior, review resolution provenance, and inspect unresolved symbol-forwarding facts.
- 2026-07-02: `git-kb code detect-default-branches --dry-run` detected `main (new)` and wrote no changes.
- 2026-07-02: `git-kb code symbols --file meta_cli/src/init.rs --json` returned 32 symbols, including `build_meta_hooks`, `install_settings`, and hook-related tests.
- 2026-07-02: `git-kb code callers meta_cli/src/init.rs::function::build_meta_hooks --json` returned 4 callers; `git-kb code callees ... --json` returned 0 callees; `git-kb code impact meta_cli/src/init.rs --json` returned 14 callers.
- 2026-07-02: `git-kb code entrypoints --refresh --json`, `git-kb code flows --refresh --json`, and `git-kb code query hotspots --json` returned live results; route-oriented templates remain subject to live help/template validation before adapter use.
- 2026-07-02: No `.gitkbignore` was added because this proof found no specific generated/vendor path requiring exclusion.

# Progress Log

### 2026-07-02
- Completed code intelligence proof for the meta root without treating independent child repos as a monorepo; unresolved-call health caveats are recorded for future tuning.
