# RuVector Crate-Map Runbook

> **Single source of narrative truth** for the exhaustive RuVector crate walk. Survives context resets.
> Companions: `RUVECTOR-CRATE-LEDGER.md` (per-crate coverage checklist) · ICM memoir `system-architecture`
> (concepts) · `RUVECTOR-RESEARCH.md` (older pass log). **Update this file every batch.**

## Mission (user-authoritative)
Map the **ruvnet ecosystem via RuVector**: (1) how the RuVector example apps interconnect, (2) where
ruflo fits — by **mapping the Rust-native crates first**, *before* mapping into meta. **Not installed/
adopted yet.** Requirement: **every one of the 314 crates thoroughly walked.**

## Method (hard rules)
1. **CODE-TRUTH ONLY.** Docs lie and walk you in circles — untrusted: repo `.md`, Cargo `description`,
   `//!`/`///` doc-comments, ADR prose, AND the knowledge-export JSON (v2.0 narrative, claims 91 crates vs
   real 314). Trust only: real `[dependencies]` edges, real `pub` type/trait/fn signatures, struct fields,
   tests. When prose ≠ code, **code wins + FLAG it**.
2. **Read crates DIRECTLY** (Bash/Read). **No subagents** in RuVector/ruflo/envctl (forge-loop/weave-relay
   hijack hazard).
3. Extractor: `~/Desktop/meta/.rvwalk.py` (dir → real deps + pub types + mods). Per crate also pull real
   `[dependencies]` + `pub struct/enum/trait` defs.
4. **Persistence per batch:** (a) memoir concept `codewalk-*`, (b) flip ledger marks `[~]`→`[x]`, (c) append
   a batch entry here, (d) `icm store` only for cross-cutting decisions. vox (piper/en) on real milestones.
5. **gotcha:** never put backticks in `icm ... -d "..."` (bash command-substitutes them). Use plain text.

## Persistence map (where research lives)
| Artifact | Holds |
|---|---|
| `RUVECTOR-RUNBOOK.md` (this) | method + per-batch findings + running synthesis |
| `RUVECTOR-CRATE-LEDGER.md` | all 314 crates, `[x]/[~]` coverage, grouped by cluster |
| ICM memoir `system-architecture` | one durable concept per cluster/subsystem, linked graph |
| ICM memories (`icm store`) | cross-cutting decisions/corrections |

## Coverage
**314 / 314 — STRICT COMPLETE.** All crates + all examples walked per-crate (deps + real types + verified
agentic markers). B17 redone properly in 10 slices (B17a–j) after the bulk pass was reverted. 0 `[~]` left. `examples/` being re-walked STRICT in 5–7-crate slices,
**with the AGENTIC-ROLE lens** (user: examples are roles in the live system, not demos — surface each one's
agentic function: sensor/discovery/monitor/brain-contributor/MCP-capability/federated-node, + wiring:
mcp/brain/a2a/federation/loop/witness). ~79 example crates remaining.

## CROSS-CUTTING THESES (the synthesis — update as evidence accrues)
- **T1 — Two models, one stack.** *Data model* = coherence-aware hypergraph (nodes=vectors, edges=graph,
  weights=attention, boundaries=mincut, persistence=RVF). *Control model* = **governed/gated/attested
  compute**: a coherence-gate + policy-gate + Lean-proof + witness + budget seam recurs in `solver`
  (budget/audit), `verified` (Lean), `fpga-transformer` (gates), `graph-transformer` (attestation), `rvm`
  (proof/coherence). **This is the real unifying signature, not "vectors."**
- **T2 — Every TS has a Rust-native replacement** (user principle). ruflo/claude-flow TS = legacy/compat;
  RuVector crates = canonical. Map each TS module → its Rust crate when porting into meta.
- **T3 — Where ruflo fits (code anchors).** ruflo binds the substrate via the `ruvector` npm facade
  (`@ruvector/rvf`=rvf-node→rvf-runtime / `@ruvector/rvf-wasm`=rvf-wasm) + ruflo-core witness(rvf-node).
  `ruvllm` carries a `ClaudeFlowAgent` type → ruflo agent roles modeled natively in Rust. rvAgent (Rust
  agent runtime) and ruflo (TS runtime) are **parallel front-ends over one substrate**, not layers.
