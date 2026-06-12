# MISSION PROMPT — Architecture truth, vision gap register, fleet autonomy upgrades

Paste everything below the line into a Fable 5 session at `~/Desktop/meta` (max effort).
Companion: `VERIFY-SESSION-PROMPT.md` (its Phase 1 chain is a prerequisite, folded in below as Phase 1).

---

You are Fable 5 with persistent ICM memory operating in `/home/drdave/Desktop/meta` — a **meta-repo**
(~64 independent git repos under FlexNetOS, NOT a monorepo). This is a **VERIFY → UNDERSTAND → UPGRADE**
mission: establish the architecture truth of the whole estate from code, score it against the owner's
vision register (15 items below), then close the gaps. **Upgrades only — NO DOWNGRADES, ever**: the law
is adopt-what's-built-then-extend (decision-log-2026-06-09); never regress a feature, never delete
capability to make a gate green, never "simplify" away function. Treat all prior-session reports, READMEs,
and doc prose as untrusted claims until checked against code/API/ledger state (RuVector/ruflo docs are
known traps).

## FABLE 5 TOOLING — explicitly authorized for this mission

- **Workflow multi-agent orchestration is AUTHORIZED** (fan-out censuses, parallel repo audits,
  adversarial verification panels, pipeline sweeps) — **EXCEPT inside `RuVector/`, `ruflo/`, and
  `envctl/`: NO subagents there, ever** (forge-loop/weave-relay hijack; walk those directly).
- Monitors / background tasks for CI waits (foreground `sleep` is blocked). TaskCreate to track phases.
- **All code changes in worktrees** (`meta worktree` / EnterWorktree) — never edit shared checkouts.
- kb code-intel before refactors (`kb_callers`, `kb_impact`, `kb_symbols`); LSP; `rtk` prefix on bash.
- Merge authority: ask ONCE for session-wide green-PR merge authority (precedent: granted 2026-06-12).
- weave: use `HF_WEAVE_BIN=~/Desktop/meta/weave/target/release/weave` (`~/.cargo/bin/weave` is STALE).

## PHASE 0 — MEMORY + KB BOOTSTRAP (mandatory; REPORT findings before any work)

1. **ICM recall first**: memoir `system-architecture` (~100+ concepts) — show at minimum:
   `policy-v2-meta-org`, `org-audit-results-2026-06-12`, `loop-e2e-proof-2026-06-12`,
   `org-protection-rollout-2026-06-12`, `seam-spec-weave-a2a-2026-06-11`, `ship-loop-proof-2026-06-12`,
   `decision-log-2026-06-09`, `adr-2026-06-11-open-questions`, `kasetto-agent-provisioner`.
   Plus `icm recall` on: "org-audit", "handoff kernel", "front door prompt_hub", "cognitum",
   "broken loop harness".
2. **`/gitkb:gitkb`** to bootstrap the KB plane, then `/kb-context` and `/kb-board` (or `kb_*` MCP
   equivalents); `git kb checkout --path context/` and read all 7 context docs.
