# S1 — RuVector → meta mapping (post-walk synthesis)

> Grounding files (per the initial prompt): `SESSION-HANDOFF.md`, `RUVECTOR-RESEARCH.md`,
> `STACK-INTEGRATION-PLANS.md` + `RUVECTOR-RUNBOOK.md` + ICM memoir `system-architecture` (314/314 walked).
> Target artifact: the **Ark Handoff Ledger PRD v2** (`~/Downloads/tmp/handoff/handoff`, 12-crate Rust
> workspace, spec-only/0% code). **Status: MAPPING + RECOMMENDATION ONLY — RuVector/ruflo NOT yet adopted.**

## 0. The decisive insight
The original first-implementation target — the **Ark Handoff Ledger** — is, in large part, a **from-scratch
re-implementation of capabilities RuVector already ships production-grade.** Per the user principle *"every
TS has a Rust-native replacement; prefer the crate"* (T2) and the no-rebuild instinct, S1's recommendation
flips the plan: **don't build the 12 Ark crates cold — map each need onto an existing crate + a thin glue
layer.** The Ark PRD's *contract* (state-precedence, drift sentinels, leases, evidence-backed completion,
MCP) is excellent and should be **kept as the spec**; its *engine* mostly already exists.

## 1. The three meta gaps (from STACK-INTEGRATION-PLANS) — and what now closes them
| Gap | What it is | Closed by (code-backed) |
|---|---|---|
| **#1 multiple task-truths** (weave jobs / GitKB / rusty-idd / backlog.md / prompt_hub) | no authority order | Adopt the **Ark state-precedence model** (Git > ledger > task cards > ADR > active > packet). Make **Git physical truth**, an **event ledger operational truth**, and **weave Jobs the coordination view** (not the SoT). The ledger = **RVF witness chain** (tamper-evident) or rusqlite. |
| **#2 front-door ambiguity** (vibe / job_create / meta / n8n / prompt-loop) | no single intake | One intake that mints the envelope; everything else calls it. Candidate: **prompt_hub → `hf claim`** semantics, exposed as the universal **MCP seam** (T11 — every RuVector subsystem already is an MCP server). |
| **#3 missing integration contract** (the work-order envelope) | seams unspecified | **The Ark `handoff.task.v1` schema IS the envelope** — and `ruvector-verified` + `verified-applications::AgentContract` make it a **formally provable** work order (intent/scope/acceptance **hashes** = Lean-checkable contract). |

## 2. Ark Handoff Ledger (12 crates) → RuVector mapping
Verdict legend: **ADOPT** = use RuVector crate directly · **GLUE** = thin adapter over it · **BUILD** = genuinely new (no RuVector equivalent) · **REUSE-meta** = already in our stack.

| Ark crate / need | RuVector equivalent (code-walked) | Verdict |
|---|---|---|
| `handoff-ledger` (SQLite event stream, replay) | **RVF** (`rvf-runtime` append-only segments + `rvf-crypto` WitnessChain SHAKE-256) = tamper-evident event ledger; or `ruvector-temporal-tensor` (delta-chain + WitnessEvent). sqlite is the fallback. | **ADOPT** (RVF) or GLUE |
| `handoff-drift` (objective/scope/acceptance **hashes**, drift report) | **`ruvector-perception`** (`BoundaryPredictor`, `detect_boundary`, custody `DeltaWitness`) + **`ruvector-coherence`** (`HnswHealthMonitor`, drift/`DeltaMetric`); intent-locks = blake3 hash chains (rvf already uses blake3/sha3). | **ADOPT + GLUE** |
| `handoff-policy` (hard/soft gates) | **`cognitum-gate-tilezero`** (`decide(ActionContext)→Permit/Deny/Defer` + WitnessReceipt) · `rvf-runtime` governance (Restricted/Approved/Autonomous, PolicyCheck) · `neural-trader-coherence::CoherenceGate`. | **ADOPT** |
| lease engine (`handoff-core` claim/lease/heartbeat) | **weave `weave_lease_*`** (reserve/release/sweep — ALREADY in our stack) · `rvm-cap`/`ruvix-cap` capability leases. | **REUSE-meta** (weave) |
| evidence / completion contract | **`ruvector-verified`** (Lean proof tiers, `ProofAttestation`, `VerifiedOp`) + **`verified-applications::AgentContract`** = provable evidence-backed completion. | **ADOPT** (the killer feature) |
| `handoff-mcp` (MCP bridge) | **`mcp-gate` / `mcp-brain` / `rvagent-mcp`** patterns — every subsystem already exposes MCP (T11). | **ADOPT pattern** |
| `handoff-git` (worktrees) | **meta** already has worktree mgmt (`meta worktree`) + `gix`/`git2`. | **REUSE-meta** |
| `handoff-index` (repo/dep/test/owner maps) | **GitKB** (`.kb`, `kb_symbols`/`kb_callers`) already in meta; `ruvector-graph` for the graph. | **REUSE-meta** |
| task DAG / `hf plan` | **`ruvector-dag`** (QuDAG governance DAG — staking/proposals, NOT query-plan) for governed task DAG; `petgraph` for plain. | **ADOPT** (governance) or BUILD-thin |
| routing / next-task selection | **`ruvector-domain-expansion`** (contextual-bandit/Thompson router — the runtime hot-swap selector, ≥8 consumers) → "pick highest-value safe task per context". | **ADOPT** |
| agent runtime / sub-agents / swarm | **`rvAgent`** (`rvagent-core/subagents/middleware/tools/a2a/acp/mcp/cli`) = deployed in `a2a-swarm`. Mirrors the Ark sub-agent/swarm classes 1:1. | **ADOPT** |
| `hf CLI` + `handoffd` daemon + `xtask` | thin orchestration over the above. | **BUILD-thin** |
| `handoff-test` (task-aware test runner) | thin; rtk/meta exec already run tests. | **BUILD-thin / REUSE-meta** |

