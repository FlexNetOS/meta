# RuVector / ruflo — Multi-Pass Research

> Companion to ICM memoir `system-architecture`. Updated per-pass to avoid context overload.
> **Method:** rust crates + MCP/plugins are the SOURCE OF TRUTH. The `.md` docs in these repos
> are STALE/WRONG (a ruvector claude-hook blocked file edits, so docs froze). Code wins.
> **Status:** these systems are **complete & production-grade** despite looking incomplete at
> first run. "Way more than you think" — expect multiple passes.

## Hardware/entry context
- **Cognitum seed**: physical Pi Zero (64GB) running a full agentic stack, on USB. The
  hardware embodiment of RuVector's coherence-gate tier (`cognitum-gate-*` crates, Hailo NPU).
  Entry point to ruvector/ruflo. Currently **unreachable** (network wall + USB secret-key wall).
  Learn it via its HTML files when reachable.
- **USB secret-key** gates envctl's vault AND is the entry point to ruvector/ruflo.
- **Network issue** (lane will fix) blocks reliable cross-machine reach.

---

## PASS 1 (2026-06-09) — Shape

### What RuVector IS
A massive **distributed cognitive vector-DB + AGI runtime**: ~**216 Rust crates** + ~59 npm pkgs.
Not "just" a vector DB. Layers:
- **Vector core** — `ruvector-core` (HNSW, SIMD/SimSIMD, quantization, REDB).
- **Hypergraph DB** — `ruvector-graph` (Neo4j/Cypher-compatible, RAFT cluster).
- **LLM serving** — `ruvllm` (paged attention, KV-cache; Metal / CUDA / CoreML-ANE / Hailo).
- **Boundary-first scientific discovery** — min-cut, IIT consciousness (Φ); 20+ domain apps
  (SETI, seismic, EEG/seizure, weather, markets/Kalshi…).
- **RVF AGI format** — see below.
- **Shared brain** — π.ruv.io (`mcp-brain-server`, Firestore/GCS, differential privacy).
- **Hardware** — SIMD/CUDA/Metal + **Hailo-10H NPU** (Pi 5); 24 `-wasm` crates.

### What ruflo IS
**ruflo = claude-flow v3** — a **TypeScript/Node agent-orchestration runtime** (`claude-flow@3.10.x`).
Live source = `v3/` (`@claude-flow/{cli,guidance,memory,security,hooks,codex}` + `plugins/`);
legacy = `ruflo/` subdir. 60+ agents, MoE routing, MCP server (40+ tools), 350+ commands via
`.claude-plugin/`. It is the **host** that surfaces RuVector to Claude Code.

### The connection (rvf kernel + wasm)
- **RVF = RuVector Format**: binary append-only vector store (segments + manifest + HNSW +
  quantization Int8/RaBitQ + **ed25519 witness/proof chain** + compaction). Crate cluster
  `RuVector/crates/rvf/` (`rvf-runtime` = VM, `rvf-kernel` = temporal bytecode, +types/crypto/
  wire/ebpf/index/quant/federation/adapters). `agentdb.rvf` in ruflo = AgentDB on RVF.
- **The bridge:** RuVector crates → **WASM (wasm-bindgen)** → ruflo **lazy-loads** them with JS
  fallback (exemplar `v3/plugins/gastown-bridge` loads `gastown-formula-wasm` + `ruvector-gnn-wasm`,
  150–352× speedups) → `rvf-adapters/claude-flow` bridges ruflo's `@claude-flow/memory` `RvfBackend`
  to `rvf-runtime`'s `RvfStore`. Plain wasm-bindgen ES-module exports (no WIT/component model).
- **Direction:** ruflo **consumes** RuVector (WASM + RVF). RuVector has **no** ruflo dependency.
  So "RuVector needs ruflo to work" = ruflo is the *agentic/plugin entry point* to RuVector.