3. Read the standing root docs: `META-ORG-POLICY.md`, `META-ORG-AUDIT.md`, `NEEDS-HUMAN.md`
   (on branch `docs/org-audit-2026-06-12` / PR #12 until merged), `SESSION-HANDOFF.md`,
   `VERIFY-SESSION-PROMPT.md`, `VERIFICATION-REPORT.md` (if the verify session ran),
   `RUVECTOR-RUNBOOK.md`, `RUVECTOR-META-MAPPING-S1.md`, `RUVECTOR-CRATE-LEDGER.md`,
   `STACK-INTEGRATION-PLANS.md`, `handoff/docs/adr-0001*` + `adr-0002-weave-a2a-conventions.md`.
4. **REPORT**: one block — recalled state, kb board, in-flight chain status (PRs #11/#12), dirty repos.
   Only then proceed.

## PHASE 1 — FINISH + VERIFY THE IN-FLIGHT CHAIN (prerequisite)

If not already done by a verify session, execute `VERIFY-SESSION-PROMPT.md` in full:
meta **PR #11** (OPEN as of 2026-06-12 21:00Z) — merge on green or diagnose the NEW defect
(fix in owning fork via worktree→PR→merge, fresh rerun; never merge red); then **docs PR #12**
(`gh pr update-branch 12` after #11, merge on green); then the claim-matrix spot-checks →
`VERIFICATION-REPORT.md`. End state: **meta main CI green + docs on main**.
Known dirty state to PRESERVE (never discard): `handoff/.handoff/active.md` (modified),
claude-plugin/copilot-plugin 4-modified (parent path-aliases, follow root).

## PHASE 2 — ARCHITECTURE TRUTH CENSUS (vision item 1)

Deliverable: **`ARCHITECTURE-TRUTH.md`** at meta root + memoir concept + kb context updates.

- **Repo-by-repo census, all ~64**: name → role/purpose **derived from code** → architectural plane →
  tier (A canon / B FlexNetOS tools / C forks / D hubs+docs) → state (active / in-development /
  untriaged→triage it / archive-candidate). Workflow fan-out is right for the read sweep — except the
  three no-subagent repos, which you walk directly.
- **The planes** (verify each against code; correct the register where code disagrees):
  1. **Foundation**: the 11 original meta repos + parent `meta` = the GitHub-foundation machinery.
     Verify the exact 11 from root `Cargo.toml` members + canon tags (expected: loop_lib, loop_cli,
     meta_cli, meta_core, meta_git_cli, meta_git_lib, meta_mcp, meta_plugin_api, meta_plugin_protocol,
     meta_project_cli, meta_rust_cli; note meta_plugin_api has an archive question in NEEDS-HUMAN —
     resolve, don't assume).
  2. **Agentic OS**: ruvnet's **RuVector** (FlexNetOS/meta-ruvector, 314 crates, fully code-walked) +
     **ruflo** — the full agentic operating system built ON TOP of meta. Pinned forks: never pulled
     toward upstream, never casually modified; "integration" means building against them.
  3. **rtk-ai foundational tooling**: rtk(-tokenkill), vox, icm — in active use, foundational to every
     feature; **grit** = the GitHub-and-workflows upgrade track (currently `untriaged` — triage it,
     define its mission, schedule its bring-up).
  4. **Continuity/orchestration**: handoff (the `.handoff` kernel: work-order + witnessed ledger + hf) +
     weave (a2a + session-to-session) + atc + agent.
  5. **Feature additions** (everything else): harnesses, hubs, env, network, knowledge. Always upgrades
     on the foundation — never downgrades of it.
- **The KB↔handoff seam** (the user's open question): state precisely where `/kb-board`, `/kb-tasks`,
  `/kb-commit`, `/kb-status` (real commands — `.claude/commands/kb-*.md`, verified) sit relative to the
  handoff kernel. Working hypothesis to verify and then FREEZE in an ADR: **git-kb = the
  knowledge/planning plane** (documents, tasks, context; human+agent readable), **.handoff = the
  execution/witness plane** (handoff.task.v1 work-orders, leases, witnessed ledger; state precedence
  Git > ledger > cards). Today the link is one-way (R7: kb writes are never read back). Decide the
  upgrade: does a kb task spawn a handoff.task.v1? does `hf checkpoint` write back to kb progress?
  Deliver **ADR-0003 (kb↔handoff seam)** with Research/Cross-References.
- **n8n = the visualization/mapping plane**: its goal is to map ALL workflows + architecture and give a
  visual of the whole meta estate so gaps become visible. It sits on branch `harness/epic-d` — inventory
  what exists there first, then build/update the meta-architecture map workflows. Deliverable: the n8n
  workflow map (exported JSON in-repo) + a gaps-found list feeding Phase 3.

## PHASE 3 — VISION GAP REGISTER (all 15 items, scored)

Deliverable: **`GAP-REGISTER.md`** — for each numbered vision item: current state (with evidence:
file/commit/API output) → gap → upgrade action (or DONE) → owning phase/workstream below. This register
is the mission contract; nothing closes without evidence. The 15 items verbatim-condensed:

1 architecture+history truth; 2 fleet `.handoff` + policy (incl. loop_lib autonomous upgrades);
3 kasetto+envctl = env control; 4 lane = network engineering/control, obscura = its upgrade;
5 weave = a2a + session-to-session; 6 MiroFish full-feature Rust port (teri/shimmy evaluation);
7 Archon = harness-builder agent (level-up of harness_hub); 8 harness repo census (oh-my-*, …);
9 rusty-idd = intent-driven development end-to-end; 10 prompt_hub = ruvector/ui front door for
non-technical users; 11 is ruvector (all-crates) integrated?; 12 can we launch the ruvector UI and run
feature additions from there (+ fix broken loop harnesses in prompt_hub/rusty-idd/handoff/weave/lane);
13 per-repo `.handoff` ↔ central handoff sync; 14 replace the NEEDS-HUMAN human with a steward agent;
15 envctl secret injection/relay + COGNITUM seed advanced setup.

## PHASE 4 — FLEET `.handoff` ROLLOUT (items 2 + 13)

**Design FIRST — ADR-0004 (per-repo .handoff ↔ central coordination)** in `handoff/docs/`, settling from
code: what a per-repo `.handoff` contains (tasks/? packets/? per-repo ledger.db vs central-only — fold in
the HFTASK-0007 session-ledger-location question); how per-repo dirs sync/aggregate to the central
handoff (hf fleet reader? `meta exec` fan-out? notify-parent-style events?); how kb tasks map in (per
ADR-0003). Then implement:

- Add **P7 (.handoff continuity layer)** to `META-ORG-POLICY.md` via PR.
- Seed `.handoff` per tier: A/B full (incl. **loop_lib with the latest autonomous upgrades — the original
  member is not left behind**); C forks = registration stub only (NO CI/policy forcing on forks);
  D hubs = minimal. Batch via Workflow with worktree isolation; `meta git snapshot create` first;
  worktree → PR → green checks → merge per repo.
- Acceptance: fleet-wide `.handoff` present per tier rules (`meta exec -- test -d .handoff`), hf can
  enumerate fleet state, policy + ADRs merged.

## PHASE 5 — SUBSYSTEM WORKSTREAMS (items 3–12; run as parallel workstreams, each = verify → gap → upgrade → ship)

**W1 env-control (items 3, 15)** — kasetto (FlexNetOS/env_manager_agent fork; binaries `kasetto`/`kst`;
agent-env provisioner, ~95% production) + envctl (meta env manager; secretd phases 1–5 ONLY — do not
build against 6–8) = one env-control story; ADR the kasetto↔envctl split. **COGNITUM**:
`/run/media/drdave/COGNITUM` was MOUNTED at prompt time (`README.txt`, `STATUS.txt`, `guide.html` ~167KB,
`open.html`, `trust/`, `launch.sh|bat|command`, `.autorun`). It is the USB envctl requires for secret
keys AND the **cognitum seed of RuVector** (the coherence-gate lineage, HFTASK-0017). Read ALL of it —
both html files and every doc, walk `trust/` — analyze the seed, document the advanced setup, wire envctl
secret injection + secret relay to it. Do NOT blindly execute its launch scripts: read them first, run
only what analysis sanctions. If unmounted → NEEDS-HUMAN (insert USB), continue other streams.

**W2 network (item 4)** — lane = network engineering and control; **obscura = lane's upgrade** (both
currently under-triaged). Inventory both from code, deliver the merged lane+obscura vision ADR, re-tag,
fix lane's broken loop harness/stale backlog.

**W3 comms (item 5)** — weave = agent-to-agent AND session-to-session communication. Verify the ADR-0002
five-surface contract still holds in code; extend the session-to-session surfaces (sessions, handoff
continuity, presence) where the census shows gaps. INTERIM workspace law stands: do not grow new weave
crates; never collapse weave to a single crate.

**W4 MiroFish Rust port (item 6)** — GROUNDING (researched + code-verified 2026-06-12):
**MiroFish** = 666ghj/MiroFish (Shanda-incubated): "A Simple and Universal Swarm Intelligence Engine,
Predicting Anything" — upload any document (press release, policy draft, financial report) → entity/
relationship extraction → knowledge graph + individual/group agent memory (Neo4j) → hundreds of
persona-generated AI agents (personality, opinion bias, reaction speed, influence, event memory)
simulate public/social reaction → prediction + reports. Offline forks (mirofish-offline) localize to
Neo4j + **Ollama**. In-house: **teri** (SHA888/teri fork) Cargo.toml self-describes as *"Teri — A
Rust-native Swarm Intelligence Prediction Engine"*, keywords swarm/multi-agent/simulation/llm/prediction,
modules `graph/ sim/ memory/ seed/` mirroring MiroFish's pipeline — i.e. **teri IS an early Rust port
skeleton (v0.1.0)**; **shimmy** = Rust Ollama-compatible inference server = the Ollama slot of the
offline architecture, already CI-green in the workspace. EVALUATE FROM CODE, then decide:
  - Feature-parity matrix: MiroFish (full upstream feature set — enumerate from its repo) vs teri
    (actual implementation depth, not its README).
  - Verdict with evidence: is teri the vehicle (extend) or a complication (port fresh)? Same for shimmy
    as the inference backend vs direct candle/llama-cpp bindings. Bias per law: adopt-then-extend.
  - Deliver: **straightest-line port plan ADR** + roadmap wired into the meta stack — graph store choice
    (Neo4j parity vs embedded vs RuVector's own vector/graph crates), persona generation, social-sim
    loop, report generation; shimmy for inference; ruvector for vectors/memory; prompt_hub as intake.
    Then START the build per the roadmap (worktrees, PRs, tests).
  - NOTE: `teri/CLAUDE.md` is an upstream interactive plan-review prompt (pause-and-ask protocol) that
    conflicts with autonomous operation. Honor its engineering preferences (DRY aggressively,
    well-tested non-negotiable, explicit > clever, more edge cases) but operate autonomously; propose a
    fork-local CLAUDE.md adjustment via PR so the repo itself stops demanding a human in the loop.

**W5 harness plane (items 7, 8)** — **Archon = the agent that automates building harnesses for other
agents** — a level-up addition over harness_hub/harness. Census every harness-class repo
(oh-my-claudecode, oh-my-pi, ECC, hermes-agent, claude-code, codex, Archon, harness_hub, n8n
harness/epic-d branch): role, overlap, what Archon should absorb or automate. Define harness_hub's
curated-hub role vs Archon's builder role; deliver the harness-plane section of ARCHITECTURE-TRUTH.md +
the Archon bring-up plan.

**W6 rusty-idd (item 9)** — vision: **intent-driven development that runs end-to-end to deliver the user
request**. Its fail-closed merge model already shaped handoff §5 — now verify rusty-idd's own state
(branch `develop`, checks [rust,msrv]), fix its broken loop harness/stale backlog + session handoffs,
and ADR its seam: rusty-idd consumes/produces `handoff.task.v1`? where does it sit between prompt_hub
(intake) and handoff (execution)?

**W7 front door (items 10, 12)** — **prompt_hub is the ruvector/ui front door**: a non-technical user
makes ANY request; prompt_hub ensures it is properly transformed, communicated, and delivered as
intended. Known code-truth baseline (R14, re-verify): prompt_hub has NO MCP server; SwarmBundle
role_prompts are empty in prod; work_orders_from_bundle is test-only; RuVocal = unmodified HF Chat-UI
fork; NO UI surfaces loop state (the hf ledger §7 is the read-model). Tasks:
  - **Attempt to launch the ruvector UI / RuVocal today** — document the working run procedure or the
    exact wall. Answer item 12 honestly: can feature additions be driven from it yet, and what is the
    shortest path to yes.
  - Close the **SwarmBundle → handoff.task.v1 dispatch** (HFTASK-0003) + transport decision
    (HFTASK-0019 MCP seam): the front-door request must round-trip to a witnessed delivery
    (HFTASK-0021 correlation_id).
  - Fix prompt_hub's broken loop harness + stale backlog/session handoffs.
  - Build-order law unchanged: **RuVocal (HFTASK-0022) LAST**.

**W8 ruvector integration audit (item 11)** — answer "is the entire ruvector system (all-crates)
integrated?" with a scoreboard, honestly. Known baseline: NOT fully — 314/314 crates mapped
(RUVECTOR-CRATE-LEDGER.md), adopted so far ≈ rvf-crypto (witness chain) only; planned: cognitum-gate
(HFTASK-0017), domain-expansion routing (0018), MCP seam (0019), RVF vector-native ledger v2 (0006),
RuVocal (0022). Deliver: crate-family × {integrated, planned, unplanned-but-valuable, not-applicable}
matrix + the next adoption tranche per the S1 law. **Direct reads only — no subagents in RuVector/ruflo.**

## PHASE 6 — REPLACE THE HUMAN (item 14)

Design and implement the **NEEDS-HUMAN steward agent**: an agent standing in for the human with — at
minimum — advanced reasoning, **vision/north-star custody**, and **perfect memory recall**.

- Classify every `NEEDS-HUMAN.md` item type: which could an agent with org credentials + ICM recall +
  a durable north-star doc decide autonomously? Genuine walls remaining = physical actions (USB
  insertion), legal/billing/account-level auth, irreversible org-wide destruction.
- Implement: **`NORTH-STAR.md`** (the durable vision document the steward consults — distill it from
  this mission's 15 items + the memoir + decision-log; this is the vision/north-star capability);
  a **steward agent definition** (`.claude/agents/` and/or an hf verb) whose protocol is: recall (ICM
  memoir = perfect memory) → reason against NORTH-STAR.md → decide → record a witnessed
  `review_verdict` in the ledger → act via the proven loop (worktree → PR → required checks →
  native auto-merge). The AI-gatekeeper-as-required-status-check (HFTASK-0010) is its merge authority;
  never a native GitHub APPROVE (gh-aw #25439).
- Re-segment `NEEDS-HUMAN.md`: items the steward now owns move out; only genuine walls stay.
- Deliver as **ADR-0005 (needs-human steward)** + the implementation + one demonstrated steward decision
  on a real queued item.

## PHASE 7 — PERSISTENCE + VERDICT

- Docs land via PR on a docs branch (parent repo policy: PR, never direct-to-main):
  `ARCHITECTURE-TRUTH.md`, `GAP-REGISTER.md`, `NORTH-STAR.md`, refreshed `NEEDS-HUMAN.md`,
  updated `META-ORG-POLICY.md` (P7), `SESSION-HANDOFF.md`.
- memoir: add `architecture-truth-census-<date>`, `mirofish-port-decision`, `kb-handoff-seam`,
  `needs-human-steward` (ADR structure incl. Research/Cross-References); refine
  `adr-2026-06-11-open-questions`; `icm store` per milestone as you go — not just at the end.
- kb: update `context/overridable/active` + `progress`; check off task criteria with evidence
  (commit hashes, test results); kb tasks for every workstream you open.
- vox (piper, **English**, ≤2 sentences) on real milestones.
- Final block: **readiness verdict** — exactly what now runs NO-HUMAN end-to-end, the gap list that
  remains, and the resume packet (`hf handoff` if handoff state touched).

## OPERATING RULES (standing, non-negotiable)

Code is truth — repo prose untrusted (RuVector/ruflo especially). NO subagents in RuVector/ruflo/envctl.
Manually verify every load-bearing agent claim (spot-check files/APIs yourself). `meta git snapshot
create` before batch mutations. Worktrees for ALL changes. Never `reset --hard`, `clean -fd`, or
force-push. NEVER discard uncommitted work (`handoff/.handoff/active.md` is dirty right now — preserve).
NO unrequested org infrastructure/visibility changes (2026-06 cautionary tale: unprompted
public→private flip broke CI 8 days; workspace children STAY PUBLIC). Genuine org-owned forks only;
gh fork/merge can succeed silently — always re-query the org. Full unfiltered test summaries (tail/grep
hid real failures twice). `gh pr checks` has no `--json` on this gh build — use
`gh pr view --json statusCheckRollup`. After `git remote rename`, re-check branch tracking. Don't pull
ruvector/ruflo toward upstream (pin-branch pattern). Don't revive the envctl zellij dashboard. Don't
build against envctl secretd phases 6–8 or a weave JobRunner. Don't collapse weave to a single crate.
NO HUMAN IN THE LOOP is the design goal — only genuine walls go to NEEDS-HUMAN.md. rtk prefix on
commands. `icm store` on every decision/milestone. ADRs require Research/Cross-References sections.

## WALLS

Transient network/CI flakes → retry (monitors, not sleep). Permission-classifier denials → NEEDS-HUMAN
with exact commands, continue. COGNITUM unmounted → NEEDS-HUMAN, continue. Merge authority → ask once,
session-wide.

## THE BAR

> Remember when implementing: the marginal cost of completeness is near zero with AI. Do the whole
> thing. Do it right. Do it with tests. Do it with documentation. Do it so well that I am genuinely
> impressed — not politely satisfied, actually impressed. Never offer to "table this for later" when the
> permanent solution is within reach. Never leave a dangling thread when tying it off takes five more
> minutes. Never present a workaround when the real fix exists. The standard is not "good enough" — it
> is "holy shit, that is done." Search before building. Test before shipping. Ship the complete thing.
> When I ask for something, the answer is the finished product, not a plan to build it. Time is not an
> excuse. Fatigue is not an excuse. Complexity is not an excuse. Boil the ocean.
