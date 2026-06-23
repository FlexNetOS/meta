# META-ORG-POLICY.md — POLICY v2 (FlexNetOS meta workspace)

**Status:** active · synthesized 2026-06-12 · supersedes implicit canon-v1 conventions
**Method:** code-verified against the 10 canon repos + parent meta repo + live `gh api` state on 2026-06-12. No prose trusted without a file/symbol/API check. See Research/Cross-References at the bottom.
**Scope:** every member of `.meta.yaml` (64 projects), tiered. The parent repo `FlexNetOS/meta` is the **policy exemplar** — the rusty-idd alignment items are already landed there and are propagated outward by this policy.

---

## Tier model

| Tier | Definition | Policy subset |
|------|------------|---------------|
| **A** | The 10 canon repos: `loop_lib`, `loop_cli`, `meta_cli`, `meta_core`, `meta_plugin_protocol`, `meta_plugin_api` (legacy stub), `meta_git_lib`, `meta_git_cli`, `meta_project_cli`, `meta_rust_cli` (+ parent `meta` as exemplar; `meta_mcp`, `meta_dashboard_cli`, `meta-plugins` are post-canon A-track) | Full policy P1–P6 |
| **B** | FlexNetOS-owned tools: weave, envctl, prompt_hub, handoff, lane, icm, rtk-tokenkill, atc, agent, obscura, dashboards, mcp/meta plugins, hubs-with-code | Full policy P1–P6 (version strategy = standalone) |
| **C** | Forked upstream: ruvector, ruflo, claude-code, codex, n8n, Archon, ECC, oh-my-claudecode, oh-my-pi, shimmy, teri, grit, hermes-agent, weave-* forks | P1 only + pin/drift notes. **Do NOT force FlexNetOS CI onto forks.** |
| **D** | Hubs/docs/assets: template_hub, *_hub, my-wiki, flexnetos_* (docs/ops), assets, commands | P1 + docs-accuracy (P5.22) |

---

## P1 — Identity & registration (ALL tiers)

1. **Genuine FlexNetOS org repo.** `gh api repos/FlexNetOS/<name>` must show `owner.login == "FlexNetOS"` directly — never a personal-account redirect. Forks are genuine org forks (`fork: true`, correct `parent`). (Lesson: FlexNetOS/ruvector redirect incident; `gh repo fork` can silently auto-suffix → re-query the org after forking.)
2. **`.meta.yaml` registration** with: `repo:` (SSH URL `git@github.com:FlexNetOS/<name>.git`), `path:` when dir ≠ name, `provides:`/`depends_on:` for workspace members, `tags:` (incl. `forked` for Tier C). Nested meta repos declare `meta: true`.
3. **Parent `.gitignore` entry** — child checkouts are never gitlinks/embedded (cf. commit 714abca).
4. **Visibility: public.** Visibility/protection/org-setting changes are HIGH-BLAST-RADIUS: only on explicit request, after downstream-breakage research (cautionary tale: 2026-06 private-flip broke CI for 8 days).
5. **Remotes:** `origin` = FlexNetOS; Tier C keeps the third-party source as `upstream`. Drift from upstream is intentional and pinned — record per-repo in `.meta.yaml` tags or memoir, do not silently pull upstream.

## P2 — Rust & workspace conventions (A/B Rust repos)

6. **Version strategy is declared, one of:**
   - *workspace-inherited* (all Tier A members): `version.workspace = true`; the **parent** `VERSION` + release-please manifest is the single version of the meta distribution (0.2.22 today). Member repos carry **no** VERSION file and **no** release-please — this is intentional, not a gap.
   - *standalone* (Tier B): own semver in Cargo.toml (weave 0.2.0, envctl 0.1.0…); repos that cut releases adopt the parent's release-please pattern (P4.16).