- **T4 — Format is the integration substrate.** Native (rvf-runtime/napi) and wasm (rvf-wasm) are sibling
  backends bridged by the **`.rvf` format (`rvf-types`) + `rvf-crypto`**, not by recompiling runtime→wasm.
  `rvf-types` is the #1 dep hub (26 dependents). Same for rvm/ruvix/kernel — they couple via the format.
- **T5 — Multiple witness schemes (one pattern).** RVF = SHAKE-256/73B (rvf-crypto); RVM = FNV-1a/64B
  (rvm-witness); ruvix = Merkle-witness (ruvix-proof) + attested boot (ruvix-boot). Different tiers, same
  tamper-evident-audit pattern. Reconcile when choosing a continuity-ledger substrate.
- **T6 — The edge execution stack is real & layered.** `ruvix` (bare-metal AArch64 **microkernel OS** —
  MMU/GIC/UART/TCP-IP/FAT32/SMP, with vectors+graphs *in-kernel* via `ruvix-vecgraph`) + `rvm` (coherence
  microhypervisor over it) + `rvf` (bootable container; `rvf-launch` boots it in QEMU) + `cognitum-gate`
  (HW gate, TBD). All share the T1 proof/cap/witness/coherence seam. `ruvix-sched`→`ruvector-coherence` is a
  real kernel→substrate edge. This is the cognitum-seed runtime (bcm2711 = Pi).
- **T7 — Patience rule (user).** A crate/feature that looks orphaned (e.g. the 6 rvf adapters, TS shims) has
  its Rust-native consumer further along; search all Cargo.toml before labeling "dead." First proof:
  `ruvix-sched` consumes `ruvector-coherence`.
- **T15 — The agentic role concentrates in the INTEGRATION examples, not the domain demos.** Real
  agent/MCP/swarm wiring lives in: `a2a-swarm` (rvAgent multi-agent **orchestrator** over the A2A protocol),
  `verified-applications` (**formally-verified `AgentContract`s** on `ruvector-verified`/Lean — Multi-Agent
  Contract Enforcement), `ospipe` (axum OS-capture **perception daemon** → rvf-adapter-ospipe), `robotics`
  (MCP + multi-robot consensus). Domain demos are *capabilities*; these are the *agents that wield them*.
  **S1 hook:** `ruvector-verified` + `AgentContract` = a provable work-order / governed-contract substrate —
  a strong candidate for the meta work-order envelope + continuity ledger.
- **T14 — Examples are agentic ROLES, not demos (user).** Each example is a part of the live RuVector
  agentic system. The boundary-discovery family = the **domain-specialist early-warning / perception agent
  fleet**: each detects a regime/state transition *before* amplitude methods (pandemic ~60d early, bridge
  collapse months early, pre-seizure EEG, market regime, health state) and emits alerts — the deployed form
  of `ruvector-perception`'s `BoundaryPredictor`. Some run as continuous monitors (health/earthquake/void
  loops); `brain-boundary-discovery` is brain-connected. The orchestration (ruflo/rvAgent/weave/MCP)
  coordinates them; the shared brain aggregates their discoveries. Walk-lens: find each example's agentic
  function + wiring, not just its crate deps.
- **T13 — The examples are ONE pipeline, parameterized by domain.** They interconnect *through shared hub
  crates*, not by calling each other. Dominant hubs across 90 example crates: `ruvector-mincut` (21),
  `ruvector-coherence` (19), `core` (11), `graph`/`consciousness` (6), `gnn`/`domain-expansion` (5),
  `attention` (4). The boundary-discovery family (seti/earthquake/cmb/frb/weather/market/health/pandemic/
  music/void/infra/brain) + consciousness family (climate/cmb/ecosystem/gene/gw/quantum) are the **same
  mincut+coherence(+IIT-Φ) engine applied to different datasets**. Two satellite workspaces: `exo-ai-2025`
  (consumes ruvector via crates.io `0.1`) and `vibecast-7sense`/`sevensense-*` (self-contained, no ruvector
  dep). Agents enter via MCP seams, not the examples (except `a2a-swarm`).
