# ARCHITECTURE-TRUTH — the meta estate from code (2026-06-12)

**Method:** read-only census of all workspace repos (58 by fan-out workflow `wf_a40b236a`, one agent per
repo; RuVector/ruflo/envctl walked directly per the no-subagent rule; parent assessed from its own tree).
Roles derived from manifests/src/commits, NOT READMEs; every load-bearing claim spot-verified by hand
(obscura, claude-plugins, vault_hub, handoff cards). Prior prose treated as claims.
**Companions:** META-ORG-POLICY.md · META-ORG-AUDIT.md · VERIFICATION-REPORT.md · GAP-REGISTER.md ·
RUVECTOR-RUNBOOK.md (314-crate walk) · RUVECTOR-META-MAPPING-S1.md.

## Verdict snapshot

- **62 units censused** (58 fan-out + parent + RuVector + ruflo + envctl). States: 40 active,
  12 empty-or-stub (husks), 5 in-development, 1 stale.
- **`.handoff/` exists in exactly 1 of 58 repos** (handoff itself) — vision item 2's fleet rollout is a
  total-greenfield gap (Phase 4).
- **Loop harnesses found in 8 repos**, none broken mid-flight: weave (reconciled, 31 cycles),
  prompt_hub (`_workspace/` cycle 82, coherent), rusty-idd (ralph loop, 25 cycles to backlog-clear),
  lane (TERMINAL DONE 2026-06-05 after 11 PRs), n8n (deliberate stand-down, 15/16 done, D-1 blocked on
  user docker), ECC (`_workspace/` documents envctl/meta work, LOOP COMPLETE), .github_org (`/wrap-up`
  through SESSION-2026-05-29-015), handoff (live kernel — but all 22 task cards stale, see Defects).
  Only **lifeos** is genuinely broken-or-stale (HANDOFF.md points at dead `~/repos/ubuntu-lifeos`).
- Loop-state convention is split: `_workspace/` (weave, prompt_hub, ECC, n8n, rusty-idd) vs `.handoff/`
  (handoff) vs ad-hoc (`.lane-loop/`, `/wrap-up`). ADR-0004 must unify (Phase 4).

## The five planes (verified against code)

### 1 — Foundation: the 11 originals + parent
`loop_lib, loop_cli, meta_cli, meta_core, meta_git_cli, meta_git_lib, meta_mcp, meta_plugin_api,
meta_plugin_protocol, meta_project_cli, meta_rust_cli` + parent `meta` (+ `meta_dashboard_cli` as the
A2 mission-control surface, runtime-coupled to envctl on PATH, deliberately Cargo-standalone).
- Lineage truth: harmony-labs → gitkb → FlexNetOS (Matt Walters authorship), now fully org-owned with
  origin-only remotes; the gitkb org is dead.
- The plugin-host pattern (plugins plan, loop_lib executes) + notify-parent/notify-downstream dispatch
  graph = the GitHub-foundation machinery. Parent is the policy exemplar (POLICY v2).
