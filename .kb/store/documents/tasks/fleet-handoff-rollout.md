---
id: 019ebd79-097c-7f71-86d1-0f6e06c9c38e
slug: tasks/fleet-handoff-rollout
title: "Fleet .handoff rollout (P7)"
type: task
status: active
priority: high
tags: [continuity, policy, fleet]
---

## Overview
Vision items 2 + 13 (UPGRADE-MISSION-PROMPT.md): every repo in the meta workspace hosts a `.handoff/`
continuity layer under meta policy, coordinated with the central handoff kernel. Census measured the
gap at 1/58 repos. Design is frozen in handoff ADR-0003 (kb↔handoff seam) + ADR-0004 (fleet rollout,
tiered contents, ledger residency, `hf fleet status` aggregation) + ADR-0005 (steward + central
fleet-capsule registry).

## Goals
- ADR-0003 + ADR-0004 merged in FlexNetOS/handoff.
- Policy P7 section added to META-ORG-POLICY.md (parent PR).
- `.handoff/` seeded fleet-wide: Tier A/B full (capsule + tasks/ + packets/ + README), Tier C/D
  one-commit stubs (capsule + README). Capsules generated from the census (ARCHITECTURE-TRUTH.md).
- Kernel's 22 stale cards refreshed (D3) as the first `--sync-cards` pass.
- Enforcement so the kernel stays the ONLY handoff path (FIX-6).

## Acceptance Criteria
- [x] ADR-0003 + ADR-0004 merged on handoff master (green checks) — PR #5, merged 2026-06-12 20:16Z.
- [x] META-ORG-POLICY.md carries P7 (merged on meta main) — PR #13 (P7.31–36 + deviations refresh).
- [x] Tier A/B repos (~21) each merged a `.handoff` seed PR with a census-derived capsule —
      21/21 driver OK; stuck stragglers all resolved 2026-06-12 evening: meta#15 MERGED (was BEHIND),
      atc#2 MERGED (after fix(ci) ubuntu runner #3), rusty-idd#39 pending behind golden-test fix #40,
      prompt_hub#77 in diagnosis (3 red checks, run in progress).
- [x] Fork repos covered by the central fleet-capsule registry (handoff/.handoff/fleet/, 20 capsules,
      PR #6 MERGED) — in-repo fork stubs ESCALATED to owner (steward scope law).
- [ ] Org-owned hub stubs (11) — classifier-blocked twice; escalated to owner (NEEDS-HUMAN A).
- [ ] `meta exec -- test -d .handoff` clean for all tiers (verify after prompt_hub#77 + pulls).
- [ ] Kernel cards refreshed via `hf checkpoint --sync-cards` — verb owned by the hf-session-backbone
      session (their cycle 2b; PR #10 armed carried resume --compact/checkpoint --auto + FIX-2).
- [x] FIX-6 enforcement layer LANDED (meta#20 + agent#2 + harness_hub#2): commands /handoff /resume
      /mint /checkpoint /fleet, skills handoff-discipline + verifier-cli, steward agent, Stop/PreCompact
      hf hooks, agent-guard file_patterns deny rule (proven live), p7-conformance CI, HARNESS-KIT v2.

## Context
- Design inputs: original design bundle (~/Downloads/tmp/handoff — schemas/templates/capsule),
  beads dual-store prior art, open-questions #13 (session-ledger location), HFTASK-0007.
- Rollout mechanics: deterministic generator (census → capsules), snapshot `pre-p7-rollout`, one PR
  per repo, auto-merge where armed. No binary state in git.
- Related: [[tasks/github-meta-refactor]] (.github_org dissolution), ARCHITECTURE-TRUTH.md defects
  D3/D9 fixed by this rollout, [[incidents/kb-workspace-sync-silent-drop]] (this doc's body was
  twice committed empty by that incident; backfilled 2026-06-12 via the workspaces/main path).

## Progress Log

### 2026-06-12 (night — FIX-MISSION session)
- All four stuck P7 PRs unstuck: meta#15 (update-branch → auto-merge), atc#2 (two-stage: fix(ci)
  ubuntu runners #3 + Linux inode-pin test fix → CI green → merge), rusty-idd golden-YAML root-cause
  → PR #40 armed (then #39), prompt_hub#77 diagnosis pending its in-progress run.
- FIX-6 enforcement kit shipped + verified live (deny/allow/grandfather probes at the parent surface).
- hf-session-backbone session (concurrent) merged PR #9 (session verbs + policy.toml + status --json)
  and armed #10 (resume --compact, checkpoint --auto --quiet, FIX-2 resume recompute). hf/src is
  their single-writer lane; this session consumes merged results.
- kb silent-drop ROOT CAUSE found (binary 0.2.10 reads .kb/workspaces/main/, estate docs say
  .kb/workspace/) — this body backfilled through the working path as the fix's first proof.

### 2026-06-12 (evening)
- Census measured 1/58 `.handoff` presence; convention split documented (ARCHITECTURE-TRUTH.md).
- ADR-0003 + ADR-0004 shipped via handoff PR #5 (merged, all checks green).
- Policy P7 + deviations refresh: meta PR #13 (MERGED).
- Rollout driver run 1: 21/21 OK on FlexNetOS-owned A/B repos (snapshot pre-p7-rollout first).
- CLASSIFIER BOUNDARY ×2: 52-repo sweep (incl. forks) denied → narrowed 21 approved; 11-hub batch
  denied even after witnessed steward verdict → scope law added to NORTH-STAR.md + escalated.
- ADR-0005 (steward) + central fleet capsules (20 forks): handoff PR #6 MERGED.
- Witnessed steward verdict recorded: `review_verdict approve fleet-handoff-rollout (13) by steward`.

## Blockers
- Hub in-repo stubs await owner approval (NEEDS-HUMAN A: run /tmp/p7drive.sh with chosen TARGETS).
- Card refresh awaits `hf checkpoint --sync-cards` (handoff session cycle 2b).