- **T12 — A vector index/DB *zoo* behind common traits.** ~a dozen interchangeable index/store impls —
  HNSW, Vamana(`diskann`), IVF(`rairs`), ACORN(`acorn`), RaBitQ, hyperbolic, micro-HNSW, `delta-index`,
  `router-core`, `rulake`(lake), `tiny-dancer-core`, `rvlite`, `rvf-index`, `core` — behind `VectorIndex`/
  `AnnIndex`/`FilteredIndex` traits. Different algorithms × deployment shapes (embeddable/lake/postgres/
  server). For meta adoption: pick by trait, not by crate. (`router-core` is a DB, not a router — trap.)
- **T11 — MCP is the universal control seam.** Every subsystem exposes itself as an MCP server —
  `mcp-gate` (coherence gate), `mcp-brain` (shared brain), `agentic-robotics-mcp` (robot), `rvagent-mcp` +
  ruflo (agents). One uniform agent-facing interface across the whole stack; "where ruflo/Claude plugs in"
  is *consistently* an MCP endpoint. (Robotics also mirrors the agent split: middleware/transport
  `agentic-robotics-*` vs cognition `ruvector-robotics`, like rvAgent-runtime vs ruvector-substrate.)
- **T10 — T1 generalizes to domains.** The coherence-gate + witness pattern isn't confined to the
  substrate: `neural-trader-coherence` gates *trades* (`CoherenceGate`/`WitnessReceipt`/`RegimeLabel`) just
  as the cognitum tier gates *actions*. Every domain app re-instantiates "gated + witnessed decision."
  `ruQu` even reuses **QEC surface-code decoding** (fusion-blossom MWPM) to harden the gate decision.
- **T9 — Governance lives in compute/cognition, not plumbing.** The budget/witness/coherence/proof seam
  saturates the compute + cognition crates (`solver`/`verified`/`graph-transformer`/`consciousness`/
  `cognitive-container`/`nervous-system`/`perception`) but is **absent** from the distributed plumbing
  (`raft`/`cluster`/`replication`/`snapshot`/`server`/`node`), which is plain textbook infra. Clean
  separation: governed *cognition* sits on top of unopinionated *storage/transport*.
- **T8 — T1 has a HARDWARE root (the cognitum gate).** Coherence is literally **mincut e-value evidence
  computed in hardware**: `cognitum-gate-kernel` (per-tile, no_std, `ruvector-mincut`, anytime-valid
  `LogEValue` across 255 tiles) → `cognitum-gate-tilezero` (`decide(ActionContext)→Permit/Deny/Defer` + signed
  replayable `WitnessReceipt` chain) → `mcp-gate` (MCP server = the agent-facing permit API at the seed's
  `/mcp`). The cognitum seed = `ruvix` kernel + Hailo NPU (`ruvector-hailo`) + this gate, clustered
  (`ruvector-hailo-cluster` gRPC fleet) + thermal-governed (`ruos-thermal`). Agents reach the shared brain
  via `mcp-brain`. **This is the physical enforcement point of governed compute.**

## Subsystem map (walked)
- **Execution/edge tier:** `ruvix`(kernel/OS, overview) · `rvm`(coherence-native **microhypervisor**, 16
  crates ✅) · `cognitum-gate-*`(HW gate, TODO) · `rvf`(bootable container, overview→strict TODO).
- **Agent runtimes (parallel):** `rvAgent`(Rust-native coding agent, 10 crates ✅) ∥ ruflo(TS).
- **Compute core:** `ruvector-core/math/collections/graph/filter` ✅ · `gnn/attention/mincut/graph-transformer`
  ✅ · `solver`(budget-gated) ✅ · `coherence`(health monitor) ✅ · `verified`(Lean proofs) ✅ · `dag`(=QuDAG
  post-quantum governance, NOT query-plan) ✅.
- **LLM:** `ruvllm`(Candle, ANE/BNNS, ClaudeFlowAgent) ✅ · `ruvllm_sparse_attention/_retrieval_diffusion` ✅
  · `ruvector-sparse-inference`(PowerInfer/GGUF) ✅ · `ruvector-fpga-transformer`(gated accel) ✅ ·
  `ruvector-sona`(=`crates/sona`: agent-factory + federated LoRA) ✅.

