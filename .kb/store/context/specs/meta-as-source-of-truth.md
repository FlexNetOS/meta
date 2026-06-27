---
id: 019e9e84-fa29-7982-bb40-202ba4c705b1
slug: context/specs/meta-as-source-of-truth
title: "Meta as Source of Truth: meta-generated CI, dashboard, and agent-env"
type: spec
status: active
priority: high
tags: [architecture, meta, ci, envctl, kasetto, spec]
resolves: context/overridable/handoff-loop
created: 2026-06-06
updated: 2026-06-12
---

# Overview (original text)

Three architecture/flow problems were raised: (1) envctl's design and its connection to meta, 
(2) the kasetto agent-env manager's design and connection to meta, (3) GitHub pipeline management 
across all meta repos. They are three faces of **one root cause**: `.meta.yaml` already holds the 
workspace's declarative truth (repos, `tags`, `depends_on`/`provides` DAG), but every consumer 
hand-rolls its own coupling to it instead of reading a shared, typed model.

This spec defines the target: **`.meta.yaml` (+ a typed workspace model) is the single source of 
truth, consumed uniformly by the dashboard, the agent-env provisioner, and a new meta-generated CI subsystem.** 

Priority order (user decision 2026-06-06): **CI first**, via a **meta-generated CI** model.

Builds on [[tasks/github-meta-refactor]] (which grounded all repos as meta peers and authored the 
reusable-CI templates, but stopped before Phase 4 — wiring CI).

---

## Status Tracking (updated 2026-06-12)

### Phase A: Dashboard (envctl)
- **Status:** ✅ Complete  
- **Evidence:** `meta dashboard` shells to `envctl dashboard --json`; envctl re-parses `.meta.yaml`. 
  The dashboards work today, though the seam is stringly-typed.

### Phase B: Agent-env Provisioning (kasetto → .meta.yaml reader)
- **Status:** ❌ Not Built  
- **Evidence:** kasetto agent-env manager works via envctl-local with `scope: project`. No meta-wide 
  fan-out from `.meta.yaml`. The kasetto vendored copy in vault_hub is the only implementation.

### Phase C: Meta-generated CI (the priority target)
- **Status:** 🟡 Partial — p7-conformance CI implemented via FIX-6 but NOT as a general-purpose generator
- **Evidence:** 
  - `p7-conformance.yml` now uses a python capsule validator + handoff-file lint (not `.meta.yaml` parsing)
  - No `.github_org/.github/workflows/reusable-*.yml` templates exist yet (were "zero callers" before)
  - The reusable workflow system needs to be built from scratch reading `.meta.yaml` as source

### Phase D: Typed Workspace Model
- **Status:** ❌ Not Built  
- **Evidence:** No typed model of `.meta.yaml` exists in any crate. Consumers parse TOML directly. 
  A shared `workspace-model` crate would resolve the stringly-typed coupling across all three consumers.

## Goals

- [x] Phase A complete (dashboard via envctl)
- [ ] Phase B: kasetto reads `.meta.yaml` instead of its own agent-skills mirror
- [ ] Phase C: Meta-generated CI that produces workflows from `.meta.yaml` source
- [ ] Phase D: Shared typed workspace model crate consumed by all three consumers

## Related Tasks

| Doc | Relationship |
|-----|--------------|
| [[tasks/gitkb-to-flexnetos-migration]] | The org migration that moved all repos to FlexNetOS enabled this spec (previously gitkb-internal) |
| [[tasks/handoff-kb-sync]] | Handoff ledger sync — the kb board tracking for this work |
| [[context/overridable/handoff-loop]] | Current handoff state — HFTASK-0011 (hf sync) will provide one-way KB mirror of this spec |

## Design Decisions Since Original Write

1. **p7-conformance CI as interim solution** — The FIX-6 handoff enforcement kit added a p7-conformance 
   check that validates the `.handoff/` directory structure via python capsule schema. This is NOT a 
   general-purpose meta-generated CI but demonstrates the pattern for Phase C.

2. **Agent-env → envctl injection seam** — Instead of having kasetto read .meta.yaml directly, the 
   owner-intent is for envctl to hold all secrets and auto-inject them. The agent-env.toml manifest 
   files (teri, etc.) are a parallel pattern that could be unified under `.meta.yaml` in Phase D.

3. **`.meta.yaml` IS the spec** — The original document raised this as an architectural gap. The gap 
   persists today: no crate, no shared type, no generated consumers. Phase D (typed model) is the 
   core missing work that unblocks everything.
