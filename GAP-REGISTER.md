# GAP-REGISTER — the 15-item vision register, scored from code (2026-06-12)

**Contract:** nothing closes without evidence (file/commit/API output). Verdicts: ✅ DONE · 🟡 PARTIAL ·
🔴 GAP · 🔵 DESIGN-OPEN. Owners reference UPGRADE-MISSION-PROMPT.md phases/workstreams.
**Inputs:** ARCHITECTURE-TRUTH.md (62-unit census) · VERIFICATION-REPORT.md · memoir
(policy-v2-meta-org, adr-2026-06-11-open-questions r2) · census workflow `wf_a40b236a`.

| # | Vision item | Verdict | Current state (evidence) | Gap → upgrade action | Owner |
|---|---|---|---|---|---|
| 1 | Architecture + history truth; repo roles; kb-commands↔handoff fit | ✅ (this session) | ARCHITECTURE-TRUTH.md: 62 units, 5 planes verified, lineage (harmony-labs→gitkb→FlexNetOS; ruvnet pinned forks), kb↔handoff two-plane answer written | Freeze seam in ADR-0003; build the n8n visual map (docker wall) | P2 done; ADR-0003 → P4; map → W-n8n |
| 2 | Every repo hosts `.handoff` + abides policy; loop_lib gets autonomous upgrades | 🔴 total gap | `.handoff/` in exactly 1/58 repos (census hf-column); loop-state convention split `_workspace/` vs `.handoff/` vs ad-hoc; POLICY v2 has no continuity layer (P1–P6 only) | ADR-0004 (per-repo layout + sync, absorb design-bundle templates + session.schema.json) → policy P7 → tiered rollout incl. loop_lib | P4 |
| 3 | kasetto + envctl = env control | 🟡 | Seam LIVE one-way: envctl `manifest/agent-env.toml` ↔ kasetto `sync --locked` CI gate (seam-spec-kasetto 2026-06-11); both active | ADR the kasetto↔envctl split; sync fork 3.0.0→3.1.0; de-vendor vault_hub copy (D2); rename env_manager_agent→kasetto (NEEDS-HUMAN #6) | W1 |
| 4 | lane = network engineering/control; obscura = its upgrade | 🟡 | lane active (TLS reverse proxy, loop TERMINAL DONE legitimately); obscura = Rust headless browser engine (V8/CDP, 7 crates) — **pure mirror, zero integration** (census + direct read) | lane+obscura seam ADR (browser = agent web-access capability under lane's network control); re-tag both; lane relay (cross-machine) still unfinished — standing wall | W2 |
| 5 | weave = a2a + session-to-session | 🟡→✅ | ADR-0002 five-surface contract PROVEN in production (handoff PR#3/#4, leases/jobs/verdicts); mesh has sessions/presence surfaces | Re-verify contract in code post-merges; extend session-to-session continuity (hf session verb HFTASK-0007 is the consumer) | W3 |
| 6 | MiroFish full-feature Rust port; teri/shimmy evaluation | 🟡 foundation confirmed | teri **is** a MiroFish rewrite (census-independent confirmation: seed docs→petgraph KG→persona agents→sim; Cargo self-describes swarm-prediction engine); shimmy = the Ollama slot (OpenAI/Ollama/Anthropic APIs), CI-green members | Feature-parity matrix vs 666ghj/MiroFish; vehicle verdict (extend-teri bias per adopt-then-extend law); port-plan ADR; then build. Clean teri's stale TODO/CLAUDE.md (D10) | W4 |
| 7 | Archon = harness-builder agent (level-up of harness_hub) | 🔴 | Archon = pure tracking fork: zero FlexNetOS commits, stale `harness-upgrade` branch 24-behind (census) — capability present (DAG workflows, worktrees, multi-provider), role unassigned | Archon bring-up plan: charter as the harness-builder over harness_hub's catalog; first org commit = meta-workspace provider/profile | W5 |
| 8 | Harness repo census | ✅ | 10 harness-plane repos censused w/ roles + overlap (ARCH-TRUTH plane 5); duplicates/mirrors identified (oh-my-* pristine, claude-code = vendor reference) | Role charter: what Archon absorbs vs what stays catalog (harness_hub); fix D11 misattribution | W5 |
| 9 | rusty-idd = IDD end-to-end | 🟡 | Control plane built+active (25 ralph cycles to backlog-clear; fail-closed merge model already adopted by handoff §5); protected develop/main, checks [rust,msrv] | Missing `scripts/ralph-idd.sh` (CLAUDE.md refers to it); stale NEEDS-HUMAN/HANDOFF docs; seam ADR (does rusty-idd consume/produce handoff.task.v1?); no intent→delivery e2e proof yet | W6 |
| 10 | prompt_hub = ruvector/ui front door for non-technical users | 🔴 at the seam | Core healthy (3 crates, 1085 tests, loop coherent at cycle 82) but **zero MCP server + zero outbound dispatch** — both sides of the front-door seam unbuilt (R14, re-confirmed by census); RuVocal = unmodified HF Chat-UI fork | HFTASK-0003 (Intent→envelope synthesis — THE crux) + HFTASK-0019 (transport ADR); fix identity drift D5; RuVocal stays LAST (0022) | W7 |
| 11 | Is ruvector (all-crates) integrated? | 🔴 honest no | 314/314 mapped (RUVECTOR-CRATE-LEDGER.md); adopted = `rvf-crypto` only (handoff ledger path-dep — the single live code edge); planned: cognitum-gate 0017, domain-expansion 0018, MCP seam 0019, RVF ledger v2 0006, RuVocal 0022 | W8 scoreboard (crate-family × integrated/planned/unplanned/N-A) + next adoption tranche per S1 law | W8 |
| 12 | Launch ruvector UI; run feature additions from it; fix broken loop harnesses | 🔴 + corrected premise | No UI surfaces loop state anywhere (ledger §7 is the read-model); RuVocal unlaunched/unmodified. "Broken harnesses in prompt_hub/rusty-idd/handoff/weave/lane" mostly FALSE: weave/lane/rusty-idd closed legitimately; real issues = handoff's 22 stale cards (D3), prompt_hub drift (D5), lifeos dead paths (D9) | Launch attempt + documented procedure-or-wall (W7); D3 card refresh (P4); D5/D9 fixes | W7 + P4 |
| 13 | Per-repo `.handoff` ↔ central handoff sync | 🔵 design-open | Zero implementations exist; inputs ready: design-bundle layout (`.handoff/{tasks,packets,context,decisions}` + capsule.json + hooks/policies/skills templates), open-q #13 (session-ledger location), loop-state convention split | ADR-0004 settles: per-repo contents, aggregation (hf fleet reader vs events), kb mapping (ADR-0003), card-sync rule (fixes D3 class) | P4 |
| 14 | Replace the NEEDS-HUMAN human with a steward agent | 🔵 design-ready | Recalled directive (01KTQRS2): approvals → surgical **code-omniscient AI gatekeeper**; NEEDS-HUMAN = 7 items + 3 standing walls, **0/7 actioned by human** (VERIFICATION-REPORT) — the queue starves without a steward; ICM (perfect recall) + proven loop (witnessed verdicts, native auto-merge) exist | NORTH-STAR.md + ADR-0005 + steward definition; classify queue: agent-decidable (most) vs genuine walls (physical/account/irreversible); demonstrate one steward decision | P6 |
| 15 | envctl secret injection/relay + COGNITUM seed advanced setup | 🟡 **unblocked today** | COGNITUM mounted+readable NOW (`/run/media/drdave/COGNITUM`: guide.html 167K, open.html, trust/, launch scripts) — the "unreachable USB" standing wall CLEARED; envctl secretd 1–5 sanctioned; forgotten directive: integrate envctl relay/injection into loop secrets | Read+analyze the whole seed (no blind script execution); document advanced setup; wire envctl injection/relay into hf/loop secrets handling | W1 |

## Census defects → owners (from ARCHITECTURE-TRUTH.md)

| Defect | Owner | Defect | Owner |
|---|---|---|---|
| D1 claude-plugins dead gitkb sources | W5 (small PR) | D7 meta-plugins example payload | W5/P4 |
| D2 vault_hub vendored kasetto | W1 (de-vendor PR) | D8 .github_org MANIFEST drift | github-meta-refactor task (kb, ACTIVE) |
| D3 handoff 22 stale cards | P4 (card-sync design) | D9 lifeos dead-path handoff | P4 rollout fixes it |
| D4 12 husk repos | NEEDS-HUMAN #5 family + steward (P6) | D10 teri stale TODO/CLAUDE.md | W4 |
| D5 prompt_hub identity drift | W7 | D11 harness_hub misattribution | W5 |
| D6 kasetto fork lag + inert workflows | W1 | D12 shimmy stale AGENTS.md/workflows | W4 (vehicle decision) |

## W8 — RuVector integration scoreboard (item 11's evidence; from the 314-crate ledger + memoir, code-verified anchors)

| Crate family | Status | Anchor |
|---|---|---|
| rvf / rvf-crypto (witness chains) | **INTEGRATED** | handoff/ledger path-dep — the only live code edge |
| RVF vector-native ledger (rvf-runtime) | planned | HFTASK-0006 (ledger v2, semantic recall) |
| cognitum-gate (coherence gate) | planned + **hardware arrived** | HFTASK-0017; COGNITUM-SEED.md (the gate in silicon: witness/custody/MCP) |
| rvAgent / a2a-swarm (A2A, verdict types) | planned | open-q #3 bridge; verdict reducer (open-q #4); ADR-0002 keeps hf as junction |
| verified-applications (AgentContract) | planned | HFTASK-0004 (proof at `hf handoff`) |
| domain-expansion (Φ-aware routing) | planned | HFTASK-0018 |
| ui / RuVocal (chat front end, pgvector) | planned LAST | HFTASK-0022; unmodified HF Chat-UI fork today |
| ruvector-postgres / pgvector | planned (with RuVocal) | RuVocal is pgvector-native in code (verified 2026-06-11) |
| boundary/consciousness discovery (perception+Φ) | unplanned-but-valuable | candidates for sensor/drift duty once Seed is wired |
| train-discoveries / mcp-brain (aggregation) | unplanned-but-valuable | aggregation plane unowned in meta today |
| edge fleet (desktop→browser→P2P→ESP32) | unplanned | post-Seed-swarm consideration (Seed sync/swarm endpoints exist) |
| exo / 7sense (incubation, bioacoustic) | not-applicable now | B17f/g verdict stands (incubation; Φ-router promotion candidate) |

**Honest answer to item 11: NO — integration is 1 family of ~12** (rvf-crypto), with 6 planned on
carded tasks, 3 valuable-unplanned, and the cognitum gate now physically present as the Seed.
Adoption tranche order stays: 0017-gate concepts via Seed anchoring → 0006 ledger v2 → 0004
AgentContract → 0018 routing → RuVocal last.

## Sequencing verdict (respects readiness order + build-order law)

1. **P4** fleet `.handoff` (ADR-0003 + ADR-0004 + P7 + rollout) — unblocks items 2/13, fixes D3/D9.
2. **W1** env-control + COGNITUM (item 15 just unblocked; directive debt) ‖ **W4** MiroFish parity matrix (read-only research first).
3. **W7** front-door seam (HFTASK-0003/0019 — the P0 cruxes) with **W3** weave re-verify as its substrate.
4. **P6** steward (item 14) — feeds on NORTH-STAR.md distilled from this register.
5. **W2/W5/W6/W8** roll behind; RuVocal (0022) LAST, unchanged.