## Doc-contradictions caught (code vs prose)
- `ruvector-dag`: "query-plan DAG" → actually **QuDAG post-quantum governance/consensus** (KEM/DSA, staking,
  proposals, self-healing).
- `ruvector-coherence`: "sheaf-Laplacian engine" → actually **lightweight HNSW health/spectral monitor**
  (deps: only serde).
- `ruvector-fpga-transformer`: "FPGA backend" → **coherence/policy-gated accelerator engine** (ed25519,
  daemon).
- `rvf-crypto`: export claims "ML-DSA-65 post-quantum signatures" → real deps `ed25519-dalek + sha3` only;
  **no ML-DSA**. (PQ crypto is in `ruvector-dag`/QuDAG, not rvf-crypto.)
- `thermorust`: **name-trap** (sits next to `ruos-thermal`) → not thermal mgmt; it's an **Ising/Hopfield
  spin-glass energy-model engine** (statistical physics).
- `ruvector-crv`: **trap** → "CRV" = **Controlled Remote Viewing** protocol (Stages I–IV, AOL, gestalts)
  mapped to embedding-consensus; `AOLDetection` is really **hallucination/bias detection**.
- `ruvector-domain-expansion`: **trap** → not "domain expansion"; a **contextual-bandit / Thompson-sampling
  task router** (ArmId/BetaParams/regret), RVF-persisted = Rust-native of ruflo's MoE routing.
- `ruQu` (capital) vs `ruqu-core` (lowercase): **name-collision trap**, opposite purposes. `ruQu` = a
  **QEC MWPM decoder for the cognitum coherence gate** (fusion-blossom + mincut + tilezero); `ruqu-*` = a
  **real quantum-computing simulator** (gates/VQE/QAOA/Grover/surface-code).
- `ruvector-router-core`: **name-trap** → not request-routing; a **full embeddable vector DB** (HNSW +
  quant + redb). (`acorn`/`rairs`/`rulake`/`decompiler` are cryptic but honest: ACORN-ANN / IVF-ANN /
  vector-data-lake / ML-decompiler.)
- `prime-radiant`: export says "visualization/dashboard component" → actually a **second GPU-accelerated
  (`wgpu`) convergence runtime** composing the whole substrate + an agentic apply/adjust loop; a claude-flow
  plugin. Not a dashboard.

## PER-BATCH LOG
- **B0 — ruflo-wiring (pass 6/6b, corrected).** ruflo memory `RvfBackend` = pure-TS (dead napi handle); but
  Rust RVF *is* wired via the `ruvector` facade (6 intelligence plugins) + witness subsystem. Memoir:
  `rvf-wiring-verdict-pass6`, `rvf-wiring-pass6-correction`.
- **B1 — rvm (16).** Coherence-native microhypervisor. Memoir: `rvm-microhypervisor-subsystem`.
- **B2 — rvAgent (10).** Rust-native coding-agent framework. Memoir: `rvagent-rust-agent-framework`.
- **B3 — foundation: math/collections/solver/dag (+graph/filter API).** Memoir:
  `codewalk-foundation-solver-math-dag`. Caught dag=QuDAG.
- **B4 — graph-transformer stack: gnn/graph-transformer/coherence/verified/graph/filter.** Memoir:
  `codewalk-graphtransformer-stack`. Caught coherence overstatement; found Lean-proof backbone.
- **B5 — llm/sona: ruvllm/sparse_attention/retrieval_diffusion/sparse-inference/fpga-transformer/sona.**
  Memoir: `codewalk-llm-sona-stack`. Found ClaudeFlowAgent anchor; fpga=gated; T1 crystallized.