**Net:** of the 12 Ark crates, ~8 have a production-grade RuVector or meta equivalent; only the **thin `hf` CLI + daemon + test-runner glue** is genuinely new.

## 3. Reconciling the provisional decisions (now research-complete)
- **Source of truth (was: weave Jobs).** *Recommend revise:* the Ark **state-precedence hierarchy is
  stronger** than "weave Jobs SoT." Adopt it: **Git = physical truth; an RVF-witnessed event ledger =
  operational truth; weave Jobs = the coordination/dispatch VIEW** (synced by `correlation_id`). This closes
  gap #1 without crowning a single mutable table. Weave stays the live mesh; it is not the memory.
- **Work-order envelope home (was: decide after spike).** *Recommend decide:* the envelope = the Ark
  **`handoff.task.v1` schema**, carried end-to-end, made **provable** by `ruvector-verified` (intent/scope/
  acceptance hashes → Lean-checkable `AgentContract`). Home it in a tiny shared crate (the `work_order` crate
  from Plan A) whose type IS `handoff.task.v1`. Closes gap #3.
- **v1 scope (was: smallest/simplest first).** *Recommend:* the smallest end-to-end is the Ark continuity
  loop **`hf resume → claim → start → checkpoint → drift → handoff`**, but built on **weave leases + RVF
  witness + a thin `hf` CLI** — NOT 12 new crates. Prove one path: `vibe "fix X"` → `handoff.task.v1`
  envelope → weave Job(view) → loop claims it (weave lease) → RVF-witnessed checkpoints → verified handoff.

## 4. Recommended v1 (the smallest real upgrade)
1. Ship the `work_order` crate = the `handoff.task.v1` schema (+ `serde`/`schemars`). *(cheap; everyone needs it)*
2. `hf`-thin CLI: `resume/claim/checkpoint/handoff` over **weave leases** (claim) + **RVF witness** (ledger)
   + **cognitum-gate/rvf-runtime governance** (policy) — adopt, don't rebuild.
3. Drift sentinel = `ruvector-perception` + blake3 intent-locks (the Ark hash model).
4. Make completion **provable**: `ruvector-verified` checks the `AgentContract` before `hf handoff`.
5. Keep the session-relay loop as the runner (it already works); `hf` replaces the narrative `HANDOFF.md`.

## 5. Open before any build (honoring "not adopted yet")
- A **spike** is still owed: confirm RVF-as-ledger ergonomics (rvf-node napi vs rusqlite) and weave-lease ↔
  Ark-lease semantic fit — both are code-present, neither is wired to `hf` yet.
- Rename the Ark package (drop **"Ark"/"V2"** placeholders → e.g. *Continuity Ledger Kernel*, v1) per the
  standing naming debt.
- Resolve the two re-explores (`todo-reexplore-b17f-exo-research`, `todo-reexplore-b17g-sevensense`) if they
  bear on adoption.
