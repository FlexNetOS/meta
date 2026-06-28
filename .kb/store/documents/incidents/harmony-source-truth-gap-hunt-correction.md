---
id: 019f0f59-4fa3-7000-9fe8-ecd4474057e3
slug: incidents/harmony-source-truth-gap-hunt-correction
title: "Correct Harmony source-of-truth gap hunt misses"
type: incident
status: active
priority: high
tags: [codex, correction, harmony, source-of-truth]
---

# Overview

Previous gap hunt missed `.context/` and did not open archival KB docs returned by `git kb search harmony` before creating the Meta Harmony report/repo. It also described docs as obsolete even though their claims had not been refuted or superseded.

## Root Cause

- Treated KB namespace `obsolete/` as semantic staleness instead of archival metadata.
- Followed KB-first but failed to reconcile `.context`, `.handoff`, docs, and live GitHub redirects.
- Did not distinguish a new placeholder repo from a pre-existing source-of-truth repo.

## Source-of-truth findings

- `.context/CONTEXT.md` and `.context/tasks/cicd-distribution-gaps.md` define legacy-active distribution requirements: GitHub Releases, install scripts, Homebrew tap, cargo-binstall, crates.io token setup.
- `obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar` still contains live migration lessons about harmony-labs -> gitkb -> FlexNetOS org references and generated CI source-of-truth.
- `.handoff/census-workspace-arch.*` records harmony-labs/gitkb lineage across several repos.
- `gh repo view harmony-labs/meta` resolves to `gitkb/meta`; harmony-labs paths are redirect/migration evidence, not simply missing.
- `FlexNetOS/meta-harmony` exists now, but is a new placeholder requiring lineage reconciliation before adoption.

## Corrective Actions

- [x] Wrote `.handoff/loop/plan/reports/meta-harmony-source-truth-correction.md`.
- [x] Updated the Meta Harmony gap-hunt report with a correction notice.
- [x] Updated ADR-0003 with lineage/source-truth correction.
- [x] Updated KB task/spec to require `.context` + archival KB reconciliation.
- [ ] Future implementation initializes/adopts `meta-harmony` only after lineage reconciliation.


## Completion Evidence

- Root commit: `2bd171cf62e1f14c79a0977efc7cb3a3b1be1208` (`docs: correct Harmony source truth handling`).
- PR: https://github.com/FlexNetOS/meta/pull/91 on branch `codex/meta-env-layout-audit-20260628111631`.
- Verification: staged diff check passed before commit; correction markers present in report, ADR, KB incident/task/spec; branch push and PR head verified.


## Correction-of-correction: evidence gate failure

The first correction pass repeated the same behavioral mistake: its transcript shows failed/no-output lookup while trying to open exact obsolete KB docs, followed by confident patching, commit/push, and completion. That invalidates the prior `Completion Evidence` as a behavioral proof; it only proves files were committed, not that the evidence gate was followed.

Fix rule added: source retrieval is a hard gate. Failed, empty, or truncated lookup means `UNVERIFIED`; no confident claim, no correction write, no commit-as-complete, and no completion until exact evidence is opened or the claim is explicitly scoped out.

Linked incident: [[incidents/harmony-correction-evidence-gate-failure]].

## Prevention Rule

For any future gap hunt/source-truth/release/harmony/distribution task, open `.context`, `.handoff`, matching KB search results including `obsolete/`, and live GitHub remotes before creating repos or asserting missing/current state. If any required lookup fails, returns no output, or is truncated, stop and mark the dependent claim `UNVERIFIED` instead of patching or completing from inference.