- `meta_plugin_api` is a legacy dylib-style ABI superseded by the subprocess protocol — zero reverse
  deps, archive question open (NEEDS-HUMAN #4).
- Shared gap: **no canon member has a README** (policy P5 hygiene item).

### 2 — Agentic OS: RuVector + ruflo (ruvnet lineage, pinned forks)
- **RuVector** (`FlexNetOS/meta-ruvector`, dir `RuVector/`): 314 crates, fully code-walked
  (RUVECTOR-CRATE-LEDGER.md). The live agentic pipeline: data feeders → discovery agents
  (boundary/consciousness families = perception + Φ) → aggregation (train-discoveries/mcp-brain) →
  orchestration (a2a-swarm = rvAgent/A2A; verified-applications = provable AgentContracts) → edge fleet
  (cloud→desktop→browser→P2P→ESP32), governed by the **cognitum coherence gate**, witnessed via RVF.
  Docs are deliberate traps; code is truth.
- **ruflo** (`FlexNetOS/ruflo`): genuine org fork of ruvnet/ruflo; local main intentionally behind
  (pin-branch `pin-meta-2026-06-12` @ dfe1b9cf9 records the drift point).
- Only live meta→RuVector code edge today: `handoff/ledger` → `rvf-crypto` (witness chain). Everything
  else is mapped-not-adopted (W8 scoreboard).
- Law: never pulled toward upstream; integration = building against them.

### 3 — rtk-ai foundational tooling
- **rtk-tokenkill** (fork of rtk-ai/rtk): the token-filter proxy, in use on every shell command.
- **icm** (fork of rtk-ai/icm): persistent memory (SQLite + BM25/vector recall) — this mission's memory.
- **vox** (fork of rtk-ai/vox): TTS w/ six backends; org fork carries the English-defaults patch (#1).
- **grit** (fork of rtk-ai/grit): **function-level (AST) lock coordinator letting many parallel AI
  agents edit one codebase without merge conflicts.** Code-truth nuance vs the vision register ("grit
  upgrades GitHub + workflows"): grit's locks are the *enabler* for multi-agent GitHub workflows; the
  GitHub/workflow upgrade mission needs its own bring-up plan (GAP-REGISTER #G-grit). Untriaged tag is
  wrong → re-tag `[tools, ai, concurrency]`.

### 4 — Continuity / orchestration
- **handoff** (B, the kernel): work-order (`handoff.task.v1` + IntentLock) + ledger (rusqlite WAL +
  rvf-crypto WitnessChain) + `hf` CLI (claim/checkpoint/ship/review-verdict/resume). The proven
  autonomous loop (PR#3/#4 native auto-merge, 16-event verified chain). Builds only with sibling
  RuVector checkout. **All 22 task cards stale at `backlog` with dead `spike/**` path_scopes** —
  git>ledger>cards precedence covers correctness, but the planning surface lies (Defect D3).
- **weave** (B): a2a + session mesh — identity/leases/jobs/messaging/out-of-band verdicts (ADR-0002
  five-surface contract). Interim 4-crate workspace by decision (WL-043 collapse deferred).
- **atc** (C→B-ish): headless agent dispatcher (worktrees, 6-signal health, SQLite registry, tmux) from
  the gitkb era — overlaps handoff/weave; seam decision needed (GAP-REGISTER). Its PR runs end
  `action_required` (NEEDS-HUMAN #7) — autonomy wall.
- **rusty-idd** (B): intent-driven-development merge control plane; fail-closed merge model already
  adopted by handoff §5. Ralph loop ran 25 cycles to backlog-clear; residue: CLAUDE.md references
  missing `scripts/ralph-idd.sh`; superseded NEEDS-HUMAN/HANDOFF.md need refresh.

### 5 — Feature additions (upgrades on the foundation)
- **Swarm/prediction (the MiroFish track):** **teri** = Rust-native swarm-prediction engine — census
  independently confirmed "a rewrite of Python MiroFish": seed docs → petgraph knowledge graph →
  persona agents → sim. **shimmy** = local inference server speaking OpenAI/Ollama/Anthropic APIs
  (the Ollama slot of offline-MiroFish). Both workspace members, CI-green. W4 owns the parity matrix.
- **Front door:** **prompt_hub** (B): 3-crate Rust workspace (core/CLI/axum server), 1085 tests,
  cycle-82 loop state coherent — but **zero MCP server, zero outbound dispatch** (both sides of the
  front-door seam unbuilt: HFTASK-0003/0019). Identity drift: README/Cargo claim `github.com/prompthub`
  + crates.io that don't match any remote. RuVocal (inside RuVector) = unmodified HF Chat-UI fork,
  build-order LAST (HFTASK-0022).
- **Env-control:** **envctl** (B, walked directly): meta env manager — env injection, secretd
  (phases 1–5 sanctioned), kasetto agent-env seam already live one-way (`manifest/agent-env.toml`
  sync --locked CI gate), USB secret-key vault; zellij dashboard = dead end (do not revive).
  **kasetto** (C, fork of pivoshenko/kasetto via FlexNetOS/env_manager_agent): declarative agent-asset
  provisioner (bins `kasetto`/`kst`); fork at 3.0.0 vs installed 3.1.0; release workflows wired to
  upstream secrets (inert in fork).
- **Network:** **lane** (B): TLS-terminating local-domain reverse proxy (myapp.test → ports) PLUS the
  full W2 network plane — governed web egress (`lane web`: a GovernedProxy with deny-by-default
  webpolicy, upstream chaining, optional path-level TLS-MITM) and the cross-machine **lane relay**
  (iroh p2p, governance-across-the-link; ADR-0002 IMPLEMENTED). **obscura** (B, was C): **headless
  browser engine in Rust** (8 crates: dom/net/browser/cdp/js/mcp/cli + core; real V8; CDP;
  Puppeteer/Playwright drop-in) — lane's web-access upgrade, now ESTATE-INTEGRATED (build/test green,
  custom-CA trust, lane↔obscura seam ADR-0001, MCP verified, network_hub-registered). network_hub =
  obscura registered (was empty).
- **Harness plane (10):** Archon (Bun/TS DAG workflow engine for coding agents — the harness-builder
  candidate, pure tracking fork today), ECC (multi-harness agent OS + Rust TUI), agent (guard/score/
  codex hooks — load-bearing as parent's PreToolUse guard), claude-code (vendor reference fork),
  claude-plugins (marketplace manifest — **still points at dead gitkb org**, Defect D1), codex
  (+1 Deep-Code-Harness commit), n8n (workflow automation; visualization-plane candidate; stand-down,
  D-1 blocked on docker), oh-my-claudecode + oh-my-pi (upstream mirrors of orchestration harnesses),
  hermes-agent (NousResearch fork, Python self-improving agent).
- **Hubs (12, Hub Standard from template_hub):** active-but-thin (mcp_hub, tool_hub, plugin_hub,
  vault_hub, harness_hub, commands, template_hub, .github_org) or empty scaffolds (database_hub,
  flow_hub, hooks_hub, network_hub). vault_hub ships a 1,508-skill catalog **plus a vendored kasetto
  copy** (Defect D2). .github_org: six-role umbrella being dissolved into peers; admits MANIFEST drift
  (~28 listed vs 4 present).
- **Knowledge:** obsidian-mind (agent-memory vault template), lifeos (Vue3+Tauri2 life-OS app; broken
  handoff), flexnetos_wiki/my-wiki (empty).
- **Ops husks:** flexnetos_secrets / flexnetos_runner / flexnetos_github_app / flexnetos_brain / assets
  — zero-commit placeholders since 2026-06-03 (flexnetos_github_app was ADR-0001's candidate home for
  the trusted merge-gate writer; still unborn).

## Census table

| repo | plane | tier | state | .handoff | loop | role (code-derived) |
|---|---|---|---|---|---|---|
| **meta** (parent) | 1-Foundation | — | active | — | n/a | Workspace root: .meta.yaml registry, hybrid Cargo workspace (14 members), POLICY v2 exemplar, clone-child-repos CI, org docs |
| loop_cli | 1-Foundation | A | active | — | none | Thin clap CLI `loop`: parses .looprc, delegates to loop_lib for parallel multi-dir command runs |
| loop_lib | 1-Foundation | A | active | — | none | Core execution engine: serial/rayon-parallel shell across directories, filters, output aggregation |
| meta_cli | 1-Foundation | A | active | — | none | The host `meta` binary: clones/coordinates children, cross-repo exec, plugin routing |
| meta_core | 1-Foundation | A | active | — | none | Shared infra: ~/.meta data dir, PID-staleness file locking, atomic JSON storage |
| meta_dashboard_cli | 1-Foundation | A | active | — | none | `meta dashboard` plugin; shells to `envctl dashboard --json` (PATH runtime dep) |
| meta_git_cli | 1-Foundation | A | active | — | none | meta-git plugin: recursive clone, per-repo status/commit/push, worktree sets, snapshots |
| meta_git_lib | 1-Foundation | A | active | — | none | Git ops library: queued cloning, snapshots, worktree engine (add/remove/TTL registry/hooks) |
| meta_mcp | 1-Foundation | A | active | — | none | stdio JSON-RPC MCP server exposing meta ops to AI agents |
| meta_plugin_api | 1-Foundation | A | active | — | none | Legacy dylib Plugin-trait ABI; superseded by subprocess protocol; zero reverse deps |
| meta_plugin_protocol | 1-Foundation | A | active | — | none | JSON-over-stdio host↔plugin protocol types |
| meta_project_cli | 1-Foundation | A | active | — | none | `meta project list/check/dependents`: renders the .meta project tree |
| meta_rust_cli | 1-Foundation | A | active | — | none | Cargo commands across all Rust projects in the workspace |
| **RuVector** | 2-AgenticOS | C | active | — | none | 314-crate agentic OS (perception→aggregation→orchestration→edge, cognitum gate, RVF witness); pinned fork of ruvnet lineage |
| **ruflo** | 2-AgenticOS | C | active | — | none | ruvnet flow/agent framework; genuine org fork, pin-branch pattern, local main intentionally behind |
| grit | 3-rtkTooling | C | active | — | none | AST/function-level lock coordinator for many parallel AI agents on one codebase |
| icm | 3-rtkTooling | C | active | — | none | Persistent agent memory: SQLite/sqlite-vec, BM25+vector recall, decay, memoirs, MCP |
| rtk-tokenkill | 3-rtkTooling | C | active | — | none | `rtk` proxy filtering/compressing dev-command output (60-90% token savings) |
| vox | 3-rtkTooling | C | active | — | none | TTS CLI/MCP with six backends, daemon, cloning; org fork carries English defaults |
| handoff | 4-Continuity | B | in-dev | ✓ | working | Continuity Ledger Kernel: handoff.task.v1 + witnessed ledger + hf CLI (the proven loop) |
| rusty-idd | 4-Continuity | B | active | — | working | Intent-driven-development merge control plane; source of the fail-closed merge model |
| weave | 4-Continuity | B | active | — | working | a2a session mesh: leases/jobs/messaging/verdicts (ADR-0002 contract); interim 4-crate |
| atc | 4-Continuity | C | active | — | none | Headless agent dispatcher: worktrees, queue+daemon, 6-signal health, SQLite registry |
| envctl | 5-Feature:env | B | active | — | none | Meta env manager: env injection, secretd (1–5), kasetto seam, USB secret vault |
| kasetto | 5-Feature:env | C | active | — | none | Declarative agent-asset provisioner (skills/commands/MCP configs); bins kasetto/kst |
| prompt_hub | 5-Feature:frontdoor | B | in-dev | — | working | Prompt management core/CLI/axum server; 1085 tests; ZERO MCP + zero dispatch (seam unbuilt) |
| Archon | 5-Feature:harness | C | active | — | none | Bun/TS DAG workflow engine running coding agents in worktrees (CLI/web/Slack/Telegram/GitHub) |
| ECC | 5-Feature:harness | C | active | — | working | Multi-harness agent OS (agents/skills/hooks/rules) + Rust TUI + llm-abstraction |
| agent | 5-Feature:harness | C | active | — | none | Harness hooks CLI: `agent guard` (PreToolUse denial), score, codex tools — parent's guard |
| claude-code | 5-Feature:harness | C | active | — | none | Vendor reference fork: changelog, official plugin marketplace, issue automation (no CLI source) |
| claude-plugins | 5-Feature:harness | C | stale | — | none | Plugin marketplace manifest; sources still point at dead gitkb org (D1) |
| codex | 5-Feature:harness | C | active | — | none | OpenAI Codex CLI fork + one Deep-Code-Harness commit (.codex profiles + Node orchestrator) |
| hermes-agent | 5-Feature:harness | C | active | — | none | NousResearch Hermes Agent fork: Python self-improving agent platform |
| n8n | 5-Feature:harness | C | active | — | working | n8n workflow-automation fork; harness/epic-d merged; loop stood down (D-1 docker) |
| oh-my-claudecode | 5-Feature:harness | C | active | — | none | Multi-agent orchestration layer for Claude Code (ralph/autopilot); upstream mirror |
| oh-my-pi | 5-Feature:harness | C | active | — | none | Bun/TS+Rust terminal coding agent (pi-*); pristine upstream mirror |
| .github_org | 5-Feature:hub | D | active | — | working | Org `.github` umbrella: community health + reusable CI; being dissolved into peers |
| commands | 5-Feature:hub | D | in-dev | — | none | Slash-command registry hub (1 entry: /meta-analyze) |
| database_hub | 5-Feature:hub | D | empty | — | none | Hub Standard scaffold, catalog empty |
| flow_hub | 5-Feature:hub | D | empty | — | none | Hub Standard scaffold for automation flows, empty |
| harness_hub | 5-Feature:hub | D | active | — | none | Harness catalog + upgrade-kits docs; vendored revfactory/harness misattributed in registry |
| hooks_hub | 5-Feature:hub | D | empty | — | none | Hooks catalog scaffold, population pending |
| mcp_hub | 5-Feature:hub | D | active | — | none | MCP-server registry; nested meta repo hosting forked servers (n8n-mcp) |
| meta-plugins | 5-Feature:hub | D | empty | — | none | meta-CLI plugin-name registry; payload is example data resolving to nonexistent repos |
| plugin_hub | 5-Feature:hub | D | active | — | none | Claude-plugin/marketplace catalog (data-only) |
| template_hub | 5-Feature:hub | D | in-dev | — | none | Defines the Hub Standard (registry.json + schema + validate.py) other hubs copy |
| tool_hub | 5-Feature:hub | D | active | — | none | Dev-tool catalog; delegates MCP→mcp_hub, commands→commands, flows→flow_hub |
| vault_hub | 5-Feature:hub | D | active | — | none | 1,508-skill capability catalog + vendored kasetto copy (D2) |
| lifeos | 5-Feature:knowledge | B | in-dev | — | broken | Vue3+Tauri2 life-management OS app; HANDOFF points at dead paths |
| obsidian-mind | 5-Feature:knowledge | C | active | — | none | Obsidian vault template giving agents persistent memory; product ≠ loop residue |
| flexnetos_wiki | 5-Feature:knowledge | D | empty | — | none | Empty wiki placeholder |
| my-wiki | 5-Feature:knowledge | D | empty | — | none | Empty personal-wiki placeholder |
| lane | 5-Feature:network | B | active | — | working | Local-domain TLS reverse proxy (myapp.test→ports); loop legitimately TERMINAL DONE |
| obscura | 5-Feature:network | B | active | — | none | Rust headless browser engine (V8, CDP, Puppeteer/Playwright drop-in); lane's web-access upgrade. INTEGRATED (2026-06-14): build/test green (271→282), custom-CA trust, lane↔obscura seam (ADR-0001) reconciled to its real CLI, MCP surface verified, network_hub-registered. Owned (C→B). |
| network_hub | 5-Feature:network | D | empty | — | none | Network-topology catalog scaffold; README prose drifting ahead of empty registry |
| flexnetos_github_app | 5-Feature:ops | B | empty | — | none | Unborn; ADR-0001's candidate home for the trusted merge-gate writer |
| flexnetos_runner | 5-Feature:ops | B | empty | — | none | Unborn runner placeholder |
| flexnetos_secrets | 5-Feature:ops | B | empty | — | none | Unborn secrets placeholder |
| flexnetos_brain | 5-Feature:other | B | empty | — | none | Unborn data/brain placeholder |
| assets | 5-Feature:other | D | empty | — | none | Unborn asset collection |
| shimmy | 5-Feature:swarm | C | active | — | none | Local LLM inference server: OpenAI/Ollama/Anthropic APIs over Airframe/WebGPU |
| teri | 5-Feature:swarm | C | active | — | none | Rust swarm prediction engine (MiroFish rewrite): seed docs → petgraph KG → persona agents → sim |

## The KB ↔ handoff seam (vision item 1's open question)

Where `/kb-board`, `/kb-tasks`, `/kb-commit`, `/kb-status` (real: `.claude/commands/kb-*.md`, backed by
`git kb` / the gitkb plugin) sit relative to the handoff kernel — **verified two-plane split:**

- **git-kb = the knowledge/planning plane.** Documents (context/tasks/incidents/specs) in a local DB,
  human+agent readable, full-text + code intelligence. `/kb-board` views task kanban; `/kb-tasks` lists;
  `/kb-commit`/`/kb-status` manage the workspace editing surface. It answers *"what do we know, what is
  planned, why."*
- **.handoff = the execution/witness plane.** `handoff.task.v1` work-orders, weave leases, the witnessed
  rusqlite+rvf-crypto ledger. State precedence **Git > ledger > task cards**; weave Jobs are a
  coordination view. It answers *"what is provably being done, by whom, with what evidence."*
- **Today's link is one-way and thin** (ADR-0001 R7): hf can push a context doc to kb (`hf sync`
  design); kb is never read back; kb tasks and HFTASK cards are disjoint registries (this census found
  kb board ACTIVE×3 while .handoff carries 22 cards — zero cross-references).
- **To freeze in ADR-0003 (kb↔handoff seam):** (a) kb task → `handoff.task.v1` spawn rule (kb =
  intake/planning, .handoff = execution record), (b) `hf checkpoint` → kb progress write-back,
  (c) single-registry rule for which surface owns "what's next" (proposal: kb board owns planning
  state; .handoff cards become execution snapshots minted FROM kb tasks), (d) commit-message wikilink
  convention binds both ([[tasks/…]] ↔ correlation_id).

## n8n = the visualization/mapping plane (vision item 1)

n8n fork is healthy (epic-d merged, loop stood down cleanly; D-1 blocked on user docker). Its assigned
role — visual map of all meta workflows/architecture to expose gaps — is **not yet built**: no meta-map
workflows exist in-repo. W-n8n action: stand up local n8n (needs docker — NEEDS-HUMAN if unavailable),
generate the estate map from `.meta.yaml` + notify-graph + this census (export JSON in-repo).

## Corrections vs the prior register (census fixed these)

1. obscura ≠ env-control: it's a headless browser engine → network plane (lane's upgrade).
2. grit ≠ untriaged: AST lock coordinator for parallel agents (re-tag `[tools, ai, concurrency]`).
3. teri/shimmy planes: swarm-inference track (MiroFish), not "untriaged".
4. atc overlaps handoff/weave as a dispatcher — needs an explicit seam decision, not a tag.
5. "broken loop harnesses" (vision item 12) is mostly FALSE: of the named five, only handoff's *cards*
   are stale and prompt_hub's *identity* drifts; weave/lane/rusty-idd loops closed legitimately.
   lifeos is the only truly broken harness found.

## Defects found (feed GAP-REGISTER)

- **D1** claude-plugins marketplace sources = `gitkb/meta`, `gitkb/gitkb-claude-plugin` (dead org) —
  installs bypass FlexNetOS forks. Fix: re-point meta plugin at `FlexNetOS/meta` path `claude-plugin`;
  decide hosting for the gitkb plugin fork.
- **D2** vault_hub vendors a no-.git kasetto copy + two placeholder "Implement feature X" commit
  messages — duplication vs `meta/kasetto`; replace with registry entry pointing at the real repo.
- **D3** handoff's 22 task cards all `backlog` w/ dead `spike/**` path_scopes — refresh cards to match
  ledger/Git truth (fold into Phase 4 card-sync design).
- **D4** 12 husk repos (5 flexnetos_*, assets, 2 wikis, 4 empty hubs) — populate or archive (several
  already in NEEDS-HUMAN #5 family).
- **D5** prompt_hub identity drift (README/Cargo → nonexistent `prompthub` org/crates) + ~10 leftover
  loop branches.
- **D6** kasetto fork: inert upstream-secret release workflows; fork main 3.0.0 vs installed 3.1.0.
- **D7** meta-plugins registry payload = example data resolving to nonexistent repos.
- **D8** .github_org MANIFEST lists ~28 components, 4 present (its own MIGRATION.md admits it).
- **D9** lifeos handoff references dead paths; SESSIONS auto-log behind HEAD.
- **D10** teri TODO.md = stale Mar-2026 checklist (241 unchecked) + upstream CLAUDE.md demands
  interactive review (conflicts with autonomous ops) — refresh both in the W4 vehicle decision.
- **D11** harness_hub registry misattributes vendored `harness` (claims FlexNetOS/harness; real
  upstream revfactory/harness — also NEEDS-HUMAN #5).
- **D12** shimmy carries upstream's stale AGENTS.md (wrong remotes/paths) + 7 inert release workflows.

## Research / Cross-References

Census workflow `wf_a40b236a-ddb` (58 agents, 518 tool calls, raw rows in session task output);
spot-verifications 2026-06-12: obscura README+Cargo+src (7-crate browser engine), claude-plugins
marketplace.json (read in full), vault_hub ls (kasetto/ vendored), handoff cards (22×backlog,
22×spike-refs via JSON parse). RuVector/ruflo/envctl rows from direct walks: RUVECTOR-RUNBOOK.md,
RUVECTOR-CRATE-LEDGER.md (314/314), seam-spec-envctl-meta-env-2026-06-11 +
seam-spec-kasetto-agent-env-2026-06-11 (memoir). Planes cross-checked against META-ORG-POLICY.md tiers
and the user's 15-item vision register (UPGRADE-MISSION-PROMPT.md). Memoir:
architecture-truth-census-2026-06-12 (instance_of → org-audit-results-2026-06-12).
