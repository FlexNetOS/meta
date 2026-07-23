---
id: 019f236b-24d8-7491-8903-d8bbedd28795
slug: tasks/meta-gitkb-cli-reference-0212-refresh
title: "Refresh GitKB CLI reference for installed 0.2.12"
type: task
status: completed
priority: high
tags: [gitkb, docs, cli, parity]
---

# Summary

Refresh or regenerate the GitKB CLI reference so the source docs are anchored to the installed local binary, `git-kb 0.2.12`, instead of keeping a generated `0.2.6` body with partial live overlays.

# Source Evidence

- During [[tasks/meta-foundation-live-proof-gitkb-parity]], `git-kb --version` returned `git-kb 0.2.12`.
- `docs/gitkb/cli-reference.md` still says the page is generated from `git-kb 0.2.6`.
- A full bare help sweep passed for the required command set plus the live extra command families `sync`, `slug`, and `app`.
- Live mismatch probes showed:
  - `git-kb pull origin --all` fails with `unexpected argument '--all'`.
  - `git-kb set tasks/meta-foundation-live-proof-gitkb-parity --status active --dry-run` fails because `set` uses `FIELD=VALUE` arguments.
  - `git-kb graph ... --direction inbound` and `--direction outbound` fail; valid values are `out`, `in`, and `both`.
  - `git-kb conflict list` and `git-kb conflict resolve ...` fail; installed commands are `show` and `accept`.
  - `git-kb board --all --json` currently succeeds even though `git-kb board --help` does not list `--all`, so the docs need a current 0.2.12 option-level refresh rather than carrying stale assumptions.

# Acceptance Criteria

- [x] Regenerate or manually refresh `docs/gitkb/cli-reference.md` from `git-kb 0.2.12`.
- [x] Include live command families absent from the old generated text: `sync`, `slug`, and `app`.
- [x] Reconcile all stale examples for `pull --all`, `set --status`, graph direction names, and conflict subcommands.
- [x] Re-check `board --all` behavior and document whether it is hidden compatibility, a parser quirk, or intended behavior.
- [x] Re-run the help sweep and commit evidence.

# Completion Evidence

- Source commit `9bf4df9` updates `docs/gitkb/cli-reference.md` so the live `git-kb 0.2.12` section is authoritative and the generated `0.2.6` body is explicitly historical.
- `git-kb --version` returned `git-kb 0.2.12`.
- The help sweep covered 94 help pages and returned `help_sweep_status=pass`.
- Live family checks passed:
  - `git-kb sync --help` exposes `sync status`.
  - `git-kb slug --help` exposes `slug next`.
  - `git-kb app --help` exposes `app list`.
- Stale example probes were verified:
  - `git-kb graph ... --direction inbound` and `--direction outbound` exit 2; valid values are `in`, `out`, and `both`.
  - `git-kb conflict list` and `git-kb conflict resolve ...` exit 2; live subcommands are `show` and `accept`.
  - `git-kb pull --help` lists `--type` and `--status`, not `--all`.
  - `git-kb set --help` shows positional `FIELD=VALUE`, not `--status`.
  - `git-kb board --help` lists `--where`, not `--all`; `git-kb board --all --json` exits 0, so the docs now label `--all` hidden compatibility and avoid relying on it for new automation.
- Validation:
  - `git diff --check -- docs/gitkb/cli-reference.md` passed.
  - `rg` found no remaining top-of-page claims that the live reference is generated from `git-kb 0.2.6`.
  - `git-kb code doctor --json` reported repo discovery `status: ok`, `repo_count: 15`, `symbol_count: 1427`; it also reported unresolved-call recommendations, so graph health is useful but not perfect.

# Related

- [[tasks/meta-foundation-live-proof-gitkb-parity]]
- [[tasks/meta-gitkb-cli-live-parity-suite]]
- [[tasks/meta-gitkb-cli-option-level-parity]]