7. **RUST_LOG target = crate name** (`meta`, `meta_git_cli`, `loop_lib`, …). Subprocess plugins inherit logger init from `meta_plugin_protocol::run_plugin()`.
8. **Toolchain:** parent pins `rust-toolchain.toml` (`channel = "stable"`); members building standalone in CI use `dtolnay/rust-toolchain@stable`. A/B repos opened standalone carry their own `rust-toolchain.toml`.

## P3 — Plugin protocol (A/B repos exposing `meta` commands)

9. Binary named `meta-*`; implemented via `meta_plugin_protocol::run_plugin(PluginDefinition)`; `PluginRequest → ExecutionPlan` JSON IPC. (Verified: meta-git, meta-project, meta-rust, meta-dashboard.)
10. Flag surface: `--json`, `--dry-run`, `--parallel`, `--include`, `--exclude`.
11. Discoverable via the 3-layer search: `.meta/plugins` → `~/.meta/plugins` → `PATH`.
12. `meta_plugin_api` is a **legacy stub** (109-line trait API, no workflows) — superseded by the subprocess protocol. New code MUST NOT depend on it. Disposition decision (archive vs tombstone README) tracked in the audit.

## P4 — CI/CD workflow set (A/B; C/D exempt)

13. **ci.yml** — push/PR on default branch: `Test` 3-OS matrix (ubuntu/macos/windows, `fail-fast: false`, `cargo test --all-features`), `Clippy` (`-D warnings`), `Format` (`cargo fmt --all -- --check`). Workspace-member repos synthesize a wrapper `[workspace]` Cargo.toml in CI (the standalone-build trick). Consumer repos additionally: `repository_dispatch: types: [dependency-updated]` + a Clone-dependencies step for path-deps.
14. **auto-format.yml** — push/PR: `cargo fmt` auto-commit (`style: auto-format code`), fork-PR + bot-actor guards, token = `PARENT_REPO_PAT || github.token`.
15. **notify-downstream.yml** (libs with consumers) — wait-on-check `Test (ubuntu-latest)` → `peter-evans/repository-dispatch` `dependency-updated` to each consumer (matrix mirrors `.meta.yaml` dependents). **notify-parent.yml** (leaf CLIs/tools) — dispatch `child-repo-updated` → `FlexNetOS/meta`. Action SHAs pinned.
16. **Release (parent only for Tier A):** `on-push-main.yml` = quality gate → release-please v4 (manifest mode, `release-type: simple`, `version-file: VERSION`, toml extra-file → `workspace.package.version`) → dispatch `release-tagged` → `release.yml` multi-target binary matrix. Standalone Tier B repos that release replicate this pattern in-repo.
17. **semantic-pr-title.yml** on every A/B repo (currently parent-only — propagation is a v2 addition). Types: build chore ci deps docs feat fix perf refactor revert style test. This is the merge-subject guard; local `.githooks/commit-msg` is advisory.
18. **Renovate, not Dependabot:** `renovate.json` `config:recommended`. (Gap: loop_lib, loop_cli, meta_core, meta_plugin_protocol, meta_git_lib lack it; no canon repo has Dependabot — good.)
19. **Secrets are org-level only:** `PARENT_REPO_PAT` (repo-scope dispatch + checkout), `REPO_WRITE_PACKAGES_PAT` (parent release dispatch). Never repo-level copies; never bake PATs into clones.

## P5 — Repo hygiene (A/B; P5.22 also D)

