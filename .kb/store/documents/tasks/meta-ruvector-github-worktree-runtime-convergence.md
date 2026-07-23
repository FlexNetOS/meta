---
id: 019f809f-196d-7f93-9b39-32a5e80f4b74
slug: tasks/meta-ruvector-github-worktree-runtime-convergence
title: "Converge meta-ruvector worktrees PRs hooks and runtime frontdoor"
type: task
status: active
priority: critical
---

## Objective

Converge the `meta-ruvector` repository to a clean, merged GitHub state while
preserving meaningful worktree changes, repairing owned hook/runtime wiring,
and retaining only approved primary branches and organization SSH remotes.

## Required Outcomes

- Inventory and resolve every registered worktree and its changes.
- Resolve and merge every open pull request; use the pull-request branch as
  conflict source of truth when reconciliation cannot be established safely.
- Repair hook source wiring and verify `/home/flexnetos/.nix-profile` is the
  sole active Yazelix/Codex frontdoor, without treating any home-owned binary,
  configuration, state, cache, runtime, launcher, or compatibility tree as an
  alternative owner.
- Remove non-primary worktrees, branches, stale tracking refs, and unapproved
  remotes only after their work is incorporated.
- Retain only `main`/`master` and `dev`/`develop` when present, and prove the
  final repository, GitHub PR, hook, worktree, branch, and remote inventories
  are clean.

## Evidence Log

- Baseline pending: 14 registered worktrees, current branch
  `fix/security-audit-advisories`, organization SSH `origin`, and an `upstream`
  remote requiring policy-based retirement after branch/PR convergence.
- PR [#126](https://github.com/FlexNetOS/meta-ruvector/pull/126) repairs the
  failed CI gate that PR #124 was allowed to merge with: the workflow now pins
  `hustcer/setup-nu` v3.25, active workflows use a Nushell default shell, and
  the MetaBioHacker package uses Bun. Local proof passed `nu
  ci/gates/automation_policy.nu`, the MetaBioHacker Bun tests and benchmark,
  `sonic-ct` release tests and Clippy, and the `codex-env` mirror test that
  covers a non-repository `git check-ignore` broken pipe. The two completed
  remote checks (automation policy and MetaBioHacker gates) passed; the Rust
  engine remote check remains the merge gate at this record's update time.
- PR #126 subsequently merged as `c3f36cca52900bc566562fc936bcedf1b4a7e992`
  after all four required checks passed. Follow-up PR #127 merged as
  `afbdc5d22f376c428dd6eff36c5ceefac22750d2`, makes ignored
  `.claude-flow` runtime data an explicit mirror exclusion, and adds a
  post-test-stability regression test. Targeted `codex-env` formatting, all
  27 tests, and Clippy passed at that current-main commit. At the receipt
  time, `meta-ruvector` has no open GitHub pull requests and `main` is clean;
  the isolated PR #126 worktree was automatically removed only after merge.
