---
id: 019e9e84-fa29-7982-bb40-202ba4c705b1
slug: obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar
title: "Meta as Source of Truth: meta-generated CI, dashboard, and agent-env"
type: spec
status: draft
priority: high
tags: [architecture, meta, ci, envctl, kasetto, spec]
---

# Overview

Three architecture/flow problems were raised: (1) envctl's design and its
connection to meta, (2) the kasetto agent-env manager's design and connection to
meta, (3) GitHub pipeline management across all meta repos. They are three faces
of **one root cause**: `.meta.yaml` already holds the workspace's declarative
truth (repos, `tags`, `depends_on`/`provides` DAG), but every consumer hand-rolls
its own coupling to it instead of reading a shared, typed model.

This spec defines the target: **`.meta.yaml` (+ a typed workspace model) is the
single source of truth, consumed uniformly by the dashboard, the agent-env
provisioner, and a new meta-generated CI subsystem.** Priority order (user
decision 2026-06-06): **CI first**, via a **meta-generated CI** model.

Builds on [[tasks/github-meta-refactor]] (which grounded all repos as meta peers
and authored the reusable-CI templates, but stopped before Phase 4 — wiring CI).

# Current state (verified 2026-06-06)

## The shared truth and its three consumers

| Consumer | Reads `.meta.yaml`? | Coupling today | Problem |
| --- | --- | --- | --- |
| **Dashboard** (envctl) | yes | `meta dashboard` shells to `envctl dashboard --json`; envctl re-parses `.meta.yaml` | stringly-typed seam; `tags` overloaded for UI grouping |
| **Agent-env** (kasetto) | no | envctl-local, `scope: project`, off a local `./agent-skills` mirror | no meta-wide fan-out; not its own peer |
| **CI / pipelines** | no | per-repo `repository_dispatch` mesh + unused reusable workflows | dead `gitkb/` refs; reusables have zero callers; no config-as-code |

## envctl (problem 1)
- Pure-Rust workstation env manager. 8-crate Cargo workspace. Components are TOML
  **data** (`manifest/*.toml` + `components.d/`), not Rust traits; dep-ordered via
  Kahn topo sort; content-hashed `envctl.lock` with `lock --check` CI gate.
- **Only meta wiring:** `crates/engine/src/dashboard.rs` reads `.meta.yaml`
  (walks up from cwd; honors `--meta-file`/`$META_FILE`), groups repos by `tags`,
  renders a zellij mission-control KDL (one tab per tag-group, one pane per repo).
  `meta_dashboard_cli` is a pure passthrough that shells to `envctl dashboard
  --json` and fails closed if envctl is absent. **No crate dependency either way.**
- envctl is `exclude`d from the root Cargo workspace (links/policy reasons).

## kasetto (problem 2)
- Separate CLI (v3.0.0), source in `vault_hub/kasetto`; binaries `kasetto`/`kst`.
- Manages the **AI-agent toolkit** (skills + MCP servers + slash-commands) into
  `.claude/`/`.codex/` — the layer *above* envctl's OS/toolchain layer. envctl
  borrowed its lock/doctor design **from** kasetto.
- Wired into envctl as one component (`manifest/agent-env.toml`, id `kasetto`):
  detect = binary present, verify = `kasetto sync --locked` clean, install/fix =
  `cargo install kasetto` + `kasetto sync`, remove = `kasetto clean --project`.
- Runs `scope: project` against **envctl's repo only**, off a local
  `./agent-skills` mirror (`source_revision: local`). No `meta exec` fan-out, no
  canonical published skills source, not registered as its own `.meta.yaml` peer.

## CI / pipelines (problem 3)
- **Two disconnected layers:**
  - hand-rolled `repository_dispatch` mesh: FlexNetOS Rust crates fire
    `notify-downstream`/`notify-parent`; meta root `on-child-update.yml` opens
    auto-merged sync PRs.
  - real reusable `workflow_call` templates in
    `.github_org/.github/workflows/reusable-*.yml` — **zero callers**, no `@v1` tag.
- ~37/52 repos have workflows, in 3 populations: FlexNetOS Rust crates (templated
  3-workflow: `ci`/`auto-format`/`notify-*`), forks (huge upstream CI — n8n ~90,
  codex ~22), hubs (single `validate.py`).