### Cognitum
`cognitum-gate-kernel` + `cognitum-gate-tilezero` = hardware coherence gate for Pi 5 / Hailo
TileZero. `mcp-gate` exposes anytime-valid coherence permission/veto (ADR-178). The Pi Zero
"cognitum seed" is this tier's physical embodiment.

### Open questions → PASS 2 candidates
1. **RVF on-disk format + VM** — read `rvf-runtime`/`rvf-kernel` src: segment layout, bytecode,
   witness chain. (Most foundational.)
2. **The wasm runtime mechanics** — is loading Node-native WASM, wasmtime, or wasmer? exact
   `wasm-loader.ts` path; how a RuVector crate becomes a ruflo-callable plugin end-to-end.
3. **π.ruv.io shared brain** — `mcp-brain-server` architecture, privacy, reachability.
4. **rvAgent framework** — `rvAgent/*` (DeepAgents→Rust); how it relates to ruflo's agents.
5. **Cognitum-gate in practice** — the coherence/permission model; ties to the hardware seed.
6. **ruvix** (`crates/ruvix/`) — "Cognition Kernel," AArch64 bare-metal — separate OS/runtime?

---

## PASS 2 (2026-06-09) — RVF kernel internals + wasm path

### The .rvf format (code-verified)
Segment-typed binary container (`rvf-types/src/segment_type.rs`): Vec/Index(HNSW)/Hot/Meta/
Journal/Manifest/Quant/Sketch/**Witness**/Crypto/Profile/**Kernel**/**Ebpf**/**Wasm**/Dashboard/
CowMap/Refcount/Membership/Delta. **Two-level manifest:** Level 0 root = fixed 4096 B at EOF
(magic `RVM0`, hotset pointers, CRC32C → **<5ms boot**, approx-query without Level 1); Level 1 =
variable TLV segment directory (async, full quality). `RvfStore` (rvf-runtime): create/open/
ingest_batch/query/query_with_envelope/compact/delete/write_manifest + COW engine + membership
filter + parent path (**branching**). Index = **3-layer progressive HNSW** (A <5ms ~0.70 → C full
≥0.95 recall). Quant = Scalar/Product/BinaryThreshold/ResidualPq.