- Decide front-door (gap #2): prompt_hub-as-intake vs MCP-seam federation — not yet settled by code alone.

## 5b. RESOLVED (user notes 2026-06-09, round 2)
- **Naming:** it's the **`handoff` / `.handoff`** package (at `~/Downloads/tmp/handoff`), not yet fully
  developed. Drop "Ark"/"V2" entirely — call it the **handoff kernel** / `.handoff`. It's the `.handoff`
  design from the PRD.
- **Principle (law):** **ADOPT what is built, then add to it.** Wiring Rust crates / seams / contracts is far
  easier than building from scratch. **RuVector becomes the FOUNDATION** the meta stack adds to (not a peer).
- **Front door (gap #2) — code-found:** `RuVector/ui/ruvocal` = a **SvelteKit chat UI** (`chat-ui`) + an
  **`mcp-bridge`** subpackage + `rvf.manifest.json`. ⇒ RuVector's canonical intake is **conversational chat
  → `mcp-bridge` → MCP servers** (T11). The single front door = "chat → MCP mints the work-order," not five
  CLIs. (RuVocal = the front door candidate to adopt/extend.)
- **Ledger tech (delegated → decided):** `rvf-node` is a **napi `cdylib` (Rust→Node addon)** wrapping
  `rvf-runtime` — a *Node binding*, NOT a DB; a Rust `hf` CLI would use `rvf-runtime` or `rusqlite` directly,
  never `rvf-node`. **DECISION: v1 ledger = `rusqlite` (SQLite/WAL) + `rvf-crypto::WitnessChain`** (a
  STANDALONE crate, usable without rvf-runtime/napi) bolted on for tamper-evidence = SQL queryability + RVF-
  grade witness, Rust-native, no napi. `rvf-node` reserved as the **TS read-bridge** (RuVocal/ruflo) only.
  **Full `rvf-runtime` (RVF) = the v2 upgrade** — adopt it when semantic/vector queries over session history
  are wanted (then witness + vectors + self-boot container come free). `rvf-node` is an upgrade over rusqlite
  *only* for TS consumers / vector queries, NOT for a Rust event ledger.

## 5c. CONFIRMED (user, S2-prelude)
- **Decision #1 (ledger) APPROVED:** v1 = `rusqlite` + `rvf-crypto::WitnessChain`. **RVF vector-native
  ledger (full `rvf-runtime`) = scheduled V2 upgrade, next-priority** — rationale: the *entire* RuVector
  system is built on the vector DB, so a vector-native handoff ledger aligns the continuity layer with the
  foundation (and unlocks "find similar past task/decision" semantic recall over history).

## 5d. FRONT-DOOR MAPPING — RuVocal × prompt_hub (closes gap #2)
RuVector's UI front door must be mapped **with** prompt_hub (the meta intake). Code-truth:
- **RuVocal** (`ui/ruvocal`) = a **fork of HuggingFace Chat UI** on **pgvector = `ruvector-postgres`** + MCP
  tools + voice + brain network; its `mcp-bridge` = "routes AI tool calls to backend services with multi-
  provider chat proxy." → the **human chat surface** (already on a RuVector crate).
- **prompt_hub** (`~/Desktop/meta/prompt_hub`, Rust/axum) = `/vibe` intake → `SwarmBundle` → `dispatch`
  (dispatch is now being built — updates the old "zero outbound wiring" note). → the **canonical
  intent-intake for non-technical vibe coders** running a single-person agentic-conglomerate multi-business.

```
vibe coder ──► RuVocal chat UI ──(mcp-bridge: tool router + multi-provider proxy)──►
   (pgvector = ruvector-postgres)                                                  │
                                          ┌────────────────────────────────────────┘
                                          ▼
              prompt_hub /vibe  ─►  SwarmBundle  ─►  handoff.task.v1  ─►  (dispatch via MCP seam)
              (canonical INTAKE)              (work-order envelope: gap#2 ∩ gap#3)        │
                                                                                          ▼
              RuVector agent swarm (rvAgent / a2a-swarm) — governed by cognitum-gate,
              witnessed by RVF, tracked in the .handoff ledger ──► results back to chat
```
- **Roles:** prompt_hub = single canonical **intake**; RuVocal = its primary **UI**; CLI/n8n/meta = thin
  shims to prompt_hub (Plan C). **Key seam to build:** `SwarmBundle → handoff.task.v1` + dispatch over MCP.

## 6. One-line synthesis
**The meta autonomy stack doesn't need 12 new crates — it needs the Ark *contract* (state-precedence +
drift + provable completion) wired onto RuVector's existing engines: RVF (ledger/witness), weave (leases),
`ruvector-verified`+`AgentContract` (provable work-order), `domain-expansion` (routing), `cognitum-gate`
(policy), and `rvAgent` (runtime) — exposed through the universal MCP seam.**