- **ACTIVE BUG:** 30 workflow files across 11 repos reference the dead `gitkb/`
  org (`repository: gitkb/${{ matrix.downstream }}`, `gitkb/meta`). The dispatch
  mesh is firing into the void.
- `flexnetos_github_app` and `flexnetos_runner` are **empty placeholder repos**;
  their code still lives inside `.github_org/`.
- No org-wide branch-protection-as-code → `gh pr merge --auto` silently no-ops on
  unprotected `main`s.

# The overlooked adoption step (added 2026-06-06, from reading meta/docs)

User flagged: "we overlooked this critical step before adopting meta structure."
Confirmed by reading the meta docs (`docs/*.md`, `README.md`, `.context/`):

**There is NO documented org-migration / "adopt meta" maintainer runbook.** The
docs describe how a *user* consumes a meta workspace (clone, `.meta.yaml`,
`meta git update`, `meta init`) but never how to **re-point all org references
when the repo set moves to a new GitHub org**. That step exists only as a
half-remembered precedent: `CHANGELOG.md:29` records the *previous* org rename
"updating harmony-labs GitHub org to gitkb (#74)" — done once as a tracked sweep,
never written down. So when the second rename (`gitkb → FlexNetOS`) happened,
`.meta.yaml` remotes were updated but the org name was left hardcoded in:
- every child `ci.yml`/`auto-format.yml` (sibling `git clone` URLs + synthetic
  `repository =` lines), `notify-parent.yml`/`notify-downstream.yml`
  (`repository_dispatch` targets) — the dispatch mesh fired into a dead org;
- `meta_cli/src/registry.rs` `DEFAULT_REGISTRY` (+ a test pinning it) — the
  plugin registry pointed at the dead org;
- `meta_cli/src/init.rs` — `meta init` printed dead-org install instructions;
- `agent/Cargo.toml` `repository` metadata.

**The missing step, named:** *"Re-point every GitHub-org reference (CI dispatch
targets, CI clone URLs, `Cargo.toml repository`, plugin `DEFAULT_REGISTRY`,
`meta init` URLs) to the new org"* — a uniform sweep that must accompany any org
move. It was never a documented procedure, which is exactly why it was skipped.

**Why this validates the spec's thesis:** the org is currently hardcoded in N
places with no single source of truth. Under **meta-generated CI**, the org is
declared **once** (in `.meta.yaml` / the workspace model) and every workflow is
rendered from it — an org move becomes a one-line change + `meta ci sync`, and
`meta ci check` would have caught the drift. This spec's design *is* the missing
runbook, encoded as tooling rather than tribal memory.

**Deferred (separate decision): marketplace rename.** The Claude Code plugin
marketplace is named `gitkb` in `claude-plugins/.claude-plugin/marketplace.json`
(`"name": "gitkb"`), so `claude plugin install meta@gitkb` is still correct and
was preserved. Renaming the marketplace `gitkb → flexnetos` (manifest name + all
`meta@gitkb`/`gitkb@gitkb` install commands + `claude-plugins/README.md` +
`plugin_hub/entries/claude-plugins.md`) is a coordinated product rename, tracked
as its own follow-up, NOT part of the dead-org fix.

# Goals

- Establish `.meta.yaml` (+ typed model) as the single source of truth all three
  subsystems consume.
- **CI first**: a `meta ci` subsystem that **generates** each repo's workflows
  from `.meta.yaml` (config-as-code, regenerable, drift-checkable).
- Fix the dead `gitkb/` dispatch refs (immediate, low-risk).
- Adopt the reusable-workflow templates that already exist (give them callers +
  a `@v1` tag).
- De-overload `tags`: separate semantic classification from UI grouping.
- Lay the path for kasetto to go meta-wide and for the dashboard seam to become
  typed — without blocking the CI work.

# Target architecture

## Core: the workspace model

`.meta.yaml` stays the human-edited source. Add a **typed workspace descriptor**
the tooling consumes, so no consumer re-parses YAML ad hoc:

