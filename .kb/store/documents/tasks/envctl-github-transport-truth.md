---
id: 019ef27d-f8e0-7ee1-9188-d8f54ad136ca
slug: tasks/envctl-github-transport-truth
title: "Route verified GitHub transport doctrine into envctl"
type: task
status: active
priority: high
tags: [envctl, github, handoff, redb, ssh]
---

# Overview

Capture and route the verified meta GitHub transport and automation doctrine into envctl so envctl can implement the missing credential/merge-gate pieces without relying on stale assumptions or raw GitHub API output.

Deep research started from `meta/.kb/AGENTS.md` and loaded the meta KB/context. The proof is source-grounded: `.meta.yaml`, live git remotes, `.github_org` architecture docs/TODO, `handoff` ADR/source, `flexnetos_github_app` source, and live `gh`/SSH checks.

## Goals

- Make envctl aware that local `git` over SSH is the repository source of truth for FlexNetOS repos.
- Keep `gh` CLI/API as GitHub workflow orchestration, but require re-query/cross-checks against git refs, PR state, and required checks before trusting mutations.
- Route the missing envctl-owned GitHub credential work into the existing envctl handoff loop, especially scoped GitHub App token mint/injection and policy-drift token provisioning.
- Preserve the fail-closed model: agents do not hold broad merge tokens, do not native-APPROVE their own PRs, and do not force-merge red checks.

## Acceptance Criteria

- [ ] envctl backlog/task docs include the GitHub transport doctrine: SSH git is repo truth; `gh` is orchestration; raw API/connector output is advisory until re-queried.
- [ ] envctl exposes/validates the scoped GitHub App token path needed by downstream consumers: `secretctl mint-github --installation-id 140063898 --output json` and related enroll/revoke flows remain byte-stable.
- [ ] envctl has a concrete owner path for `POLICY_DRIFT_TOKEN` / app-minted equivalent so `.github` policy drift can read branch protection, rulesets, environments, and repo settings in strict mode.
- [ ] Any envctl implementation keeps tokens broker-only/scoped/short-lived and never logs secrets.
- [ ] Integration proof cross-checks `flexnetos_github_app` consumer expectations, especially merge-gate check-run writer expectations.
- [ ] Verification uses SSH-backed git refs plus `gh` re-query; no raw API mutation is treated as success without read-back.
- [ ] Handoff continuity is exported/committed using the current redb-backed ledger plus deterministic JSONL export; do not describe this as SQLite.

## Context / Proof

- `meta/.kb/AGENTS.md` requires KB/context-first operation and says the document is the plan.
- `.meta.yaml` currently configures 66/66 project repos as `git@github.com:FlexNetOS/...` SSH URLs.
- Live sample origins for `meta`, `.github_org`, `envctl`, `meta-ruvector`, `rusty-idd`, `weave`, `handoff`, and `flexnetos_github_app` are SSH.
- `git ls-remote --symref origin HEAD` from meta succeeds over SSH.
- `gh auth status` is logged in, but `gh config get git_protocol` reports `https`, so `gh` must not be treated as the git transport source of truth.
- `.github_org/TODO.md` records that default `GITHUB_TOKEN` cannot read branch protection, rulesets, or repo settings; strict policy drift needs a provisioned token from envctl.
- `.kb/store/documents/tasks/github-local-model-pivot.md` records cloud-token burn from automatic Claude review flows and the requirement to move GitHub automation to local model / opt-in review.
- `.kb/store/documents/incidents/release-please-token-unavailable.md` records that `GITHUB_TOKEN`-created PRs do not trigger CI, so release PRs cannot pass required checks/auto-merge until the proper org secret/token path is granted.
- `.github_org/architecture/map/01-meta-control-plane.md` records that `gh` mutations can silently succeed and must be re-queried; it also records GitHub auto-merge/API edge cases.
- `.github_org/architecture/plan/2026-06-17-deep-review-upgrade-plan.md` records a concrete policy-applier hazard: `gh repo view` resolving from the wrong CWD can mutate the wrong repo unless owner/repo is asserted.
- `flexnetos_github_app/crates/app-core/src/merge_gate.rs` says the App should post a verdict as a required GitHub check-run and arm native auto-merge only after green; it must never be a native bot APPROVE, and the current `UnwiredMergeGate` fails closed.
- `handoff` source/ADRs record the out-of-band review verdict model: judgment is recorded in handoff/weave state and enforced via required check/merge gate, not by bot approving the PR.

## Envctl Scope

Primary envctl areas:

- `.handoff/loop/backlog.md` and relevant task cards for GitHub App mint/enroll/revoke/token provisioning.
- `crates/secretd`, `crates/secretctl`, `crates/secrets-engine` GitHub App provider mint path.
- Any envctl agent/environment injection surfaces that provide short-lived GitHub tokens to `gh`/workflow automation.

Consumer cross-checks:

- `../flexnetos_github_app/crates/app-core/src/mint.rs`
- `../flexnetos_github_app/crates/app-core/src/merge_gate.rs`
- `.github_org` policy drift scripts and workflows.

## Notes

This is not a request to avoid the GitHub API entirely. It is a requirement to use it through controlled `gh`/App paths with explicit owner/repo selection, least privilege, read-back verification, and SSH git as the repository truth.