### KEY INSIGHT — .rvf is a self-bootstrapping compute container
`rvf-kernel` is **not a bytecode VM** — the container **embeds real executables**: `rvf-kernel`
embeds a Linux **bzImage** / Hermit unikernel / Asterinas; `rvf-wasm` embeds WASM with roles
(**Microkernel 0x00 = ~5.5KB "Cognitum tile runtime"**, Interpreter, Combined, Extension,
ControlPlane; targets Wasm32/WASI/Browser/**BareTile**); `rvf-ebpf` embeds **eBPF** (XDP distance
in the NIC/kernel fast path). `rvf-types` is **no_std** (wasm/embedded/Hailo/TEE). So a `.rvf` is a
portable, self-executing, vector-native compute artifact — *that's* the "way more than you think."
The "Cognitum tile runtime" links straight to the cognitum seed hardware.

### Witness / governance
Tamper-evident chain (`rvf-crypto/src/witness.rs`): `WitnessEntry{prev_hash, action_hash=
SHAKE-256(action), timestamp_ns, type}` (73 B, chained). Governance (`rvf-runtime`):
Restricted/Approved/Autonomous modes; PolicyCheck Allowed/Denied/Confirmed; per-task **Witness
Bundle** (spec/plan/tool-trace/diff/test/outcome/cost/latency). Policy is **embedded in the
container**, ed25519-signed — not a central authority.

### The wasm path (code-verified)
BUILD: RuVector crate (`cdylib`, `#[wasm_bindgen]`) → `wasm-pack build --target web` + `wasm-opt`
→ npm `@claude-flow/plugin-gastown-bridge`. LOAD: ruflo uses **Node's native `WebAssembly`** via
`import()` (`wasm-loader.ts` LazyWasm, 5-min idle unload, LRU caches) — **NOT wasmtime/wasmer**.
EXEC: MCP tool → handler → `LazyWasm.get()` → wasm fn (JSON in/out) → cache; **JS fallback** if
WASM unavailable. Registration is **manual per-plugin** (no auto-scan).

### ⚠ Discrepancy to resolve (pass 3)
ruflo's `@claude-flow/memory` `RvfBackend` (`rvf-backend.ts`) is **TypeScript** (HnswLite + sql.js),
**not** the Rust `rvf-runtime`. Two paths exist: **compute** = RuVector Rust→wasm (gastown);
**memory** = a TS "RVF-lite". Open: does ruflo ever use the full Rust `rvf-runtime` (via napi?),
or only the TS lite? This matters for "is the production RVF actually wired into ruflo."

---

## Cognitum seed — activation (from seed.cognitum.one/guide.html)
**Zero-config edge appliance** (Raspberry Pi, Cortex-A53/512MB, Rust `cognitum-agent`). On USB it
exposes **3 interfaces automatically, no unlock key**: (1) USB mass-storage `COGNITUM` (FAT32, holds
guide + trust certs); (2) USB-net gadget **RNDIS/ECM at `169.254.42.1`**; (3) mDNS **`cognitum.local`**.
- SSH: `ssh genesis@169.254.42.1` (pw `cognitum`). HTTP API on :80 (reads open). **MCP at `/mcp`**.
- Subsystems: RVF vector store (`/var/lib/cognitum/rvf-store/*.rvf`), sensor loop, thermal governor,
  temporal coherence, cognitive container (spectral graph /30s), MCP proxy, mesh overlay.
- Writes need a bearer token via pairing ceremony (`POST /api/v1/pair/window` → `/api/v1/pair`).
- **Reconciliation flag:** guide says seed needs **no secret key**, so the envctl secret-key USB is
  almost certainly a **different device** than the cognitum seed. Don't conflate them.

### Open for PASS 3 (candidates)
1. Resolve the **TS-RVF vs Rust-rvf-runtime** discrepancy (napi? is prod RVF wired into ruflo?).
2. The `.rvf` **Cognitum tile microkernel** 14 wasm exports — what API does a tile expose?
3. **π.ruv.io shared brain** + how the seed's `/mcp` + mesh overlay federate (rvf-federation).
4. **rvAgent** vs ruflo agents vs **weave** — three orchestration layers; how they relate.
5. **ruvix** "Cognition Kernel" (AArch64 bare-metal) — separate OS, or the seed's runtime?

---

## PASS 3 (2026-06-09) — RVF wiring: is the Rust path actually used in ruflo?

**Dev pattern (user-authoritative):** ruvnet builds TS-first → ports to **rust-native**, keeps old
TS for backward-compat. claude-flow(TS)→ruflo(rust upgrades). Rust = canonical; TS = legacy/fallback;
**napi-rs** is the bridge. Breadcrumbs: `ruvnet/agentdb`, napi refs at `ruvnet/ruv.io`.

**Confirmed (solid):** the napi Rust path **ships** — `@ruvector/rvf` → `@ruvector/rvf-node`
(napi crate `RuVector/crates/rvf/rvf-node`, wraps **`rvf-runtime` 0.2.0**, exports `RvfDatabase`:
create/open/query/ingestBatch/delete/compact/status). Prebuilt `rvf-node.linux-x64-gnu.node`
present for this box. ruflo backend priority (`v3/@claude-flow/memory/database-provider.ts`):
**RVF → better-sqlite3 → sql.js → JSON.**

**Tentative verdict (invites confirmation):** per the agent's read, ruflo's `RvfBackend`
lazy-imports `@ruvector/rvf` and stores `nativeDb`, **but executes via pure-TS `HnswLite`**;
`agentdb-backend` uses a TS `HNSWIndex`. ⇒ the napi addon is **loaded-but-idle** and **TS is the
active default** in ruflo *today*. `rvf-migration.ts` migrates legacy JSON/sqlite → `RvfBackend`.

**⚠ Contradiction to resolve:** an **ADR-125** note suggests *inlining HnswLite to phase OUT the
native path in favor of TS* — the **opposite** of the stated TS→Rust pattern. Either the agent
misread ADR-125, or ruflo deliberately reverted to TS for portability. **Needs user/empirical confirm.**

**Scope note:** this is about **ruflo's wiring state only** — it does **not** contradict that
RuVector's Rust `rvf-runtime` is complete/production-grade. `agentdb` = separate npm pkg
(`ruvnet/agentdb`) imported by `agentdb-backend.ts`.

### Open for PASS 4 (candidates)
1. **Confirm the verdict empirically** — actually run ruflo and check which backend logs as active
   (RVF-native vs TS), and read ADR-125 directly to settle the contradiction.
2. **Inspect `ruvnet/agentdb`** (and its `agentdb.rvf`) — is AgentDB the high-level API over rvf-node?
3. **rvAgent vs ruflo agents vs weave** — the three orchestration layers (queued from pass 1).
4. **Cognitum tile microkernel** 14 wasm exports; ruvix bare-metal kernel.

---

## PASS 4a (2026-06-09) — Crate graph: PROVEN interconnected (not separate examples)

**Method:** parsed all **213 `Cargo.toml`** manifests for internal dep edges (`/tmp/crate_graph.py`).
Pure code, no interpretation. **Result: 340 internal edges; 149/213 crates depend on ≥1 sibling.**
The "domain examples" are not islands — they share hub crates.

**Top hubs (in-degree):** `rvf-types` 26 · `ruvix-types` 25 · `ruvector-core` 24 · **`ruvector-mincut` 16**
· `rvf-runtime` 16 · `ruvector-attention` 10 · `rvf-crypto` 9 · `ruvector-gnn` 8 · `ruvix-cap` 8 ·
`rvagent-core` 8 · `ruvector-graph` 7.

**Three interlocking clusters that converge:**
1. **Vector/compute core** — `ruvector-core` → `gnn`/`graph`/`mincut`/`attention` → `ruvllm` +
   `consciousness`/`perception`/`neural-trader`/`prime-radiant`.
2. **RVF format/runtime** — `rvf-types` → `rvf-runtime`/`crypto`/`wire` → `rvf-node` +
   **`rvf-adapter-claude-flow`** (the ruflo bridge, a real Rust crate) / `rvf-adapter-agentdb`/`-sona`.
3. **`ruvix` Cognition Kernel** — `ruvix-types` → `ruvix-{cap,region,queue,hal}` (bare-metal subsystem).

**Interconnection proof (code):**
- `ruvector-mincut` ← 18 dependents incl `cognitum-gate-kernel`, `cognitum-gate-tilezero`,
  `consciousness`, `perception`, `crv`, `graph-transformer`, `mcp-brain-server`, `prime-radiant`, `ruqu`.
- `ruvllm` → `{attention,core,full,gnn,graph,sona}`; ← `mcp-brain-server`, `prime-radiant`,
  `ruvector-hailo-cluster`, `ruvllm_retrieval_diffusion`.
- **Convergence:** `mcp-brain-server` depends on **`mincut` + `ruvllm` + `rvf-runtime`** — all three
  clusters at once. The integration is literal, in the manifests.

> Bearing on the RVF-wiring verdict: `rvf-adapter-claude-flow` (Rust → `rvf-runtime`) **exists as a
> real crate**, so the Rust path *into ruflo* is built; whether ruflo *executes* through it by
> default is still the open pass-3 question (resolve empirically).

### Open for PASS 4b+ (functional, multi-pass)
1. **Hub functional deep-dive** — read `ruvector-core` + `mincut` + `attention`: what's the shared
   abstraction every domain crate builds on? (the "one system" thesis, at the API level)
2. **ruvix Cognition Kernel** — cap/region/queue/hal: is it an OS? how does it host tiles / the seed?
3. **The convergence crate `mcp-brain-server`** — how it composes mincut+ruvllm+rvf into the brain.
4. **`rvf-adapter-claude-flow`** source — settle whether/how ruflo routes through Rust rvf-runtime.

---

## PASS 4b (2026-06-09) — The unifying abstraction (code-proven)

Read directly (not via subagent — see hazard note): `ruvector-core/src/{types.rs,index.rs}`,
`ruvector-attention/src/traits.rs`, `ruvector-mincut/src/lib.rs`.

**Verdict:** RuVector is unified **not by one god-trait** but by a **small orthogonal trait set over
one datum — the vector `Vec<f32>`.** Four layers, each a thin trait surface the rest compose:

1. **Vector** (`ruvector-core`): `VectorEntry{id, vector: Vec<f32>, metadata}`,
   `DistanceMetric{Euclidean|Cosine|DotProduct|Manhattan}`, and the central
   **`trait VectorIndex { add; search(query,k)->Vec<SearchResult>; remove; len }`**
   (`core/src/index.rs:11`) + `EmbeddingProvider` (text→vector).
2. **Graph** (`ruvector-graph` + `ruvector-mincut`): vectors become nodes; `EdgeInfo{src,dst,features}`.
   mincut exposes `DynamicMinCut`/`DynamicConnectivity`/`ExpanderDecomposition`/`Conductance`/
   `Cluster`/`ClusterHierarchy`/`EulerTourTree`/`LinkCut` + certificate/witness = the
   **boundary/coherence primitive** on dynamic graphs.
3. **Attention/geometry** (`ruvector-attention`): trait hierarchy **`Attention` → `GraphAttention`
   (over `EdgeInfo`) → `GeometricAttention` (curvature)** + Sparse/Trainable; plus modules
   hyperbolic, curvature, topology, transport, info_bottleneck, **info_geometry (Fisher/NaturalGradient)**,
   **pde_attention (GraphLaplacian/diffusion)**, sheaf = weighted propagation over the vector-graph in
   Euclidean/hyperbolic/information-geometric space.
4. **Domain** crates **compose 1–3, defining no new substrate**: `ruvector-consciousness` =
   mincut+coherence+solver+sparsifier+math+cognitive-container (IIT-Φ); `ruvllm` =
   attention+gnn+graph+core+sona.

**The thesis, in one line:** *coherence-aware hypergraph* — **nodes = vectors, edges = graph,
weights = attention, boundaries/clusters = mincut, persistence = RVF.** Corroborated by RuVector's
own `CLAUDE.md`: `brain_partition` = "get MinCut clusters", brain = 1,500+ memories / 350K+ edges.

> ⚠ **Method hazard:** subagents spawned in these repos get **hijacked by the envctl/forge-loop +
> weave session-relay hooks** (one returned forge-loop "backlog item-2" chatter instead of its
> report). Read crate files **directly** for ruvector/ruflo/envctl work.

### Open for PASS 5 (candidates)
1. **ruvix Cognition Kernel** (cap/region/queue/hal) — the bare-metal OS layer that runs tiles/seed.
2. **`mcp-brain-server`** — how it composes mincut+ruvllm+rvf into π.ruv.io (the convergence crate).
3. **`rvf-adapter-claude-flow`** source — settle the ruflo↔Rust-RVF routing verdict.

---

## PASS 5 (2026-06-09) — ruvix (the OS) + mcp-brain-server (the convergence)

### RuVix = a real bare-metal OS
`crates/ruvix/` is a nested workspace and its README is explicit: **"RuVix Cognition Kernel — An
Operating System for the Agentic Age"** that "understands vectors, graphs, proofs, and coherence
scores natively." `no_std`, `_start`, **`kernel8.img`**, **`bcm2711`** (Pi-4-class SoC).
Members: `nucleus` (microkernel), `boot` (+attestation, capability_distribution, manifest), `cap`
(capability security), `sched`, `physmem`/`dma`/`dtb`/`smp`, `hal`/`aarch64`/`drivers`, `net`/`fs`,
`proof` (proof engine), **`vecgraph` (vectors+graphs native IN-KERNEL)**, `queue`, `region`, `types`.
**Kernel API:** `Kernel`/`KernelConfig`/`Syscall`/`VectorStoreConfig`/`ProofTier`/`VectorKey`/
`Checkpoint` — **syscalls operate on vectors**, in-kernel vector store, proof tiers, attested
capability boot. ⇒ the substrate (coherence-aware hypergraph) baked into an **OS** — the runtime that
powers the **cognitum seed** (ties to `rvf-wasm` `BareTile` + `cognitum-gate-tilezero`).
*HW nuance:* ruvix targets `bcm2711` (Pi 4/CM4), but the seed was called "Pi Zero" and
`cognitum-gate-tilezero` says "Pi 5" — reconcile the seed's actual board later.

### mcp-brain-server = the convergence crate (π.ruv.io)
Its `Cargo.toml` **literally composes all three clusters**: `sona`, `mincut`(canonical),
`nervous-system`, `domain-expansion`, `delta-core`, `solver`(forward-push), `sparsifier`,
`consciousness`(phi), `ruvllm`(minimal) **+ rvf-types/crypto/wire/federation/runtime**. Modules:
store/graph/cognitive/drift/symbolic/trainer/optimizer/ranking/reputation/aggregate/embeddings +
web_ingest/web_memory/web_store + **pubmed** (scientific ingest) + **gcs** + voice + auth/rate_limit +
routes/verify; bin `ruvllm-embedder`. ⇒ a **federated** (`rvf-federation`) RVF vector store + mincut
partitioning + IIT-Φ consciousness + ruvllm embeddings + drift, over HTTP + brain MCP
(`brain_search`/`share`/`partition`=MinCut clusters/`drift`). Per RuVector `CLAUDE.md`: 1,500+
memories, 350K+ edges, deployed as `ruvbrain` on Cloud Run, DP ε=1.0, 7 scheduler optimization jobs.
**This is the literal proof that mincut + ruvllm + rvf are one system.**

### Stack-health note (user-confirmed)
The autonomous **loops + session-relay hooks still run on OLD weave-repowire** (pre-merge), are
**broken/misconfigured, and break tooling** (they hijack subagents). This is the same envctl drift —
the loops never migrated to current weave. Fix = migrate loops/hooks to current weave + scope hooks
out of subagent/headless contexts.

### Open for PASS 6 (candidates)
1. **`rvf-adapter-claude-flow`** — still the cleanest way to settle the ruflo↔Rust-RVF routing verdict.
2. **rvAgent vs ruflo agents vs weave** — three orchestration layers; reconcile for the source-of-truth decision.
3. **Reconcile the cognitum seed board** (Pi Zero vs CM4/bcm2711 vs Pi 5) once it's reachable at boot.

---

## PASS 6 (2026-06-09) — RVF wiring VERDICT (code-proven; settles the pass-3 tentative)

Read **directly** (not via subagent): the Rust adapter crate + the actual ruflo TS memory backend.

### The Rust adapter crate — complete but ORPHANED
`RuVector/crates/rvf/rvf-adapters/claude-flow` (`rvf-adapter-claude-flow` v0.1.0) is a **complete,
fully-tested pure-Rust library**: `RvfMemoryStore` wraps `RvfStore`/`rvf-runtime` directly (deps:
rvf-types/runtime/crypto), maps claude-flow's key/value/namespace/tags/embedding model onto RVF
segments (`ingest_batch`/`query`/`delete`/`compact`), with a SHAKE-256 `WitnessChain` audit trail.
**9 passing tests.** BUT it's a plain **`rlib`** — no `cdylib`, no `wasm-bindgen`, no `napi`. It is
depended on by **nothing** (only listed in `crates/rvf/Cargo.toml` workspace; zero Rust re-exports)
and **imported by no TS** — the only hit for "rvf-adapter-claude-flow" in the whole TS/JS/JSON
corpus is a *description string* in `docs/research/.../ruvector-knowledge.rvf.json`. ⇒ a Rust-native
reference impl of claude-flow memory that is **not wired into anything**.

### The actual ruflo memory backend — TS is the real path; napi is dead weight
`ruflo/v3/@claude-flow/memory/src/rvf-backend.ts` `RvfBackend`:
- `initialize()` → `tryNativeInit()` does `import('@ruvector/rvf')`, `new RvfDatabase(...)`, `.open()`,
  sets `this.nativeDb`. **On success it does NOT create `hnswIndex` and SKIPS `loadFromDisk()`.**
- **`nativeDb` is referenced in exactly 3 non-operational places:** the verbose mode-string,
  `healthCheck()` (reports it "healthy"), and `shutdown()` (`.close()`). **NO** `store`/`search`/
  `query`/`delete`/`bulkInsert`/`clearNamespace`/`count` ever calls `nativeDb.*`.
- Every operation runs over the in-memory JS **`Map` (`this.entries`)** + the pure-TS **`HnswLite`**
  index; `search()` falls to `bruteForceSearch` when `hnswIndex` is null. In native mode `hnswIndex`
  IS null ⇒ search degrades to brute-force AND prior data is never loaded (`loadFromDisk` skipped).
- ⇒ **the napi Rust RVF handle is opened, health-reported, and closed — but never used.** It's
  vestigial. **TS `HnswLite`/`Map` is THE active default.**

### Contradictions from earlier passes — RESOLVED
- **ADR-125** ("inline HnswLite, phase out native") is no longer a contradiction: the code *matches*
  it. `rvf-backend.ts:17-19` comment calls HnswLite **"the single HNSW implementation in the public
  surface."** ruflo deliberately runs TS for portability; native is a stub left in place.
- `database-provider.ts` picks **RVF first**, but its own comment (L115-122) says RVF "available" is
  **"always true — pure-TS fallback."** So "RVF selected" ≠ "Rust executing." Priority chain stands:
  RVF(=TS) → better-sqlite3 → sql.js → JSON.

### Where the Rust napi path IS real (the nuance that keeps the verdict honest)
The production-grade Rust `rvf-runtime` IS exercised via napi — just in a **different layer**: the
**intelligence/benchmark path** `dist/ruvector/vector-db.js` (`loadRuVector`/`createVectorDB`), which
is the source of the **measured ~1.9x–4.7x HNSW "ruvector NAPI" numbers** in ruflo's CLAUDE.md — NOT
the agent memory store. A third path, `agentdb-backend.ts`, uses the separate **`agentdb` npm pkg's
`HNSWIndex`** (gated on `this.agentdb && HNSWIndex`), also not the claude-flow Rust adapter.

### VERDICT (one line)
**ruflo's claude-flow *memory* subsystem defaults to pure-TS (Map + HnswLite); the napi `@ruvector/rvf`
handle is loaded-but-dead in `RvfBackend`, and the dedicated Rust adapter crate is complete-but-orphaned.
The Rust RVF runtime is production-grade and used via napi elsewhere (the ruvector intelligence/benchmark
layer), not in the agent memory store.** This *confirms and strengthens* the pass-3 tentative read.

> ⚠️ **PASS 6 CORRECTION (same day) — the verdict above was scoped TOO NARROW.** It generalized from
> the `@claude-flow/memory` `RvfBackend` alone and missed the real operational Rust consumers. The
> facts about `RvfBackend` (TS Map+HnswLite, dead napi handle, orphaned adapter crate) all **stand** —
> but "Rust RVF isn't wired into ruflo" is **wrong**. See PASS 6b below.

---

## PASS 6b (2026-06-09) — CORRECTION: Rust RVF *is* wired into ruflo (four paths, two bridges)

Triggered by user challenge ("you missed the kernel/wasm bridge — rvf-runtime probably feeds it").
A full operational sweep (`grep` for `@ruvector/rvf|RvfDatabase|rvf-wasm|loadRuVector|createVectorDB`
across **all** of ruflo, not just `@claude-flow/memory`) found the consumers I'd skipped.

**Four vector/RVF paths — the Rust ones are the real ones:**

| Path | Resolves to | Rust? | Consumers |
|---|---|---|---|
| `@claude-flow/memory` `RvfBackend` | TS `Map`+`HnswLite` (napi handle dead) | ❌ TS | legacy memory KV |
| `@claude-flow/memory` `agentdb-backend` | `agentdb` npm `HNSWIndex` | sep. pkg | hybrid memory |
| **`cli/src/ruvector/vector-db.ts` → `ruvector` npm facade** | `@ruvector/core`(native) → **`@ruvector/rvf`=`rvf-node`→`rvf-runtime`** → **`@ruvector/rvf-wasm`=`rvf-wasm`** → stub | ✅ **native OR wasm** | **6 intelligence plugins** (semantic-code-search, intent-router, sona-learning, reasoning-bank, hook-pattern-library, mcp-tool-optimizer) + graph-analyzer + benchmark |
| **`plugins/ruflo-core/scripts/witness/lib.mjs` `loadRvfNode`** | **`@ruvector/rvf-node`→`rvf-runtime`** → JSONL fallback | ✅ napi | **witness / audit chain** |

- The facade (`npm/packages/ruvector/src/index.ts`) `require`s `@ruvector/rvf`, defaults
  `implementationType='wasm'`, exposes `isWasm()`, and persists to `.rvf` (`createVectorDB` writes
  `ruvector-<pid>.rvf`). ruflo `package.json` deps: `ruvector ^0.2.27` **+** `@ruvector/rvf-wasm 0.1.5`.
- I had dismissed `dist/ruvector/vector-db.js` as "just benchmarks" — it's the facade feeding **six
  production plugins** + SONA + graph analysis.

**The two bridges, made precise (answers the user's kernel/wasm hypothesis):**
- **Native/napi bridge** = `@ruvector/rvf`/`@ruvector/rvf-node` ← `rvf-node` ← **`rvf-runtime`** (full std VM).
- **WASM bridge** = `@ruvector/rvf-wasm` ← **`rvf-wasm`**. Its `package.json` build = `cargo build
  --target wasm32-unknown-unknown … rvf-wasm/Cargo.toml && wasm-opt -Oz`. And `rvf-wasm` depends on
  **only `rvf-types`+`rvf-crypto`, NOT `rvf-runtime`** (no_std, `dlmalloc` global alloc).
- ⇒ native and wasm are **two interchangeable backends behind the `ruvector` facade**, bridged by the
  **`.rvf` container format (`rvf-types`) + `rvf-crypto`** — *not* by compiling `rvf-runtime` to wasm.
  `rvf-kernel` (also rvf-types-only) likewise produces embedded Kernel-segment payloads; it couples to
  the host store via the **format**, not a call graph. So "rvf-runtime feeds the wasm/kernel bridge"
  is true at the **data/format level**, false at the **code-dependency level** — they're siblings over
  `rvf-types`, which is exactly why the pass-4a crate graph showed `rvf-types` as the #1 hub (26 deps).

**CORRECTED VERDICT:** the production Rust RVF — `rvf-runtime` (native/napi) **and** `rvf-wasm` (wasm) —
**IS operationally wired into ruflo**, through the `ruvector` intelligence facade (6 plugins) and the
ruflo-core witness subsystem. The lone exception is the legacy `@claude-flow/memory` KV backend, whose
napi handle is dead. "Is production RVF wired into ruflo?" = **YES.**

### Open for PASS 7 (candidates)
1. **rvAgent vs ruflo agents vs weave** — the three orchestration layers; reconcile for the
   source-of-truth decision (now the top remaining unknown).
2. Remaining ruvector clusters: **sona, nervous-system, delta-\*, consciousness, the domain crates**.
3. **Reconcile the cognitum seed board** (Pi Zero vs CM4/bcm2711 vs Pi 5) once reachable at boot.