- Option A — a small shared crate (`meta-workspace-schema`) defining the model
  (repo, tags, deps, ci-profile), depended on by `meta` and envctl.
- Option B — `meta query --json` becomes the authoritative emitter; consumers
  (dashboard, `meta ci`, kasetto fan-out) read **that**, never the raw YAML.

Recommendation: **B now** (lowest coupling, ships with `meta`), **A later** if a
compile-time contract proves worth it. Decision pending (see Open questions).

De-overload `tags`: keep `tags` semantic (`ai`, `forked`, `hub`, …); introduce a
**CI profile** dimension (e.g. `ci: rust-crate | hub | fork-passthrough | none`)
and, if needed, a `dashboard.group` field so UI grouping stops hijacking `tags`.

## Problem 3 (priority): meta-generated CI

A new `meta ci` capability (plugin or subcommand) treats workflows as **generated
artifacts** derived from the workspace model:

1. **CI profiles** keyed off `.meta.yaml`: each repo maps to a profile
   (`rust-crate`, `hub`, `fork-passthrough`, `none`). Profile → which reusable
   workflows it gets.
2. **`meta ci sync`** renders each repo's `.github/workflows/*` from profile
   templates that `uses:` the slim `.github` reusables pinned `@v1`. Per-repo CI
   becomes a thin generated caller, not copy-paste.
3. **`meta ci check`** = drift gate (generated ≠ committed → fail), runnable in CI
   and locally, same spirit as `envctl lock --check` / `kasetto sync --locked`.
4. **Dispatch mesh**: either regenerate it correctly from the dep DAG
   (`gitkb/`→`FlexNetOS/`, downstreams derived from `depends_on`) or retire it in
   favor of meta-native orchestration. Fix the dead refs regardless.
5. **Branch-protection-as-code**: `meta ci protect` applies protection +
   required-checks via `gh api`, keyed off profile, so auto-merge actually works.

Sequencing within problem 3:
- **3a** Fix `gitkb/`→`FlexNetOS/` in 30 files (unblocks the existing mesh; no new
  architecture). *Lowest risk, highest immediate value.*
- **3b** Tag `.github@v1`; convert one pilot rust-crate's `ci.yml` to a `uses:`
  caller; validate green.
- **3c** Build `meta ci sync`/`check` to generate the caller workflows from
  `.meta.yaml` profiles; roll out across the rust-crate population.
- **3d** `meta ci protect` for branch protection; extend profiles to hubs.
- Forks stay `fork-passthrough` (upstream CI untouched) by default.

## Problem 1: typed dashboard seam (later)

- Replace the stringly-typed `--json` contract with the shared model (Option A/B
  above), so dashboard output can't silently drift.
- Move UI grouping off `tags` onto `dashboard.group` (or derive from CI/tag
  taxonomy). Removes the `# mission-control:` annotations from `.meta.yaml`.

## Problem 2: kasetto meta-wide (later)

To make agent environments uniform across all repos:
1. Publish a **canonical `agent-skills` source** (promote from `vault_hub/kasetto`
   or a dedicated `skills_hub` peer); register kasetto as a first-class peer.
2. Per-repo `kasetto.yaml` using **`extends`** for an org→repo overlay (shared
   baseline + per-repo additions), pinned by locked hash.
3. **`meta exec -- kasetto sync --locked`** CI gate (tag-filtered via the same
   workspace model) so every repo's agent env is reproducible and drift-checked.

# Phased plan

### Phase A — Spec & decisions (this session)
- [x] Map current state of all three (3 research agents)
- [x] Author this spec
- [ ] Resolve open questions (workspace-model A vs B; mesh keep-vs-retire; CI
      profile taxonomy) with user

### Phase B — CI quick win (problem 3a) ✅ DONE (2026-06-06, local commits)
- [x] Fix `gitkb/`→`FlexNetOS/` across the workflow files (10 meta crates)
- [x] Fix the generators that reintroduce it: `meta_cli/src/registry.rs`
      (`DEFAULT_REGISTRY` + renamed test), `meta_cli/src/init.rs`,
      `agent/Cargo.toml`