- **B6 — rvf cluster (26).** Memoir: `codewalk-rvf-cluster`. Format core (types→wire→manifest→index→quant→
  crypto→runtime), all deps prove T4. **`rvf-launch` boots a `.rvf` as a QEMU micro-VM** (extracts embedded
  kernel) = self-executing-container proof in code. `rvf-kernel`=image builder (cpio/docker), not runtime.
  `rvf-federation`=differential-privacy federated learning. `rvf-node`=napi `@ruvector/rvf` (ruflo's path).
  6 adapters (claude-flow/agentdb/ospipe/agentic-flow/rvlite/sona), all rlib→orphaned-from-TS. Caught
  rvf-crypto ML-DSA doc-lie. `rvf-types` bakes governance vocab (BudgetType/AuthorityLevel/Attestation) → T1
  at the format level.

- **B7 — ruvix cluster (28).** Memoir: `codewalk-ruvix-cluster`. Bare-metal microkernel OS; vectors+graphs
  in-kernel (`ruvix-vecgraph`); `ruvix-sched`→`ruvector-coherence`; in-kernel PBFT swarm. → T6, T7.

- **B8 — cognitum-gate + Hailo + mcp-gate/brain + thermal (9).** Memoir: `codewalk-cognitum-gate-tier`. →
  T8 (hardware root of T1). Caught thermorust name-trap.
- **B9 — cognition/consciousness (7): consciousness/perception/nervous-system/cognitive-container/crv/
  domain-expansion/temporal-tensor.** Memoir: `codewalk-cognition-consciousness-layer`. Real IIT-Φ (5
  engines), BTSP/Hopfield/HDC/circadian. **Keystone: `ruvector-cognitive-container`** = T1 as a software
  unit (deterministic, epoch-budgeted, witnessed, coherence-gated). Caught crv + domain-expansion traps.
- **B10 — delta-* CRDT + distributed/persistence tier (12).** Memoir: `codewalk-delta-distributed-tier`.
  Honest infra (no traps): delta-core/graph/index(incremental self-repairing HNSW)/consensus(CRDT GCounter)
  + raft/cluster/replication/snapshot/postgres(pgvector drop-in, embeds full compute as SQL)/server/node.
  Patience-payoffs: `postgres`→consumes `domain-expansion`; `ruvector-node` = `@ruvector/core` napi (facade
  backend). → T9.

- **B11 — ANN-index/quant compute (7).** Memoir: `codewalk-ann-index-quant-family`. DiskANN(Vamana)/RaBitQ/
  hyperbolic-HNSW/dither/spectral-sparsifier/quant-CNN/micro-HNSW. Honest, no traps. sparsifier→consciousness.

- **B12 — markets + quantum (9): neural-trader-core/coherence/replay/strategies, kalshi, ruQu, ruqu-core/
  algorithms/exotic.** Memoir: `codewalk-markets-quantum-domain`. neural-trader = coherence-gated+witnessed
  trading (T1 in finance) → T10. Caught ruQu/ruqu name-collision trap. ruQu = QEC decoder for the gate.

- **B13 — agentic-robotics + embodied/edge (9).** Memoir: `codewalk-robotics-embodied-tier`. ROS2/ROS3-alt
  on Zenoh+DDS (middleware) vs `ruvector-robotics` (behavior-tree cognition, consumes domain-expansion).
  mmwave radar driver; tiny-dancer FastGRNN edge serving. → T11 (MCP = universal control seam).

- **B14 — mincut/graph compute + index zoo (9).** Memoir: `codewalk-mincut-graph-indexzoo`. mincut-gated-
  transformer / attn-mincut(Dinic) / graph-condense / decompiler(ONNX) / acorn / rairs / rulake; router-core
  trap. → T12.

- **B15 — prime-radiant + infra/CLIs (16).** Memoir: `codewalk-prime-radiant-and-infra`. prime-radiant =
  2nd GPU convergence runtime (doc-trap). rvlite/metrics/profiler/bench/CLIs/router-ffi. **All base crates
  done.**

- **B16 — bridge sweep (46 `-wasm/-node`).** Memoir: `codewalk-bridge-sweep`. All cdylib/napi npm artifacts;
  3 classes (thin / rich-API / standalone-wasm-only e.g. ruvllm-wasm). **crates/ COMPLETE.**

- **B17 (bulk, REVERTED) → re-done STRICT in slices.** Overview `codewalk-examples-interconnection` kept
  (T13). Strict slices:
  - **B17a — boundary-discovery astro/geo (6):** boundary-discovery, seti×2, earthquake, cmb, frb. Memoir:
    `codewalk-b17a-boundary-astro-geo`. All = mincut+coherence only; thin main.rs; thesis in every doc.

  - **B17b — boundary bio/social/infra (8):** health, pandemic, market, music, void, weather, infrastructure,
    brain. Memoir: `codewalk-b17b-boundary-agents-predictive`. → T14 (early-warning/perception agent fleet).

  - **B17c — consciousness family (6):** climate/cmb/ecosystem/gene/gw/quantum-consciousness. Memoir:
    `codewalk-b17c-consciousness-phi-agents`. Role = Φ-measurement/emergence-analysis agents (complement to
    B17a/b perception agents) = scientific-discovery agent fleet. One-shot analysis pipelines.

  - **B17d — neuro/bio/temporal (7):** real-eeg×2, seizure-clinical-report, seizure-therapeutic-sim,
    spiking-network(Izhikevich/LIF), rvdna(9-crate genomics + pharmacogenomics), temporal-attractor. Memoir:
    `codewalk-b17d-neuro-bio-temporal`. **Marker false-positives caught** (brain=organ, router=enum) → all
    one-shot capabilities, not self-hosting agents. rvdna = most-composed example.

  - **B17e — exo-ai-2025 library crates (9).** Memoir: `codewalk-b17e-exo-cognitive-substrate`. Self-
    contained "Advanced Cognitive Substrate" SDK on ruvector. exo-federation = PQ-crypto federated-consensus
    *protocol* (transport-agnostic); exo-exotic = Friston active-inference; exo-backend-classical = domain-
    expansion-routed cognitive-cycle runtime. No real network I/O (markers verified false). domain-expansion
    = pervasive routing brain (≥7 consumers).

  - **B17f — exo-ai-2025 research apps (11).** Memoir: `codewalk-b17f-exo-research-prototypes`. ALL
    standalone SIMD prototypes, ZERO internal deps (not integrated), one-shot sims (federated-collective-phi
    simulates consensus in-process, serde-only). Role = research/incubation arm. More markers verified false.

  - **B17g — vibecast-7sense/sevensense (11).** Memoir: `codewalk-b17g-sevensense-bioacoustic`. INDEPENDENT
    DDD bioacoustic product (Qdrant+ONNX+GraphQL), **NOT ruvector** — a co-located sibling, not a system role
    (boundary case for T14). sevensense-api = axum+GraphQL service.

  - **B17h — agentic/integration (5).** Memoir: `codewalk-b17h-agentic-integration`. a2a-swarm (rvAgent
    orchestrator/A2A), verified-applications (verified AgentContracts — KEY S1 input), ospipe (perception
    daemon), robotics (MCP+consensus), refrag (RAG compress). → T15.

  - **B17i — rvf/edge/esp32/onnx (10).** Memoir: `codewalk-b17i-edge-agent-fleet`. Deployed edge-agent fleet:
    ruvector-edge (P2P swarm + ZK + gundb), edge-net (consumes B16 wasm-only crates — patience payoff;
    brain+AMM), ruvllm-esp32 (clustered MCU LLMs), ios (assistant), rvf-kernel-optimized (verified self-boot).
    New ext dep: `ruv-swarm-transport`.

  - **B17j (final) — data ingestion + demos (~18).** Memoir: `codewalk-b17j-data-ingestion-and-demos`.
    data-* = external data feeders (finance/SEC-EDGAR/OpenAlex/sensors); train-discoveries = aggregation/
    learning loop; ruvllm-esp32-flash = "Tiny Agents on SoCs"; + mincut/category/delta math demos. **B17 COMPLETE.**

## THE AGENTIC PIPELINE (B17 synthesis — how the examples form the live system)
DATA FEEDERS (`data-*`: finance/SEC/OpenAlex/sensors → embeddings) → DISCOVERY AGENTS (boundary family =
early-warning perception; consciousness family = Φ/emergence) → AGGREGATION/LEARNING (`train-discoveries`
sublinear ETL; `mcp-brain` collective) → ORCHESTRATION (`a2a-swarm` rvAgent/A2A; MCP seams; `verified-
applications` = formally-verified `AgentContract`s) → EDGE FLEET (`ruvector-edge` P2P+ZK, `edge-net` wasm,
`esp32` tiny-agents, `ios` assistant, `cloudrun` GPU) — all governed by the coherence gate (cognitum) and
persisted/witnessed via RVF. `sevensense`/`exo-research` are the satellite product + incubation arm (off-
substrate). **This is RuVector's agentic automation, end-to-end, proven in code.**

## SYNTHESIS
- **S1 — RuVector→meta mapping: DONE.** Doc: `RUVECTOR-META-MAPPING-S1.md`. Memoir: `s1-ruvector-meta-mapping`.
  Decisive: the Ark Handoff Ledger ≈ already exists in RuVector → adopt the *contract*, map the *engine*
  (RVF+witness=ledger, weave leases=claim, `ruvector-verified`+`AgentContract`=provable work-order =
  `handoff.task.v1`, cognitum-gate=policy, `domain-expansion`=routing, `rvAgent`=runtime, MCP=seam). ~8/12
  Ark crates already exist; only thin `hf` CLI/daemon/test glue is new. Reconciled all 3 provisional decisions
  (SoT→Ark state-precedence not weave-Jobs-crowned; envelope=handoff.task.v1 made provable; v1=the hf loop on
  existing engines). **Still owed: a spike + rename Ark/V2 + decide front-door (gap#2). NOT YET ADOPTED.**

## S2 — LOCKED (user-confirmed) + SPIKE PASSING
- **S2 decisions LOCKED** (`decision-log-2026-06-09` refined to LOCKED): SoT = `.handoff` state-precedence
  (Git>ledger>tasks; weave Jobs = coordination view); envelope = `handoff.task.v1` made provable via
  `ruvector-verified`; front door = prompt_hub intake + RuVocal UI (pgvector=`ruvector-postgres`); ledger v1
  = rusqlite + `rvf-crypto` witness (**RVF vector-native = scheduled v2**); v1 scope = the `hf` loop on
  existing engines; naming = `.handoff`; law = adopt-then-extend, RuVector = foundation. Both re-explores
  resolved (7sense = co-located product/migration target; exo research = incubation incl. a Φ-aware router).
- **SPIKE BUILT + PASSING** (`~/Downloads/tmp/handoff/spike`, `cargo test` 4/4, 5.7s). Memoir:
  `spike-validated-handoff-seam-ledger`. Proves: SwarmBundle→`handoff.task.v1` seam (workflow_id =
  correlation_id), blake3 IntentLock drift sentinel, rusqlite(WAL) event ledger + **real `rvf-crypto`
  witness chain** + replay. ~150 LOC + 1 path-dep, no rebuild.

## NEXT (build-out, post-spike)
- Extend the spike → wire **weave leases** (claim/heartbeat), a **real prompt_hub `SwarmBundle`** (not the
  mirror), and a **`ruvector-verified` AgentContract** proof on completion; then the `hf` CLI verbs.
- Schedule the **RVF vector-native ledger v2** (semantic recall over history) as next-priority.
- Build the `SwarmBundle → handoff.task.v1` dispatch in prompt_hub (the missing outbound wiring) over MCP.
  (exo-core/…/wasm) · B17f exo-ai-2025 research apps (11) · B17g sevensense (11) · B17h rvf/edge/esp32/onnx/
  robotics/data/a2a-swarm/misc (← a2a-swarm + ospipe + verified-applications likely the most overtly agentic).
- **Then S1/S2 synthesis** (RuVector→meta mapping; confirm deferred decisions).
- **S1 — final RuVector→meta mapping:** for each meta need (task store, memory, witness/continuity ledger,
  routing/MoE, agent runtime, vector index), name the RuVector crate(s) to adopt and the trait/MCP seam to
  bind through. Inputs: T1–T13 + the index-zoo (T12) + MCP-seam (T11) + ts→rust (T2) + hot-swap (domain-
  expansion) + the two convergence runtimes (mcp-brain-server, prime-radiant).
- **S2 — confirm the provisional decisions** the mission deferred (weave-Jobs source-of-truth; work-order
  envelope home; v1 scope) now that the substrate is fully mapped.
- (Optional) deep-read a handful of representative examples' *source* (a2a-swarm, one boundary-discovery,
  exo-core) if behavior-level detail is needed beyond the dep map.