20. **`.githooks/` not pre-commit-framework:** commit-msg (commitlint via `npx @commitlint/cli` with graceful offline fallback — CI semantic-pr-title remains the blocking guard), pre-commit, pre-push; wired via `core.hooksPath` (parent `Makefile install-hooks`).
21. **Makefile, not Justfile.**
22. **Docs accuracy (docs-are-traps rule):** README/CLAUDE.md must match code; when prose ≠ code, code wins and the contradiction is flagged to the `system-architecture` memoir. Tier C fork prose is untrusted by default (RuVector catalogue).
23. **`.kb/` FlexNetOS knowledge base** — canon expectation. Reality 2026-06-12: absent in ALL canon repos (parent has it). v2 stance: REQUIRED at parent + standalone-workable B repos; OPTIONAL for thin members worked exclusively through the meta checkout.
24. **agent-guard + rules:** parent `.claude/settings.json` guard hook (`${CLAUDE_PROJECT_DIR}/agent/target/debug/agent guard`) + `.claude/rules/*` govern the workspace; B repos that are opened standalone (weave, envctl, prompt_hub, handoff) carry their own.
25. **Backup retention (never-delete, compressed, out-of-tree):** tool-generated safe-write backups (`*.idd-bak-*` from the `rusty-idd`/`hf` `next_backup_path`, and any future snapshot-before-overwrite artifact) are **never deleted** — they are relocated into one compressed append-only store per repo at `meta/.backups/<repo>/` (git-ignored, local-only, mirrored off-machine by the operator) and logged in `index.tsv`. `*.idd-bak-*` MUST be git-ignored in every repo running that path; **zero tracked backup files**. Automated via `meta/scripts/idd-backup-sweep.sh` (dry-run by default, `--apply`). Full policy: **`META-BACKUP-POLICY.md`**.

## P6 — The handoff addition (autonomy layer; A/B)