- [x] Sweep meta-owned README/CONTRIBUTING URLs (agent, loop_cli, meta-plugins)
- [x] Preserve marketplace name `meta@gitkb` (product id, not org)
- [x] Verify: workflows clean, `meta_cli` registry tests pass (56)
- [ ] Push commits (awaiting user) — 12 repos committed locally
- [ ] Verify dispatch fires against live org once pushed (or mark mesh for retirement)
- Snapshot taken before the sweep: `pre-gitkb-org-fix`

### Phase C — Reusable CI adoption (problem 3b)
- [ ] Cut `.github@v1` tag on the slim reusables
- [ ] Pilot: convert one rust-crate `ci.yml` → `uses: …reusable-test.yml@v1`; green

### Phase D — meta-generated CI (problem 3c/3d)
- [ ] Define CI-profile field/taxonomy in `.meta.yaml` (or derive from tags)
- [ ] Implement `meta ci sync` (render caller workflows from profiles)
- [ ] Implement `meta ci check` (drift gate)
- [ ] Roll out across rust-crate peers; then hubs
- [ ] `meta ci protect` — branch protection + required checks as code

### Phase E — typed seam + kasetto meta-wide (problems 1 & 2)
- [ ] Land the shared workspace model (A or B); migrate dashboard onto it
- [ ] De-overload `tags` (introduce `dashboard.group`)
- [ ] Canonical `agent-skills` source + per-repo `kasetto.yaml` `extends` overlay
- [ ] `meta exec -- kasetto sync --locked` gate

# Acceptance criteria

- [ ] No workflow references the dead `gitkb/` org
- [ ] `.github@v1` exists; ≥1 peer consumes reusable CI via `uses: …@v1`
- [ ] `meta ci sync` regenerates per-repo CI from `.meta.yaml`; `meta ci check`
      fails on drift
- [ ] Branch protection applied as code on the rust-crate peers; `--auto` merge works
- [ ] Dashboard reads the shared model, not ad-hoc YAML; UI grouping off `tags`
- [ ] kasetto sync runs meta-wide with a locked gate (deferred phase)

# Open questions

1. **Workspace model**: `meta query --json` emitter (B) vs shared schema crate (A)?
   (Lean B now.)
2. **Dispatch mesh**: fix-and-keep, or retire in favor of meta-native orchestration
   driven by the dep DAG?
3. **CI profile taxonomy**: explicit `ci:` field in `.meta.yaml` vs derive profile
   from existing `tags`?
4. **`meta ci` home**: new meta plugin (`meta_ci_cli`) vs subcommand in an existing
   plugin? (New plugin = own repo per meta-repo discipline.)
5. **Forks**: leave entirely on upstream CI (`fork-passthrough`), or also layer a
   thin FlexNetOS gate?

# Context / key decisions

- **User decisions (2026-06-06):** spec first; CI is priority #1; **meta-generated
  CI** is the chosen model (config-as-code from `.meta.yaml`).
- **Unifying thesis:** `.meta.yaml` as single source of truth, consumed uniformly
  — fixes all three problems with one architectural move.
- **Meta-repo discipline:** a new `meta ci` plugin must be its own FlexNetOS repo,
  registered in `.meta.yaml` + `.gitignore`.
- **Non-destructive:** generation + drift-check mirrors the proven
  `envctl lock --check` / `kasetto sync --locked` pattern already in the workspace.

# Progress Log

### 2026-06-06
- Mapped all three problem areas via 3 parallel research agents (envctl↔meta,
  kasetto, github pipelines). Findings captured in "Current state" above.
- User chose: spec-first, CI-priority, meta-generated-CI model.
- Authored this spec. Next: resolve open questions, then Phase B (gitkb ref fix).
- Read meta/docs (user directive): confirmed there is NO org-migration runbook —
  the overlooked step. Documented above ("The overlooked adoption step").
- **Phase B executed:** snapshot `pre-gitkb-org-fix`; swept `gitkb -> FlexNetOS`
  across 10 crates' CI workflows + `meta_cli` registry/init + `agent` metadata +
  3 meta-owned READMEs. Preserved marketplace name `meta@gitkb`. Verified clean
  (56 registry tests pass). Committed locally in 12 repos; push pending user OK.
  Marketplace rename deferred as a separate follow-up.
