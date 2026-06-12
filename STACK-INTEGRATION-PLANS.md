# Stack Integration — Three Plans (pre-implementation)

> Authored 2026-06-09. Companion to ICM memoir `system-architecture` (23 concepts).
> Goal: fully automated dev stack + GitHub, agentic, no-human-in-the-loop.
> Status: **planning only — do not implement until a plan is chosen.**

## What we verified (the ground truth)

The stack is **not a pipeline** — it's independent, mostly-Rust tools that integrate only
through two substrates: (1) the **weave mesh** (live coordination), and (2) **committed
files on disk** (durable truth: `HANDOFF.md`, lock files, backlogs). No tool calls another
in code today. None of the projects are finished; they were built in parallel, which is
*why* there are multiple front doors and competing task stores.

**Completion state (evidence-based):**

| Tool | State | Build contracts against it? |
|---|---|---|
| kasetto | ~95%, v3.0.0, production | ✅ yes — most-done |
| weave v0.2 **core** | done + 38 tests (messages/jobs/peers/asks/presence) | ✅ yes |
| weave **autonomous dispatch** | ❌ does not exist (poll-only; JobRunner deferred) | ⛔ no |
| prompt_hub **core** | ~85%, 724 tests (vibe/get/SwarmBundle/search/HTTP) | ✅ yes |
| prompt_hub **dispatch** | ❌ SwarmBundle struct has zero outbound wiring | ⛔ must build |
| obscura | complete Rust headless browser + obscura-mcp | ✅ ready (unwired) |
| envctl env-manager (ph 0–5) | ~90% | ✅ yes |
| envctl secrets daemon (ph 6–8) | ~30%, 15+ `todo!()`, server-mode CRITICAL | ⛔ no |
| rusty-idd | ~85% (real repo: `~/Desktop/idd-merge-idd`) | ✅ mostly |
| n8n-loop harness | ~60%, no proven end-to-end cycle | ⚠️ unproven |

## The real blocker (autonomy unlock)

Full autonomy is **not** blocked on building more tools. It's blocked on **three missing
connectors** that live in the gaps:

1. **prompt_hub → dispatch**: no `export` from `SwarmBundle` to anything actionable.
2. **weave → autonomous run**: jobs are poll-only; no JobRunner that claims + spawns.
3. **the contract**: no work-order envelope spanning `prompt_hub → rusty-idd → weave → agent`.

> Autonomy *already exists* via the file-based **session-relay loop** (fresh session resumes
> `HANDOFF.md`, works the backlog, hands off at `cycle_budget`). weave is coordination
> **on top of** that loop, not the dispatcher. **Every plan below must integrate with the
> existing loop, not replace it.**

These three plans reach the same destination in different orders. They are **not mutually
exclusive** — they are three entry points to the same triangle: **envelope + store + door.**

---

## Plan A — Contract-first

**Bet:** define ONE work-order envelope (WOE) and retrofit every tool to read/write it.

**Work-Order Envelope (proposed):**
```jsonc
{
  "woe_version": 1,
  "id": "woe_<ulid>",
  "intent": "natural-language ask",
  "role": "rust-implementer",          // maps to prompt_hub Role
  "origin": "prompt_hub|n8n|cron|meta", // which door minted it
  "plan_ref": "idd:AI_MERGE/07_tasks/..", // rusty-idd slice (optional)
  "weave_job_id": "job_...",            // coordination handle
  "acceptance": ["criterion", ...],
  "guards": { "budget_usd": 5.0, "rbac_role": "...", "apply_mode": true },
  "state": "draft|queued|running|done|failed|needs-human",
  "artifacts": [{ "kind": "pr", "ref": "..." }],
  "handoff_ref": "_workspace/HANDOFF.md#next_item"
}
```
**Sequence:** (1) ship a tiny shared Rust crate `work_order` in meta; (2) prompt_hub
`export_work_order()` (SwarmBundle → WOE); (3) weave ingests WOE as a `Job`
(`correlation_id` = WOE id, body in `result_json`/new column); (4) rusty-idd emits a WOE per
task; (5) the session-relay loop reads/writes WOE state.

- **Pros:** every future seam becomes trivial; structurally dissolves gap #1 (truth) and #2
  (door) as side effects; the schema is the single thing everyone agrees on.
- **Cons:** slowest to first value; touches every repo; risk of over-designing against
  still-incomplete endpoints.
- **First value:** ~when step 3 lands (prompt_hub can mint a job weave/loop can run).

## Plan B — Source-of-truth-first

**Bet:** crown weave `jobs` as the single authoritative task store; everything syncs to it.

weave `Job` already has what a task store needs: `state` machine, `attempt_id` fencing,
`correlation_id` (external ref), `result_json`, `artifacts_json`, cooperative cancel.

**Sequence:** (1) define Job conventions (`kind`, `correlation_id` namespace per source);
(2) prompt_hub creates a Job on dispatch; (3) rusty-idd emits one Job per task slice;
(4) GitKB tasks + `backlog.md` become **views** that sync to Jobs via `correlation_id`;
(5) the session-relay loop reads `next_item` from weave Jobs instead of `backlog.md`.

