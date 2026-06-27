---
id: 019e9eb4-3dd8-7f92-8adc-1c8a9c5105f3
slug: obsolete/integrate-top-gitkb-migration-finds-atc-gh-config
title: "Integrate top gitkb migration finds: atc, gh-config-cli, workflow-rust-* into FlexNetOS meta"
type: task
status: draft
priority: high
tags: [migration, atc, gh-config-cli, ci, flexnetos, integration, plan]
---

# Overview

Integration plan for the high-value repos surfaced by the gitkb→FlexNetOS
research (see [[gitkb-to-flexnetos-migration-briefing-26-repos]]). Brings the 3
`migrate` candidates (+ the paired `workflow-rust-release`) into the FlexNetOS
org and the meta workspace, and wires them into the existing CI architecture
(see [[meta-as-source-of-truth-meta-generated-ci-dashboar]]).

In scope: `atc`, `gh-config-cli`, `workflow-rust-quality`, `workflow-rust-release`.
Out of scope (separate triage): `homebrew-tap`, `contree-cli`, `gitkb-claude-plugin`,
`highrust`, and archiving the legacy mirrors.

# Goals

- Move each repo to `FlexNetOS/<name>` with full git history (mirror, not copy).
- Re-point internal `gitkb/` and `harmony-labs/` references inside each repo.
- Register each as a meta peer in `.meta.yaml` (+ `.gitignore`), with tags.
- Connect them to the meta architecture: `gh-config-cli` → `meta ci protect`;
  `workflow-rust-*` → the reusable CI peers consume (meta-generated-CI Phase C).

# The migration primitive (applies to each repo)

A reusable, history-preserving procedure. **Repo creation under the FlexNetOS
org is outward-facing** — either the user creates the empty repo, or the agent
does it via `gh repo create FlexNetOS/<name> --private/--public` IF the token has
org-create scope (verify first; otherwise it is a USER step).

1. **Create** `FlexNetOS/<name>` (empty, no auto-init). [user or `gh repo create`]
2. **Mirror history:**
   `git clone --mirror git@github.com:gitkb/<name>.git /tmp/<name>.git` then
   `git -C /tmp/<name>.git push --mirror git@github.com:FlexNetOS/<name>.git`
   (preserves all branches/tags). Alternatively a fresh clone + new remote +
   `push --all && push --tags`.
3. **Clone into workspace** under the meta root (path = repo name).
4. **Re-point internal refs** `gitkb/` and `harmony-labs/` → `FlexNetOS/`
   (README badges, release-please config, homebrew/scoop refs, reusable-workflow
   `uses:` chains). Same class of fix as org-fix Phase B.
5. **Register peer:** add to `.meta.yaml` (`repo`, `tags`) + `.gitignore`.
6. **Workspace membership decision:** add to root `Cargo.toml` members only if it
   builds cleanly there; if it links C / cloud SDKs or carries its own
   `[workspace]`, keep it `exclude`d (cf. grit/envctl). Default: peer-only first,
   promote to member after a clean `cargo build`.
7. **Verify:** `meta git update` clones it; `cargo build` (Rust repos) green.
8. **Commit** `.meta.yaml`/`.gitignore`/`Cargo.toml` changes in the root meta repo.

# Per-repo plan

### A. atc → `FlexNetOS/atc`  ✅ DONE (2026-06-06)
- [x] Created public `FlexNetOS/atc` (user-authorized visibility)
- [x] Mirrored full history: 64 branches + 8 tags pushed
- [x] Cloned into workspace at `./atc`, origin = `FlexNetOS/atc`, gitkb remote removed
- [x] Re-pointed org refs (`gitkb/`,`harmony-labs/` → `FlexNetOS/`) in Cargo.toml,
      CONTRIBUTING.md, README.md, .github/workflows/release.yml, homebrew/atc.rb
      (commit 310a1f9, pushed). Source GitKB-product refs + CHANGELOG left intact.
- [x] Registered peer in `.meta.yaml` (tags `[ai, orchestration, rust]`) + `.gitignore`
- [x] Membership: PEER-ONLY (atc has its own `[workspace]`; NOT a meta-root member,
      no exclude needed — its workspace shields it from the parent)