25. **Fresh worktree per session** — all code changes via `meta git worktree create <slug>` / per-repo worktrees; never on shared checkouts.
26. **hf continuity verbs** — `hf claim / checkpoint / handoff`; the `.handoff` witnessed ledger (rusqlite + rvf-crypto WitnessChain) is operational truth. State precedence: **Git > witnessed ledger > task cards > ADRs > narrative docs.**
27. **weave path-lease on claim** — advisory lease `handoff:claim:<task-id>` via the proven `Leaser`/`WeaveCli` subprocess pattern (hf/src/lease.rs); cross-peer conflict ⇒ refuse; weave absent ⇒ degrade to ledger-only. weave Jobs remain the coordination VIEW (correlation_id), never source of truth.
28. **kasetto agent-env preflight** — repos carrying `kasetto.yaml` gate sessions on `kasetto sync --locked` (pattern proven in envctl; HFTASK-0007 wires it into hf session start).
29. **AI gatekeeper as REQUIRED STATUS CHECK** on protected branches. Verdicts ride out-of-band (weave permission-ask + `review_verdict` event in hf's ledger — weave ReviewItem has NO verdict field by design). **Never bot-approve a PR** — that bypasses protection.
30. **Branch protection on A/B default branches** with each repo's real CI checks required (Phase-4 rollout; weave/master = the proven template: 6 checks, fail-closed, PR #61 evidence).

## P7 — The `.handoff` continuity layer (ALL tiers, tiered depth)

> Design frozen in handoff **ADR-0003** (kb↔handoff seam) + **ADR-0004** (fleet rollout). Added 2026-06-12.

31. **Presence.** Every `.meta.yaml` member hosts `.handoff/` at repo root. Tier **A/B** full layout:
    `context/capsule.json` (REQUIRED), `tasks/`, `packets/`, `README.md`; optional `hooks/hooks.toml` +
    `policies/rules.toml` where the repo runs autonomous loops. Tier **C forks + D hubs**: stub =
    `context/capsule.json` + `README.md` — exactly one commit, merge-safe across upstream syncs,
    **no CI/policy forcing** (Tier C discipline unchanged).
32. **Capsule contract** (`handoff.context_capsule.v1`): REQUIRED fields `project_name`, `role`,
    `plane`, `northstar`, `next_command` — seeded from the ARCHITECTURE-TRUTH census; kept accurate
    (the docs-are-traps rule P5.22 applies to capsules too).
33. **No binary state in git.** Per-repo `.handoff/` is git-committed text only. ONE witnessed fleet
    ledger lives at the orchestration home (`handoff/.handoff/ledger.db`); worktree/session ledgers are
    ephemeral and checkpoint back (ADR-0004 §3; session events = `handoff.session_event.v1`).
34. **Cards are minted, derived views.** `.handoff/tasks/` holds only cards minted from kb planning
    tasks (`hf task mint --from-kb`, ADR-0003); card statuses are rewritten from ledger truth at
    checkpoint (`--sync-cards`). The kb board owns planning; precedence **Git > ledger > cards** unchanged.
35. **Aggregation.** `hf fleet status` joins capsules+cards (git) with fleet-ledger events. Git is the
    sync transport — no daemons, no new services.
36. **Rival conventions deprecated for new state** (`_workspace/`, `.lane-loop/`, `/wrap-up`):
    migrate opportunistically per the ADR-0004 migration list; never bulk-delete history.

---

## Current deviations snapshot (2026-06-12 evening — post protection-rollout + P7 adoption)

Resolved since the morning snapshot (evidence: VERIFICATION-REPORT.md clusters A/D): branch protection
live on 24 repos + auto-merge/delete-branch-on-merge enabled; semantic-pr-title propagated to all
canon children; renovate.json landed on the 5 gap repos; `.meta.yaml` canon entries tagged.

| Deviation | Where | Severity |
|---|---|---|
| `.kb/` absent | all canon children | P5.23 (policy-relaxed for thin members) |
| meta_plugin_api: no workflows, stub | meta_plugin_api | P3.12 disposition needed (NEEDS-HUMAN #4) |
| claude-plugin/copilot-plugin are parent path-aliases (`repo: meta`) yet listed in `.gitignore` | parent | cosmetic; clarify in audit |
| `.handoff/` presence 1/58 | fleet-wide | P7.31 — rollout in progress (tasks/fleet-handoff-rollout) |
| Loop-state convention split (`_workspace/`, `.lane-loop/`, `/wrap-up`) | weave, prompt_hub, ECC, n8n, rusty-idd, lane, .github_org | P7.36 — opportunistic migration |

## Research / Cross-References

- **Code:** `loop_lib/.github/workflows/{ci,auto-format,notify-downstream}.yml`, `loop_cli/.github/workflows/notify-parent.yml` + ci.yml dispatch trigger, parent `.github/workflows/{on-child-update,on-push-main,release,semantic-pr-title}.yml`, `release-please-config.json`, `.release-please-manifest.json`, `VERSION`, `renovate.json`, `rust-toolchain.toml`, `.githooks/commit-msg`, `Makefile`, `meta_git_cli/src/main.rs:8,54` (run_plugin), `meta_plugin_api/src/lib.rs` (109-line stub), `meta_core/src/*` (1.7k lines), `loop_lib/Cargo.toml` + `meta_cli/Cargo.toml` (`version.workspace = true`), root `.gitignore` (child list), `.meta.yaml` canon entries.
- **Live API:** `gh api repos/FlexNetOS/<r>` + `/branches/main/protection` for all 10 canon (404 = unprotected, 2026-06-12); org-level PARENT_REPO_PAT verified 2026-06-11 session.
- **Memoir:** `meta-architecture-canon`, `adr-2026-06-11-meta-loop-lib-status`, `decision-log-2026-06-09`, `seam-spec-{weave-a2a,kasetto-agent-env,envctl-meta-env,ruvocal-prompthub}-2026-06-11`, `adr-2026-06-11-repo-docs-accuracy`, `ship-loop-proof-2026-06-12` (weave workspace = INTERIM; protected-merge loop proven), `hardware-network-walls`.
- **Dispatch graph (verified from workflow matrices):** loop_lib→{loop_cli, meta_cli, meta_git_cli}; meta_core→{meta_cli}; meta_plugin_protocol→{meta_cli, meta_git_cli, meta_project_cli, meta_rust_cli}; meta_git_lib→{meta_git_cli, meta_project_cli}; meta_cli→{meta_git_cli, meta_project_cli, meta_rust_cli, meta_mcp}; leaves→parent (`child-repo-updated`); parent→sync-PR via on-child-update.yml.