- **Pros:** fastest route to "agents agree on what's done" — attacks the **highest-leverage**
  gap (#1) directly; reuses weave's existing fencing/state; minimal new schema.
- **Cons:** weave has no autonomous dispatch, so the **loop stays the runner** (fine — that's
  current reality); couples task truth to weave (still incomplete on dispatch); doesn't make
  a single front door by itself.
- **First value:** fast — as soon as the loop reads from weave Jobs.

## Plan C — Front-door-first

**Bet:** make prompt_hub the single canonical intake; other doors become thin shims.

**Sequence:** (1) build prompt_hub's missing outbound (`SwarmBundle → weave Job(s)` — this is
missing-seam #1); (2) point n8n triggers / cron / `meta` at prompt_hub `/vibe`;
(3) demote `/prompt-loop` + direct `weave job_create` to shims that call prompt_hub.

- **Pros:** gives prompt_hub the role it's missing; "one place to put intent"; attacks gap #2.
- **Cons:** requires building the prompt_hub→weave seam anyway; needs the other doors to
  *actually* defer (org discipline, not just code); doesn't fix task-truth (#1) on its own.
- **First value:** medium — after the export seam + first shim.

---

## Recommendation

The three plans share a core: **the envelope, the store, and the door are one triangle.**
The only real decision is the **first move**, and completion-state points to a clear answer:

> **Start with B's spine using A's envelope, and C falls out.**
>
> 1. Ship the **tiny** `work_order` envelope (A, step 1) — it's cheap and everyone needs it.
> 2. Carry it as a **weave Job** and make weave Jobs the **source of truth** (B) — weave is
>    the most-complete coordination primitive and already has `correlation_id`/state/fencing.
> 3. Build the **two missing connectors**: `prompt_hub → WOE → weave Job` (which *also* makes
>    prompt_hub the canonical door — C, for free) and teach the **session-relay loop** to
>    read/write WOE state on Jobs (so the existing autonomy keeps working).
> 4. **Defer** weave's JobRunner (autonomous spawn) and obscura wiring — not needed for v1;
>    the loop is the runner.

This gives fast value (B), avoids over-design (A kept minimal), and yields a single front
door (C) as a side effect — without depending on anything in the "not ready" column.

## Open decisions before implementation
- **Authoritative store:** weave Jobs (recommended) vs GitKB vs a new ledger?
- **Envelope home:** new `work_order` crate vs extend weave `Job` schema directly?
- **Loop integration:** does the loop poll weave Jobs, or does weave notify the loop?
- **Scope of v1:** which single end-to-end path to prove first (e.g. `vibe "fix X"` → Job →
  loop builds → PR)?

---

# Research Log — Round 2 (2026-06-09): envctl, meta canon, handoff

> No execution yet. ruvector/ruflo is the **next** task, not this one.

## Provisional decisions (user)
- **Source of truth = weave Jobs** is the easy first pick — but **confirm only after** research
  rules out missed pieces.
- **Envelope home = decide after a spike** (prototype, don't commit).
- **v1 scope = deferred**; instinct = **smallest/simplest upgrade first**.

## The meta architecture canon (the yardstick)
10 original repos: `loop_lib`, `meta_plugin_protocol`, `meta_plugin_api` (legacy stub),
`meta_core` (sparse), `meta_git_lib`, `loop_cli`, `meta_cli` (mature host),
`meta_git_cli`/`meta_project_cli`/`meta_rust_cli` (plugins). A compliant member:
separate git repo under FlexNetOS/ · registered in `.meta.yaml` · subprocess plugin if it
exposes commands (binary `meta-*`, `PluginRequest → ExecutionPlan`, `--json/--dry-run/--parallel`)
· `RUST_LOG` target = crate name · `.kb/` knowledge base · cross-repo via `loop_lib`.

## envctl — merge done, cleanup + realignment owed
- **Merge:** structurally complete (env-ctl secrets crates folded into envctl; old repo trashed).
- **Retire the `env-ctl` name** — still lingers in: `$SECRETCTL_SOCK=.../env-ctl/control.sock`
  (`~/.bashrc:161`), `manifest/env-ctl.toml`, systemd `env-ctl.service`,
  `~/.local/{share,state}/env-ctl`, docs/backlog. → rename to `secretd`/`secrets`.
- **Drift from canon:** no `.kb/` (uses `docs/`); built its own harness; **poor handoff**
  (narrative "paste this file", mixes architecture+checkpoint, duplicated, no parseable
  resume schema, no weave heartbeat). Correctly *not* a plugin (standalone tool).
- **Realign tasks:** retire name → add `.kb/context/` → adopt structured session-relay
  HANDOFF schema + weave heartbeat.

## New handoff package (`~/Downloads/tmp/handoff`) — strong design, not ready
- **"Ark Handoff Ledger PRD V2"** — **spec only, 0% code** (~15–25 wks to MVP; 12-crate design).
- **Design** (beats HANDOFF.md): SQLite **event ledger** + **state-precedence hierarchy**
  (Git > ledger.db > task cards > ADRs > active.md > packets) + **drift sentinels** +
  **lease transactions** (atomic claim/release) + policy gates + `hf` CLI.
- **Rename before adoption:** drop **"Ark"** (placeholder) and **"V2"** (no prior version) →
  e.g. *Continuity Ledger Kernel*, `v2`→`v1`.
- **Bearing on the plans:** this is a candidate upgrade for the *committed-files* substrate
  (the handoff/continuity layer the autonomy loop depends on). Keep on the radar; it's a
  parallel track to the weave-Jobs source-of-truth work, not a blocker for it.

## Next research task (separate): ruvector / ruflo
Deferred to the next session/task per user. Largest remaining unknown.