- [x] Verified: builds standalone (229 crates, clean); `meta project list` shows it
- Note: tags landed as `[ai, orchestration, rust]` (not the plan's `[agent,...]`) so
  it groups under the existing `ai` dashboard tab alongside `agent`.
- Follow-up (not blocking): document atc-vs-grit worktree-coordination overlap.

#### Original plan (for reference)
- Multi-crate Rust workspace (`crates/atc-cli`): agent orchestrator (worktree
  isolation, 6-signal health, SQLite dispatch registry, queue/daemon, TUI).
- Steps: migration primitive 1–8.
- Re-point: release-please manifest/config, Homebrew tap refs (`gitkb` →
  `FlexNetOS`), any `gitkb`/GitKB API endpoints it calls.
- `.meta.yaml`: `atc: { repo: git@github.com:FlexNetOS/atc.git, tags: [agent, orchestration, rust] }`.
- Membership: likely peer-only at first (has its own release packaging); attempt
  root-workspace membership after a clean build, else `exclude`.
- Integration note: overlaps conceptually with `agent` and grit's worktree
  coordination — evaluate whether atc supersedes/complements grit's
  claim→work→done harness (don't merge yet; document the overlap).
- Acceptance: builds; `meta --include atc exec -- cargo build` green; no
  `gitkb/`/`harmony-labs/` refs remain.

### B. gh-config-cli → `FlexNetOS/gh-config-cli`  (priority 2 — feeds org-as-code)
- "GitHub org config as code" CLI: YAML for repos/teams/perms/webhooks/branch
  protections; `diff`, dry-run `sync`, `sync-from-org`.
- Steps: migration primitive 1–8.
- Integration: this is the natural engine for the spec's **`meta ci protect`**
  (branch-protection-as-code). After migration: run `gh-config sync-from-org` to
  capture current FlexNetOS org state into a committed YAML baseline, then make
  branch-protection + required-checks declarative. This also fixes the
  "unprotected main → `--auto` no-ops" gap noted in the CI spec.
- `.meta.yaml`: `tags: [rust, infra, org-management]`.
- Acceptance: builds; `gh-config sync-from-org` produces a FlexNetOS org baseline;
  documented as the org-config source of truth.

### C. workflow-rust-quality + workflow-rust-release → `FlexNetOS/*`  (priority 3 — feeds meta-generated CI)
- Migrate as a PAIR (they form one `workflow_call` chain).
- **Re-home upstream refs FIRST:** both still `uses:` `harmony-labs/*`
  (`workflow-vnext-tag`, `workflow-release`, etc.). Either migrate those too or
  inline/replace them — resolve before peers consume the chain.
- Steps: migration primitive 1–6 (these are YAML-only; no cargo build).
- Integration: these become the reusable workflows the **meta-generated-CI**
  plan renders callers for. After migration + `@v1` tag, the spec's Phase C
  pilot (`uses: FlexNetOS/workflow-rust-quality/...@v1`) can target them — OR
  consolidate with the `.github_org` reusable-* templates (decide: one canonical
  reusable-CI source, not two). **Open decision: workflow-rust-* vs
  .github_org/reusable-* as the canonical reusable CI.**
- `.meta.yaml`: `tags: [ci, github-actions, rust]`.
- Acceptance: no `harmony-labs/`/`gitkb/` refs; `@v1` tagged; one pilot crate
  consumes them green.

# Sequencing & dependencies

```
1. atc            (standalone, highest value)        ──┐
2. gh-config-cli  (standalone) ─→ enables meta ci protect (CI spec Phase D)
3. workflow-rust-* (pair) ─→ enables meta-generated-CI reusables (CI spec Phase C)
```
A and B are independent and parallelizable. C should precede/merge with the CI
spec's Phase C. All three are downstream of the now-completed org-fix (Phase B).

# Acceptance criteria

- [ ] `atc`, `gh-config-cli`, `workflow-rust-quality`, `workflow-rust-release`
      exist under `FlexNetOS/` with full history
- [ ] Each registered as a meta peer; `meta git update` clones them; `meta project list` shows them
- [ ] No `gitkb/` or `harmony-labs/` refs remain in the migrated repos
- [ ] Rust repos build (`cargo build`); membership-vs-exclude decided per repo
- [ ] `gh-config-cli` produces a committed FlexNetOS org-config baseline
- [ ] `workflow-rust-*` re-homed + `@v1` tagged; ≥1 pilot crate consumes them
- [ ] Briefing's archive/drop + needs-review repos tracked in follow-ups

# Context / open decisions

- **Repo creation is outward-facing** — confirm whether the agent's `gh` token
  can `gh repo create` under FlexNetOS, else these are USER steps.
- **Reusable-CI canonicalization:** `workflow-rust-*` vs `.github_org/reusable-*`
  — pick ONE source of truth before wiring peers (avoid a third CI dialect).
- **atc vs grit overlap:** both do worktree-based agent coordination; document
  the relationship, don't merge prematurely.
- Ties into [[meta-as-source-of-truth-meta-generated-ci-dashboar]] (Phases C/D)
  and [[tasks/github-meta-refactor]] (peer grounding).

# Progress Log

### 2026-06-06
- Created from the gitkb research briefing. Org-fix Phase B (gitkb→FlexNetOS)
  already pushed (12 repos) — these migrations build on it.
- Drift verified clear for already-migrated crates, so the gitkb org is safe to
  retire once these high-value repos are pulled across.
- **atc MIGRATED** (priority 1, DONE): public FlexNetOS/atc created, full history
  (64 branches + 8 tags), org refs re-pointed, registered as peer (ai/orchestration/
  rust), builds clean. Root meta registration committed locally on
  dashboard-tab-grouping (unpushed). Next: gh-config-cli (priority 2).
