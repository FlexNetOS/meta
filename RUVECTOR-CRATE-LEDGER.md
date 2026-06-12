# RuVector Crate Coverage Ledger

> Durable tracker for the exhaustive crate walk. `[x]` = thoroughly walked (purpose+API+interconnect captured to memoir). `[~]` = surface-described (Cargo desc only). `[ ]` = untouched.
> Total: 314 crates across 196 clusters. Seeded 314 with Cargo descriptions where present.
> Method: read crates DIRECTLY (Bash/Read), never subagents (hijack hazard). Flush each cluster to memoir `system-architecture` + update this file.

## crates/ruvix  (28 crates)  [x cluster-level]
- [x] `(workspace)` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/ruvix`  ✅code-walked B7
- [x] `ruvix-bench` — Comprehensive benchmarks comparing RuVix Cognition Kernel against Linux syscalls  ·  `crates/ruvix/benches`  ✅code-walked B7
- [x] `ruvix-aarch64` — AArch64 support for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/aarch64`  ✅code-walked B7
- [x] `ruvix-bcm2711` — BCM2711/BCM2712 SoC drivers for Raspberry Pi 4/5 (RuVix Phase D)  ·  `crates/ruvix/crates/bcm2711`  ✅code-walked B7
- [x] `ruvix-boot` — RVF boot loading for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/boot`  ✅code-walked B7
- [x] `ruvix-cap` — seL4-inspired capability management for the RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/cap`  ✅code-walked B7
- [x] `ruvix-cli` — Host-side CLI tool for RuVix cognition kernel  ·  `crates/ruvix/crates/cli`  ✅code-walked B7
- [x] `ruvix-dma` — DMA controller abstraction for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/dma`  ✅code-walked B7
- [x] `ruvix-drivers` — Device drivers for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/drivers`  ✅code-walked B7
- [x] `ruvix-dtb` — Device Tree Blob parser for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/dtb`  ✅code-walked B7
- [x] `ruvix-fs` — Minimal filesystem for the RuVix Cognition Kernel (ADR-087 Phase E)  ·  `crates/ruvix/crates/fs`  ✅code-walked B7
- [x] `ruvix-hal` — Hardware Abstraction Layer for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/hal`  ✅code-walked B7
- [x] `ruvix-net` — Minimal networking stack for the RuVix Cognition Kernel (ADR-087 Phase E)  ·  `crates/ruvix/crates/net`  ✅code-walked B7
- [x] `ruvix-nucleus` — Integration crate for RuVix Cognition Kernel - syscall dispatch, deterministic replay, and full acceptance tests (ADR-087)  ·  `crates/ruvix/crates/nucleus`  ✅code-walked B7
- [x] `ruvix-physmem` — Physical memory allocator for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/physmem`  ✅code-walked B7
- [x] `ruvix-proof` — Proof engine with 3-tier routing for the RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/proof`  ✅code-walked B7
- [x] `ruvix-queue` — io_uring-style ring buffer IPC for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/queue`  ✅code-walked B7
- [x] `ruvix-region` — Memory region management for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/region`  ✅code-walked B7
- [x] `ruvix-rpi-boot` — Raspberry Pi boot support for RuVix Cognition Kernel (Phase D)  ·  `crates/ruvix/crates/rpi-boot`  ✅code-walked B7
- [x] `ruvix-sched` — Coherence-aware scheduler for the RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/sched`  ✅code-walked B7
- [x] `ruvix-shell` — In-kernel debug shell for the RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/shell`  ✅code-walked B7
- [x] `ruvix-smp` — Symmetric Multi-Processing support for RuVix Cognition Kernel (ADR-087 Phase C)  ·  `crates/ruvix/crates/smp`  ✅code-walked B7
- [x] `ruvix-types` — No-std kernel interface types for the RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/types`  ✅code-walked B7
- [x] `ruvix-vecgraph` — Kernel-resident vector and graph stores for RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/crates/vecgraph`  ✅code-walked B7
- [x] `ruvix-demo` — Comprehensive RVF package demonstrating ALL RuVix kernel features (ADR-087)  ·  `crates/ruvix/examples/cognitive_demo`  ✅code-walked B7
- [x] `rvf-swarm-demo` — RVF Swarm Demo - Multi-agent coordination on RuVix  ·  `crates/ruvix/examples/rvf-demos/swarm-consensus`  ✅code-walked B7
- [x] `ruvix-qemu-swarm` — QEMU swarm simulation for distributed RuVix cluster testing  ·  `crates/ruvix/qemu-swarm`  ✅code-walked B7
- [x] `ruvix-integration` — Integration tests for the RuVix Cognition Kernel (ADR-087)  ·  `crates/ruvix/tests`  ✅code-walked B7

## crates/rvf  (26 crates)  [x cluster-level]
- [x] `(workspace)` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/rvf`  ✅code-walked B6
- [x] `rvf-benches` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/rvf/benches`  ✅code-walked B6
- [x] `rvf-adapter-agentdb` — AgentDB adapter for RuVector Format -- maps agent memory to RVF segments  ·  `crates/rvf/rvf-adapters/agentdb`  ✅code-walked B6
- [x] `rvf-adapter-agentic-flow` — Agentic-flow swarm adapter for RuVector Format -- maps inter-agent memory, coordination state, and learning patterns to RVF segments  ·  `crates/rvf/rvf-adapters/agentic-flow`  ✅code-walked B6
- [x] `rvf-adapter-claude-flow` — RVF adapter for claude-flow memory subsystem — stores memory entries as RVF files with WITNESS_SEG audit trails  ·  `crates/rvf/rvf-adapters/claude-flow`  ✅code-walked B6
- [x] `rvf-adapter-ospipe` — OSpipe adapter for RuVector Format -- maps observation state vectors to RVF with META_SEG  ·  `crates/rvf/rvf-adapters/ospipe`  ✅code-walked B6
- [x] `rvf-adapter-rvlite` — Lightweight embedded vector store adapter for RuVector Format -- minimal API over RVF Core Profile  ·  `crates/rvf/rvf-adapters/rvlite`  ✅code-walked B6
- [x] `rvf-adapter-sona` — SONA adapter for RuVector Format -- stores learning trajectories, neural patterns, and experience replay buffers as RVF segments  ·  `crates/rvf/rvf-adapters/sona`  ✅code-walked B6
- [x] `rvf-cli` — Unified CLI for RuVector Format vector stores  ·  `crates/rvf/rvf-cli`  ✅code-walked B6
- [x] `rvf-crypto` — RuVector Format cryptographic primitives -- SHA-3 hashing and Ed25519 signing  ·  `crates/rvf/rvf-crypto`  ✅code-walked B6
- [x] `rvf-ebpf` — Real eBPF programs for RVF vector distance computation  ·  `crates/rvf/rvf-ebpf`  ✅code-walked B6
- [x] `rvf-federation` — Federated RVF transfer learning -- PII stripping, differential privacy, federated averaging  ·  `crates/rvf/rvf-federation`  ✅code-walked B6
- [x] `rvf-import` — Import tools for migrating data from JSON, CSV, and NumPy formats into RVF stores  ·  `crates/rvf/rvf-import`  ✅code-walked B6
- [x] `rvf-index` — RuVector Format progressive HNSW indexing with Layer A/B/C tiered search  ·  `crates/rvf/rvf-index`  ✅code-walked B6
- [x] `rvf-kernel` — Real Linux microkernel builder for RVF cognitive containers  ·  `crates/rvf/rvf-kernel`  ✅code-walked B6
- [x] `rvf-launch` — QEMU microVM launcher for RVF cognitive containers  ·  `crates/rvf/rvf-launch`  ✅code-walked B6
- [x] `rvf-manifest` — RuVector Format two-level manifest system for segment tracking and compaction  ·  `crates/rvf/rvf-manifest`  ✅code-walked B6
- [x] `rvf-node` — RuVector Format Node.js N-API bindings for native vector operations  ·  `crates/rvf/rvf-node`  ✅code-walked B6
- [x] `rvf-quant` — RuVector Format temperature-tiered vector quantization (f32/f16/u8/binary)  ·  `crates/rvf/rvf-quant`  ✅code-walked B6
- [x] `rvf-runtime` — RuVector Format runtime -- RvfStore API, compaction, and streaming I/O  ·  `crates/rvf/rvf-runtime`  ✅code-walked B6
- [x] `rvf-server` — RuVector Format TCP/HTTP streaming server with REST API  ·  `crates/rvf/rvf-server`  ✅code-walked B6
- [x] `rvf-solver-wasm` — RVF self-learning temporal solver WASM module — Thompson Sampling, PolicyKernel, three-loop architecture  ·  `crates/rvf/rvf-solver-wasm`  ✅code-walked B6
- [x] `rvf-types` — RuVector Format core types -- segment headers, enums, flags  ·  `crates/rvf/rvf-types`  ✅code-walked B6
- [x] `rvf-wasm` — RuVector Format WASM microkernel for browser and edge vector operations  ·  `crates/rvf/rvf-wasm`  ✅code-walked B6
- [x] `rvf-wire` — RuVector Format wire format reader/writer -- zero-copy segment serialization  ·  `crates/rvf/rvf-wire`  ✅code-walked B6
- [x] `rvf-integration-tests` — Integration and acceptance tests for the RVF crate family  ·  `crates/rvf/tests/rvf-integration`  ✅code-walked B6

## examples/exo-ai-2025  (21 crates)  [  cluster-level]
- [x] `(workspace)` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/exo-ai-2025`  ✅B17j
- [x] `exo-backend-classical` — Classical compute backend for EXO-AI cognitive substrate with SIMD acceleration  ·  `examples/exo-ai-2025/crates/exo-backend-classical`  ✅B17e
- [x] `exo-core` — Core traits and types for EXO-AI cognitive substrate - IIT consciousness measurement and Landauer thermodynamics  ·  `examples/exo-ai-2025/crates/exo-core`  ✅B17e
- [x] `exo-exotic` — Exotic cognitive experiments: Strange Loops, Dreams, Free Energy, Morphogenesis, Collective Consciousness, Temporal Qualia, Multiple Selves, Cognitive Thermodynamics, Emergence Detection, Cognitive Black Holes  ·  `examples/exo-ai-2025/crates/exo-exotic`  ✅B17e
- [x] `exo-federation` — Federated cognitive mesh with post-quantum cryptographic sovereignty for distributed AI consciousness  ·  `examples/exo-ai-2025/crates/exo-federation`  ✅B17e
- [x] `exo-hypergraph` — Hypergraph substrate for higher-order relational reasoning with persistent homology and sheaf theory  ·  `examples/exo-ai-2025/crates/exo-hypergraph`  ✅B17e
- [x] `exo-manifold` — Continuous embedding space with SIREN networks for smooth manifold deformation in cognitive AI  ·  `examples/exo-ai-2025/crates/exo-manifold`  ✅B17e
- [x] `exo-node` — Node.js bindings for EXO-AI cognitive substrate via NAPI-RS  ·  `examples/exo-ai-2025/crates/exo-node`  ✅B17e
- [x] `exo-temporal` — Temporal memory coordinator with causal structure for EXO-AI cognitive substrate  ·  `examples/exo-ai-2025/crates/exo-temporal`  ✅B17e
- [x] `exo-wasm` — WASM bindings for EXO-AI 2025 cognitive substrate - browser and edge deployment  ·  `examples/exo-ai-2025/crates/exo-wasm`  ✅B17e
- [x] `neuromorphic-spiking` — Nobel-level neuromorphic spiking neural networks with consciousness computation  ·  `examples/exo-ai-2025/research/01-neuromorphic-spiking`  ✅B17f
- [x] `quantum-cognitive-superposition` — Cognitive Amplitude Field Theory (CAFT) - Classical simulation of quantum cognition  ·  `examples/exo-ai-2025/research/02-quantum-superposition`  ✅B17f
- [x] `time-crystal-cognition` — Cognitive Time Crystals - Discrete Time Translation Symmetry Breaking in Working Memory  ·  `examples/exo-ai-2025/research/03-time-crystal-cognition`  ✅B17f
- [x] `sparse-persistent-homology` — Sub-cubic persistent homology with SIMD acceleration for real-time consciousness measurement  ·  `examples/exo-ai-2025/research/04-sparse-persistent-homology`  ✅B17f
- [x] `demand-paged-cognition` — Memory-mapped neural fields for petabyte-scale cognition  ·  `examples/exo-ai-2025/research/05-memory-mapped-neural-fields`  ✅B17f
- [x] `federated-collective-phi` — Distributed consciousness framework based on IIT 4.0, CRDTs, Byzantine consensus, and federated learning  ·  `examples/exo-ai-2025/research/06-federated-collective-phi`  ✅B17f
- [x] `causal-emergence` — Hierarchical Causal Consciousness (HCC) framework with O(log n) emergence detection  ·  `examples/exo-ai-2025/research/07-causal-emergence`  ✅B17f
- [x] `meta-sim-consciousness` — Nobel-level breakthrough: O(N³) integrated information for ergodic systems  ·  `examples/exo-ai-2025/research/08-meta-simulation-consciousness`  ✅B17f
- [x] `hyperbolic-attention` — Hyperbolic attention networks with O(log n) hierarchical reasoning capacity  ·  `examples/exo-ai-2025/research/09-hyperbolic-attention`  ✅B17f
- [x] `thermodynamic-learning` — Nobel-level thermodynamic learning research: Physics-based intelligence approaching Landauer limits  ·  `examples/exo-ai-2025/research/10-thermodynamic-learning`  ✅B17f
- [x] `conscious-language-interface` — Integration of ruvLLM + Neuromorphic Spiking + ruvector for conscious AI with natural language  ·  `examples/exo-ai-2025/research/11-conscious-language-interface`  ✅B17f

## crates/rvm  (16 crates)  [x cluster-level]  ✅ WALKED → memoir rvm-microhypervisor-subsystem
- [x] `(workspace)` — RVM: Coherence-native microhypervisor for edge computing and multi-agent systems  ·  `crates/rvm`
- [x] `rvm-benches` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/rvm/benches`
- [x] `rvm-boot` — Boot sequence and initialization for the RVM microhypervisor (ADR-140)  ·  `crates/rvm/crates/rvm-boot`
- [x] `rvm-cap` — Capability system for RVM with P1/P2 proof verification (ADR-135)  ·  `crates/rvm/crates/rvm-cap`
- [x] `rvm-coherence` — Coherence monitoring and Phi computation for the RVM microhypervisor (ADR-139)  ·  `crates/rvm/crates/rvm-coherence`
- [x] `rvm-hal` — Hardware abstraction layer for the RVM microhypervisor (ADR-133)  ·  `crates/rvm/crates/rvm-hal`
- [x] `rvm-kernel` — Top-level integration kernel for the RVM microhypervisor  ·  `crates/rvm/crates/rvm-kernel`
- [x] `rvm-memory` — Memory management and guest physical address space for the RVM microhypervisor (ADR-136, ADR-138)  ·  `crates/rvm/crates/rvm-memory`
- [x] `rvm-partition` — Partition object model for RVM coherence domains (ADR-133)  ·  `crates/rvm/crates/rvm-partition`
- [x] `rvm-proof` — Proof-gated state transitions for the RVM microhypervisor (ADR-135)  ·  `crates/rvm/crates/rvm-proof`
- [x] `rvm-sched` — Coherence-aware scheduler for the RVM microhypervisor (ADR-132 DC-4)  ·  `crates/rvm/crates/rvm-sched`
- [x] `rvm-security` — Security policy enforcement for the RVM microhypervisor  ·  `crates/rvm/crates/rvm-security`
- [x] `rvm-types` — Core types for the RVM coherence-native microhypervisor (ADR-132)  ·  `crates/rvm/crates/rvm-types`
- [x] `rvm-wasm` — Optional WebAssembly guest runtime for the RVM microhypervisor  ·  `crates/rvm/crates/rvm-wasm`
- [x] `rvm-witness` — Witness logging subsystem for RVM audit trail (ADR-134)  ·  `crates/rvm/crates/rvm-witness`
- [x] `rvm-tests` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/rvm/tests`

## examples/vibecast-7sense  (12 crates)  [  cluster-level]
- [x] `(workspace)` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/vibecast-7sense`  ✅B17j
- [x] `sevensense-analysis` — Analysis bounded context for 7sense bioacoustics platform - clustering, motif detection, sequence analysis  ·  `examples/vibecast-7sense/crates/sevensense-analysis`  ✅B17g
- [x] `sevensense-api` — REST, GraphQL, and WebSocket API server for 7sense bioacoustics platform  ·  `examples/vibecast-7sense/crates/sevensense-api`  ✅B17g
- [x] `sevensense-audio` — Audio processing and segmentation for 7sense bioacoustics platform  ·  `examples/vibecast-7sense/crates/sevensense-audio`  ✅B17g
- [x] `sevensense-benches` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/vibecast-7sense/crates/sevensense-benches`  ✅B17g
- [x] `sevensense-core` — Core types and traits for 7sense bioacoustic analysis  ·  `examples/vibecast-7sense/crates/sevensense-core`  ✅B17g
- [x] `sevensense-embedding` — Embedding bounded context for 7sense bioacoustics - Perch 2.0 ONNX integration  ·  `examples/vibecast-7sense/crates/sevensense-embedding`  ✅B17g
- [x] `sevensense-interpretation` — LLM-powered interpretation for 7sense bioacoustics platform  ·  `examples/vibecast-7sense/crates/sevensense-interpretation`  ✅B17g
- [x] `sevensense-learning` — GNN-based learning and embedding refinement for 7sense bioacoustics platform  ·  `examples/vibecast-7sense/crates/sevensense-learning`  ✅B17g
- [x] `sevensense-vector` — Vector database operations and HNSW indexing for 7sense bioacoustics platform  ·  `examples/vibecast-7sense/crates/sevensense-vector`  ✅B17g
- [x] `performance-report` — Performance report generator for 7sense benchmarks  ·  `examples/vibecast-7sense/scripts`  ✅B17g
- [x] `vibecast-tests` — Integration tests for 7sense bioacoustics platform  ·  `examples/vibecast-7sense/tests`  ✅B17g

## crates/rvAgent  (10 crates)  [x cluster-level]  ✅ WALKED → memoir rvagent-rust-agent-framework
- [x] `rvagent-a2a` — rvAgent A2A — Agent2Agent peer-to-peer protocol (ADR-159)  ·  `crates/rvAgent/rvagent-a2a`
- [x] `rvagent-acp` — rvAgent ACP server — Agent Communication Protocol with auth, rate limiting, TLS  ·  `crates/rvAgent/rvagent-acp`
- [x] `rvagent-backends` — rvAgent backends — filesystem, shell, composite, state, store, sandbox protocols  ·  `crates/rvAgent/rvagent-backends`
- [x] `rvagent-cli` — rvAgent CLI — terminal coding agent with TUI, session management, MCP tools  ·  `crates/rvAgent/rvagent-cli`
- [x] `rvagent-core` — rvAgent core — typed agent state, config, model resolution, agent graph  ·  `crates/rvAgent/rvagent-core`
- [x] `rvagent-mcp` — rvAgent MCP — Model Context Protocol tools, resources, and transport layer  ·  `crates/rvAgent/rvagent-mcp`
- [x] `rvagent-middleware` — rvAgent middleware — pipeline, todolist, filesystem, subagents, summarization, memory, skills, prompt caching, HITL, witness, tool sanitizer  ·  `crates/rvAgent/rvagent-middleware`
- [x] `rvagent-subagents` — rvAgent subagents — spec compilation, builder, orchestration, result validation  ·  `crates/rvAgent/rvagent-subagents`
- [x] `rvagent-tools` — rvAgent tools — ls, read, write, edit, glob, grep, execute, todos, task (enum dispatch)  ·  `crates/rvAgent/rvagent-tools`
- [x] `rvagent-wasm` — rvAgent WASM bindings — browser and Node.js agent execution  ·  `crates/rvAgent/rvagent-wasm`

## examples/data  (5 crates)  [  cluster-level]
- [x] `(workspace)` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/data`  ✅B17j
- [x] `ruvector-data-climate` — NOAA/NASA climate data integration with regime shift detection for RuVector  ·  `examples/data/climate`  ✅B17j
- [x] `ruvector-data-edgar` — SEC EDGAR financial data integration with coherence analysis for RuVector  ·  `examples/data/edgar`  ✅B17j
- [x] `ruvector-data-framework` — Core discovery framework for RuVector dataset integrations - find hidden patterns in massive datasets using vector memory, graph structures, and dynamic min-cut algorithms  ·  `examples/data/framework`  ✅B17j
- [x] `ruvector-data-openalex` — OpenAlex research intelligence integration for RuVector  ·  `examples/data/openalex`  ✅B17j

## examples/ruvLLM  (3 crates)  [  cluster-level]
- [x] `ruvllm` — Self-learning LLM with LFM2, Ruvector integration, and optimized NEON/Metal kernels  ·  `examples/ruvLLM`  ✅B17j
- [x] `ruvllm-esp32` — Tiny LLM inference for ESP32 microcontrollers with INT8/INT4 quantization, multi-chip federation, RuVector semantic memory, and SNN-gated energy optimization  ·  `examples/ruvLLM/esp32`  ✅B17i
- [x] `ruvllm-esp32-flash` — Complete RuvLLM for ESP32 - Full-featured LLM inference with RAG, federation, and WASM support  ·  `examples/ruvLLM/esp32-flash`  ✅B17j

## crates/ruvector-core  (2 crates)  [x cluster-level]
- [x] `ruvector-core` — High-performance Rust vector database core with HNSW indexing  ·  `crates/ruvector-core`  ✅B15
- [x] `ruvector-core-fuzz` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/ruvector-core/fuzz`  ✅B15

## crates/ruvector-graph  (2 crates)  [  cluster-level]
- [x] `ruvector-graph` — Distributed Neo4j-compatible hypergraph database with SIMD optimization  ·  `crates/ruvector-graph`  ✅code-walked
- [x] `ruvector-graph-fuzz` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/ruvector-graph/fuzz`  ✅B15

## crates/ruvector-raft  (2 crates)  [  cluster-level]
- [x] `ruvector-raft` — Raft consensus implementation for ruvector distributed metadata  ·  `crates/ruvector-raft`  ✅B10
- [x] `ruvector-raft-fuzz` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/ruvector-raft/fuzz`  ✅B10

## examples/mincut  (2 crates)  [  cluster-level]
- [x] `mincut-examples` — Exotic MinCut examples: temporal attractors, strange loops, causal discovery, and more  ·  `examples/mincut`  ✅B17j
- [x] `temporal-attractors-mincut-demo` — Demo of temporal attractor networks with MinCut convergence analysis  ·  `examples/mincut/temporal_attractors`  ✅B17j

## examples/prime-radiant  (2 crates)  [  cluster-level]
- [x] `prime-radiant-category` — Advanced mathematical structures for AI interpretability: sheaf cohomology, category theory, HoTT, and quantum topology  ·  `examples/prime-radiant`  ✅B17j
- [x] `prime-radiant-advanced-wasm` — WASM bindings for Prime-Radiant Advanced Math modules  ·  `examples/prime-radiant/wasm`  ✅B17j

## Cargo.toml  (1 crates)  [  cluster-level]
- [x] `(workspace)` — _(no Cargo desc; needs lib.rs walk)_  ·  `Cargo.toml`  ✅workspace root manifest (not a crate)

## crates/agentic-robotics-benchmarks  (1 crates)  [  cluster-level]
- [x] `agentic-robotics-benchmarks` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/agentic-robotics-benchmarks`  ✅B13

## crates/agentic-robotics-core  (1 crates)  [  cluster-level]
- [x] `agentic-robotics-core` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/agentic-robotics-core`  ✅B13

## crates/agentic-robotics-embedded  (1 crates)  [  cluster-level]
- [x] `agentic-robotics-embedded` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/agentic-robotics-embedded`  ✅B13

## crates/agentic-robotics-mcp  (1 crates)  [  cluster-level]
- [x] `agentic-robotics-mcp` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/agentic-robotics-mcp`  ✅B13

## crates/agentic-robotics-node  (1 crates)  [  cluster-level]
- [x] `agentic-robotics-node` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/agentic-robotics-node`  ✅B13

## crates/agentic-robotics-rt  (1 crates)  [  cluster-level]
- [x] `agentic-robotics-rt` — _(no Cargo desc; needs lib.rs walk)_  ·  `crates/agentic-robotics-rt`  ✅B13

## crates/cognitum-gate-kernel  (1 crates)  [  cluster-level]
- [x] `cognitum-gate-kernel` — No-std WASM kernel for 256-tile coherence gate fabric  ·  `crates/cognitum-gate-kernel`  ✅B8

## crates/cognitum-gate-tilezero  (1 crates)  [  cluster-level]
- [x] `cognitum-gate-tilezero` — Native arbiter for TileZero in the Anytime-Valid Coherence Gate  ·  `crates/cognitum-gate-tilezero`  ✅B8

## crates/hailort-sys  (1 crates)  [  cluster-level]
- [x] `hailort-sys` — Raw FFI bindings for Hailo's HailoRT C library (ADR-167)  ·  `crates/hailort-sys`  ✅B8

## crates/mcp-brain  (1 crates)  [  cluster-level]
- [x] `mcp-brain` — MCP server for RuVector Shared Brain — share, search, and transfer learning across Claude Code sessions  ·  `crates/mcp-brain`  ✅B8

## crates/mcp-brain-server  (1 crates)  [x cluster-level]
- [x] `mcp-brain-server` — Cloud Run backend for RuVector Shared Brain — axum REST API with Firestore + GCS  ·  `crates/mcp-brain-server`  ✅B15

## crates/mcp-gate  (1 crates)  [  cluster-level]
- [x] `mcp-gate` — MCP (Model Context Protocol) server for the Anytime-Valid Coherence Gate  ·  `crates/mcp-gate`  ✅B8

## crates/micro-hnsw-wasm  (1 crates)  [  cluster-level]
- [x] `micro-hnsw-wasm` — Neuromorphic HNSW vector search with spiking neural networks - 11.8KB WASM for edge AI, ASIC, and embedded systems. Features LIF neurons, STDP learning, winner-take-all, dendritic computation.  ·  `crates/micro-hnsw-wasm`  ✅B11

## crates/neural-trader-coherence  (1 crates)  [  cluster-level]
- [x] `neural-trader-coherence` — MinCut coherence gate, CUSUM drift detection, and proof-gated mutation for Neural Trader  ·  `crates/neural-trader-coherence`  ✅B12

## crates/neural-trader-core  (1 crates)  [  cluster-level]
- [x] `neural-trader-core` — Canonical market event types, ingest pipeline, and graph schema for RuVector Neural Trader  ·  `crates/neural-trader-core`  ✅B12

## crates/neural-trader-replay  (1 crates)  [  cluster-level]
- [x] `neural-trader-replay` — Witnessable replay segments, RVF serialization, and audit receipt logging for Neural Trader  ·  `crates/neural-trader-replay`  ✅B12

## crates/neural-trader-strategies  (1 crates)  [  cluster-level]
- [x] `neural-trader-strategies` — Venue-agnostic strategy + risk-gate runtime for the RuVector Neural Trader (ADR-153)  ·  `crates/neural-trader-strategies`  ✅B12

## crates/neural-trader-wasm  (1 crates)  [  cluster-level]
- [x] `neural-trader-wasm` — WASM bindings for Neural Trader — market events, coherence gates, replay memory  ·  `crates/neural-trader-wasm`  ✅B16-bridge

## crates/prime-radiant  (1 crates)  [  cluster-level]
- [x] `prime-radiant` — Universal coherence engine using sheaf Laplacian mathematics for AI safety, hallucination detection, and structural consistency verification in LLMs and distributed systems  ·  `crates/prime-radiant`  ✅B15

## crates/ruQu  (1 crates)  [  cluster-level]
- [x] `ruqu` — Classical nervous system for quantum machines - real-time coherence assessment via dynamic min-cut  ·  `crates/ruQu`  ✅B12

## crates/ruos-thermal  (1 crates)  [  cluster-level]
- [x] `ruos-thermal` — Pi 5 thermal supervisor + over/underclock control (ADR-174)  ·  `crates/ruos-thermal`  ✅B8

## crates/ruqu-algorithms  (1 crates)  [  cluster-level]
- [x] `ruqu-algorithms` — Production-ready quantum algorithms in Rust - VQE for chemistry, Grover's search, QAOA optimization, Surface Code error correction  ·  `crates/ruqu-algorithms`  ✅B12

## crates/ruqu-core  (1 crates)  [  cluster-level]
- [x] `ruqu-core` — High-performance quantum circuit simulator in pure Rust - state-vector simulation with SIMD acceleration, noise models, and multi-threading  ·  `crates/ruqu-core`  ✅B12

## crates/ruqu-exotic  (1 crates)  [  cluster-level]
- [x] `ruqu-exotic` — Experimental quantum-classical hybrid algorithms - quantum memory decay, interference search, reasoning error correction, swarm interference for AI systems  ·  `crates/ruqu-exotic`  ✅B12

## crates/ruqu-wasm  (1 crates)  [  cluster-level]
- [x] `ruqu-wasm` — Run quantum simulations in the browser - WebAssembly bindings for quantum circuits with 25-qubit support, VQE, Grover, QAOA  ·  `crates/ruqu-wasm`  ✅B16-bridge

## crates/ruvector-acorn  (1 crates)  [  cluster-level]
- [x] `ruvector-acorn` — ACORN: Predicate-Agnostic Filtered HNSW — interleaved predicate evaluation inside the graph walk for 2-1000x QPS improvement over post-filter patterns at low selectivity  ·  `crates/ruvector-acorn`  ✅B14

## crates/ruvector-acorn-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-acorn-wasm` — WASM bindings for ruvector-acorn — predicate-agnostic filtered HNSW for browsers and edge runtimes  ·  `crates/ruvector-acorn-wasm`  ✅B16-bridge

## crates/ruvector-attention  (1 crates)  [x cluster-level]
- [x] `ruvector-attention` — Attention mechanisms for ruvector - geometric, graph, and sparse attention  ·  `crates/ruvector-attention`  ✅B15

## crates/ruvector-attention-cli  (1 crates)  [  cluster-level]
- [x] `ruvector-attention-cli` — CLI for ruvector-attention - High-performance attention mechanisms  ·  `crates/ruvector-attention-cli`  ✅B15

## crates/ruvector-attention-node  (1 crates)  [  cluster-level]
- [x] `ruvector-attention-node` — Node.js bindings for ruvector-attention  ·  `crates/ruvector-attention-node`  ✅B16-bridge

## crates/ruvector-attention-unified-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-attention-unified-wasm` — Unified WebAssembly bindings for 18+ attention mechanisms: Neural, DAG, Graph, and Mamba SSM  ·  `crates/ruvector-attention-unified-wasm`  ✅B16-bridge

## crates/ruvector-attention-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-attention-wasm` — High-performance WebAssembly attention mechanisms: Multi-Head, Flash, Hyperbolic, MoE, CGT Sheaf Attention with GPU acceleration for transformers and LLMs  ·  `crates/ruvector-attention-wasm`  ✅B16-bridge

## crates/ruvector-attn-mincut  (1 crates)  [  cluster-level]
- [x] `ruvector-attn-mincut` — Min-cut gating attention operator: dynamic graph-based alternative to softmax attention  ·  `crates/ruvector-attn-mincut`  ✅B14

## crates/ruvector-bench  (1 crates)  [  cluster-level]
- [x] `ruvector-bench` — Comprehensive benchmarking suite for Ruvector  ·  `crates/ruvector-bench`  ✅B15

## crates/ruvector-cli  (1 crates)  [  cluster-level]
- [x] `ruvector-cli` — CLI and MCP server for Ruvector  ·  `crates/ruvector-cli`  ✅B15

## crates/ruvector-cluster  (1 crates)  [  cluster-level]
- [x] `ruvector-cluster` — Distributed clustering and sharding for ruvector  ·  `crates/ruvector-cluster`  ✅B10

## crates/ruvector-cnn  (1 crates)  [  cluster-level]
- [x] `ruvector-cnn` — CNN feature extraction for image embeddings with SIMD acceleration  ·  `crates/ruvector-cnn`  ✅B11

## crates/ruvector-cnn-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-cnn-wasm` — WASM bindings for ruvector-cnn - CNN feature extraction for image embeddings  ·  `crates/ruvector-cnn-wasm`  ✅B16-bridge

## crates/ruvector-cognitive-container  (1 crates)  [  cluster-level]
- [x] `ruvector-cognitive-container` — Verifiable WASM cognitive container with canonical witness chains  ·  `crates/ruvector-cognitive-container`  ✅B9

## crates/ruvector-coherence  (1 crates)  [  cluster-level]
- [x] `ruvector-coherence` — Coherence measurement proxies for comparing attention mechanisms  ·  `crates/ruvector-coherence`  ✅code-walked

## crates/ruvector-collections  (1 crates)  [  cluster-level]
- [x] `ruvector-collections` — High-performance collection management for Ruvector vector databases  ·  `crates/ruvector-collections`  ✅code-walked

## crates/ruvector-consciousness  (1 crates)  [  cluster-level]
- [x] `ruvector-consciousness` — SOTA consciousness metrics: IIT Φ computation, causal emergence, effective information with SIMD acceleration and sublinear approximations  ·  `crates/ruvector-consciousness`  ✅B9

## crates/ruvector-consciousness-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-consciousness-wasm` — WASM bindings for ruvector-consciousness: IIT Φ, causal emergence, quantum collapse  ·  `crates/ruvector-consciousness-wasm`  ✅B16-bridge

## crates/ruvector-crv  (1 crates)  [  cluster-level]
- [x] `ruvector-crv` — CRV (Coordinate Remote Viewing) protocol integration for ruvector - maps 6-stage signal line methodology to vector database subsystems  ·  `crates/ruvector-crv`  ✅B9

## crates/ruvector-dag  (1 crates)  [  cluster-level]
- [x] `ruvector-dag` — Directed Acyclic Graph (DAG) structures for query plan optimization with neural learning  ·  `crates/ruvector-dag`  ✅code-walked

## crates/ruvector-dag-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-dag-wasm` — Minimal WASM DAG library for browser and embedded systems  ·  `crates/ruvector-dag-wasm`  ✅B16-bridge

## crates/ruvector-decompiler  (1 crates)  [  cluster-level]
- [x] `ruvector-decompiler` — SOTA JavaScript bundle decompiler using MinCut graph partitioning, self-learning name inference, and RVF witness chains  ·  `crates/ruvector-decompiler`  ✅B14

## crates/ruvector-decompiler-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-decompiler-wasm` — WASM bindings for the RuVector JavaScript bundle decompiler (Louvain pipeline)  ·  `crates/ruvector-decompiler-wasm`  ✅B16-bridge

## crates/ruvector-delta-consensus  (1 crates)  [  cluster-level]
- [x] `ruvector-delta-consensus` — Distributed delta consensus using CRDTs and causal ordering  ·  `crates/ruvector-delta-consensus`  ✅B10

## crates/ruvector-delta-core  (1 crates)  [  cluster-level]
- [x] `ruvector-delta-core` — Core delta types and traits for behavioral vector change tracking  ·  `crates/ruvector-delta-core`  ✅B10

## crates/ruvector-delta-graph  (1 crates)  [  cluster-level]
- [x] `ruvector-delta-graph` — Delta operations for graph structures - edge and node changes  ·  `crates/ruvector-delta-graph`  ✅B10

## crates/ruvector-delta-index  (1 crates)  [  cluster-level]
- [x] `ruvector-delta-index` — Delta-aware HNSW index with incremental updates and repair strategies  ·  `crates/ruvector-delta-index`  ✅B10

## crates/ruvector-delta-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-delta-wasm` — WASM bindings for delta operations on vectors  ·  `crates/ruvector-delta-wasm`  ✅B16-bridge

## crates/ruvector-diskann  (1 crates)  [  cluster-level]
- [x] `ruvector-diskann` — DiskANN/Vamana — SSD-friendly approximate nearest neighbor search with product quantization  ·  `crates/ruvector-diskann`  ✅B11

## crates/ruvector-diskann-node  (1 crates)  [  cluster-level]
- [x] `ruvector-diskann-node` — NAPI-RS bindings for ruvector-diskann  ·  `crates/ruvector-diskann-node`  ✅B16-bridge

## crates/ruvector-dither  (1 crates)  [  cluster-level]
- [x] `ruvector-dither` — Deterministic low-discrepancy dithering for low-bit quantization: golden-ratio and π-digit sequences for blue-noise error shaping  ·  `crates/ruvector-dither`  ✅B11

## crates/ruvector-domain-expansion  (1 crates)  [  cluster-level]
- [x] `ruvector-domain-expansion` — Cross-domain transfer learning engine: Rust synthesis, structured planning, tool orchestration  ·  `crates/ruvector-domain-expansion`  ✅B9

## crates/ruvector-domain-expansion-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-domain-expansion-wasm` — WASM bindings for the domain expansion cross-domain transfer learning engine  ·  `crates/ruvector-domain-expansion-wasm`  ✅B16-bridge

## crates/ruvector-economy-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-economy-wasm` — CRDT-based autonomous credit economy for distributed compute networks - WASM optimized  ·  `crates/ruvector-economy-wasm`  ✅B16-bridge

## crates/ruvector-exotic-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-exotic-wasm` — Exotic AI mechanisms for emergent behavior - Neural Autonomous Orgs, Morphogenetic Networks, Time Crystals  ·  `crates/ruvector-exotic-wasm`  ✅B16-bridge

## crates/ruvector-filter  (1 crates)  [  cluster-level]
- [x] `ruvector-filter` — Advanced metadata filtering for Ruvector vector search  ·  `crates/ruvector-filter`  ✅code-walked

## crates/ruvector-fpga-transformer  (1 crates)  [  cluster-level]
- [x] `ruvector-fpga-transformer` — FPGA Transformer backend with deterministic latency, quantization-first design, and coherence gating  ·  `crates/ruvector-fpga-transformer`  ✅code-walked

## crates/ruvector-fpga-transformer-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-fpga-transformer-wasm` — WASM bindings for FPGA Transformer backend  ·  `crates/ruvector-fpga-transformer-wasm`  ✅B16-bridge

## crates/ruvector-gnn  (1 crates)  [  cluster-level]
- [x] `ruvector-gnn` — Graph Neural Network layer for Ruvector on HNSW topology  ·  `crates/ruvector-gnn`  ✅code-walked

## crates/ruvector-gnn-node  (1 crates)  [  cluster-level]
- [x] `ruvector-gnn-node` — Node.js bindings for Ruvector GNN via NAPI-RS  ·  `crates/ruvector-gnn-node`  ✅B16-bridge

## crates/ruvector-gnn-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-gnn-wasm` — WebAssembly bindings for RuVector GNN with tensor compression and differentiable search  ·  `crates/ruvector-gnn-wasm`  ✅B16-bridge

## crates/ruvector-graph-condense  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-condense` — Structure-preserving graph condensation: collapse large feature graphs into small synthetic graphs using dynamic min-cut community boundaries  ·  `crates/ruvector-graph-condense`  ✅B14

## crates/ruvector-graph-condense-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-condense-wasm` — WASM bindings for ruvector-graph-condense: structure-preserving + differentiable-min-cut graph condensation in the browser / on the edge  ·  `crates/ruvector-graph-condense-wasm`  ✅B16-bridge

## crates/ruvector-graph-node  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-node` — Node.js bindings for RuVector Graph Database via NAPI-RS  ·  `crates/ruvector-graph-node`  ✅B16-bridge

## crates/ruvector-graph-transformer  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-transformer` — Unified graph transformer with proof-gated mutation substrate — 8 verified modules for physics, biological, manifold, temporal, and economic graph intelligence  ·  `crates/ruvector-graph-transformer`  ✅code-walked

## crates/ruvector-graph-transformer-node  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-transformer-node` — Node.js bindings for RuVector Graph Transformer via NAPI-RS  ·  `crates/ruvector-graph-transformer-node`  ✅B16-bridge

## crates/ruvector-graph-transformer-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-transformer-wasm` — WASM bindings for ruvector-graph-transformer: proof-gated graph attention in the browser  ·  `crates/ruvector-graph-transformer-wasm`  ✅B16-bridge

## crates/ruvector-graph-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-graph-wasm` — WebAssembly bindings for RuVector graph database with Neo4j-inspired API and Cypher support  ·  `crates/ruvector-graph-wasm`  ✅B16-bridge

## crates/ruvector-hailo  (1 crates)  [  cluster-level]
- [x] `ruvector-hailo` — ruvector embedding backend for the Hailo-8 NPU (ADR-167)  ·  `crates/ruvector-hailo`  ✅B8

## crates/ruvector-hailo-cluster  (1 crates)  [  cluster-level]
- [x] `ruvector-hailo-cluster` — Multi-Pi cluster coordinator for ruvector Hailo embedding workers (ADR-167 §8)  ·  `crates/ruvector-hailo-cluster`  ✅B8

## crates/ruvector-hyperbolic-hnsw  (1 crates)  [  cluster-level]
- [x] `ruvector-hyperbolic-hnsw` — Hyperbolic (Poincare ball) embeddings with HNSW integration for hierarchy-aware vector search, enabling efficient similarity search in non-Euclidean spaces for taxonomies, ontologies, and hierarchical data  ·  `crates/ruvector-hyperbolic-hnsw`  ✅B11

## crates/ruvector-hyperbolic-hnsw-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-hyperbolic-hnsw-wasm` — WebAssembly bindings for hyperbolic HNSW embeddings - hierarchy-aware vector search in the browser  ·  `crates/ruvector-hyperbolic-hnsw-wasm`  ✅B16-bridge

## crates/ruvector-kalshi  (1 crates)  [  cluster-level]
- [x] `ruvector-kalshi` — Kalshi exchange integration for the RuVector Neural Trader (ADR-153)  ·  `crates/ruvector-kalshi`  ✅B12

## crates/ruvector-learning-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-learning-wasm` — Ultra-fast MicroLoRA adaptation for WASM - rank-2 LoRA with <100us latency for per-operator learning  ·  `crates/ruvector-learning-wasm`  ✅B16-bridge

## crates/ruvector-math  (1 crates)  [  cluster-level]
- [x] `ruvector-math` — Advanced mathematics for next-gen vector search: Optimal Transport, Information Geometry, Product Manifolds  ·  `crates/ruvector-math`  ✅code-walked

## crates/ruvector-math-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-math-wasm` — WebAssembly bindings for ruvector-math: Optimal Transport, Information Geometry, Product Manifolds  ·  `crates/ruvector-math-wasm`  ✅B16-bridge

## crates/ruvector-metrics  (1 crates)  [  cluster-level]
- [x] `ruvector-metrics` — Prometheus-compatible metrics collection for Ruvector vector databases  ·  `crates/ruvector-metrics`  ✅B15

## crates/ruvector-mincut  (1 crates)  [x cluster-level]
- [x] `ruvector-mincut` — World's first subpolynomial dynamic min-cut: self-healing networks, AI optimization, real-time graph analysis  ·  `crates/ruvector-mincut`  ✅B15

## crates/ruvector-mincut-brain-node  (1 crates)  [  cluster-level]
- [x] `ruvector-mincut-brain-node` — Minimal WASM binary for pi.ruv.io brain node: canonical min-cut with V1 ABI stubs  ·  `crates/ruvector-mincut-brain-node`  ✅B14

## crates/ruvector-mincut-gated-transformer  (1 crates)  [  cluster-level]
- [x] `ruvector-mincut-gated-transformer` — Ultra low latency transformer inference with mincut-gated coherence control  ·  `crates/ruvector-mincut-gated-transformer`  ✅B14

## crates/ruvector-mincut-gated-transformer-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-mincut-gated-transformer-wasm` — WASM bindings for mincut-gated transformer inference  ·  `crates/ruvector-mincut-gated-transformer-wasm`  ✅B16-bridge

## crates/ruvector-mincut-node  (1 crates)  [  cluster-level]
- [x] `ruvector-mincut-node` — Node.js bindings for subpolynomial-time dynamic minimum cut  ·  `crates/ruvector-mincut-node`  ✅B16-bridge

## crates/ruvector-mincut-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-mincut-wasm` — WASM bindings for subpolynomial-time dynamic minimum cut  ·  `crates/ruvector-mincut-wasm`  ✅B16-bridge

## crates/ruvector-mmwave  (1 crates)  [  cluster-level]
- [x] `ruvector-mmwave` — Shared parser for Seeed MR60BHA2 + HLK-LD2410 60/24 GHz mmWave radar UART streams (ADR-063)  ·  `crates/ruvector-mmwave`  ✅B13

## crates/ruvector-nervous-system  (1 crates)  [  cluster-level]
- [x] `ruvector-nervous-system` — Bio-inspired neural system with spiking networks, BTSP learning, and EWC plasticity  ·  `crates/ruvector-nervous-system`  ✅B9

## crates/ruvector-nervous-system-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-nervous-system-wasm` — WASM bindings for ruvector-nervous-system bio-inspired AI components  ·  `crates/ruvector-nervous-system-wasm`  ✅B16-bridge

## crates/ruvector-node  (1 crates)  [  cluster-level]
- [x] `ruvector-node` — Node.js bindings for Ruvector via NAPI-RS  ·  `crates/ruvector-node`  ✅B10

## crates/ruvector-perception  (1 crates)  [  cluster-level]
- [x] `ruvector-perception` — The layer under classification: physical delta -> boundary -> coherence -> proof -> action. A trusted-physical-memory engine that emits structured delta witnesses, not class labels.  ·  `crates/ruvector-perception`  ✅B9

## crates/ruvector-postgres  (1 crates)  [  cluster-level]
- [x] `ruvector-postgres` — High-performance PostgreSQL vector database extension v2 - pgvector drop-in replacement with 230+ SQL functions, SIMD acceleration, Flash Attention, GNN layers, hybrid search, multi-tenancy, self-healing, and self-learning capabilities  ·  `crates/ruvector-postgres`  ✅B10

## crates/ruvector-profiler  (1 crates)  [  cluster-level]
- [x] `ruvector-profiler` — Memory, power, and latency profiling hooks with CSV emitters for benchmarking attention mechanisms  ·  `crates/ruvector-profiler`  ✅B15

## crates/ruvector-rabitq  (1 crates)  [  cluster-level]
- [x] `ruvector-rabitq` — RaBitQ: rotation-based 1-bit quantization for ultra-fast approximate nearest-neighbor search with theoretical error bounds  ·  `crates/ruvector-rabitq`  ✅B11

## crates/ruvector-rabitq-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-rabitq-wasm` — WASM bindings for ruvector-rabitq — 1-bit quantized vector index for browsers and edge runtimes  ·  `crates/ruvector-rabitq-wasm`  ✅B16-bridge

## crates/ruvector-rairs  (1 crates)  [  cluster-level]
- [x] `ruvector-rairs` — RAIRS IVF: Redundant Assignment with Amplified Inverse Residual — ruvector's first IVF index family  ·  `crates/ruvector-rairs`  ✅B14

## crates/ruvector-replication  (1 crates)  [  cluster-level]
- [x] `ruvector-replication` — Data replication and synchronization for ruvector  ·  `crates/ruvector-replication`  ✅B10

## crates/ruvector-robotics  (1 crates)  [  cluster-level]
- [x] `ruvector-robotics` — Cognitive robotics platform: bridge types, perception pipeline, cognitive architecture, and MCP tools  ·  `crates/ruvector-robotics`  ✅B13

## crates/ruvector-router-cli  (1 crates)  [  cluster-level]
- [x] `ruvector-router-cli` — CLI for testing and benchmarking ruvector-router-core  ·  `crates/ruvector-router-cli`  ✅B15

## crates/ruvector-router-core  (1 crates)  [  cluster-level]
- [x] `ruvector-router-core` — Core vector database and neural routing inference engine  ·  `crates/ruvector-router-core`  ✅B14

## crates/ruvector-router-ffi  (1 crates)  [  cluster-level]
- [x] `ruvector-router-ffi` — NAPI-RS bindings for ruvector-router-core vector database  ·  `crates/ruvector-router-ffi`  ✅B15

## crates/ruvector-router-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-router-wasm` — WASM bindings for ruvector-router-core  ·  `crates/ruvector-router-wasm`  ✅B16-bridge

## crates/ruvector-rulake  (1 crates)  [  cluster-level]
- [x] `ruvector-rulake` — ruLake — vector-native federation intermediary over heterogeneous backends (ADR-155)  ·  `crates/ruvector-rulake`  ✅B14

## crates/ruvector-server  (1 crates)  [  cluster-level]
- [x] `ruvector-server` — High-performance REST API server for Ruvector vector databases  ·  `crates/ruvector-server`  ✅B10

## crates/ruvector-snapshot  (1 crates)  [  cluster-level]
- [x] `ruvector-snapshot` — Point-in-time snapshots and backup for Ruvector vector databases  ·  `crates/ruvector-snapshot`  ✅B10

## crates/ruvector-solver  (1 crates)  [  cluster-level]
- [x] `ruvector-solver` — Sublinear-time solver for RuVector: O(log n) to O(√n) algorithms for sparse linear systems, PageRank, and spectral methods  ·  `crates/ruvector-solver`  ✅code-walked

## crates/ruvector-solver-node  (1 crates)  [  cluster-level]
- [x] `ruvector-solver-node` — Node.js NAPI bindings for RuVector sublinear-time solver  ·  `crates/ruvector-solver-node`  ✅B16-bridge

## crates/ruvector-solver-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-solver-wasm` — WASM bindings for RuVector sublinear-time solver  ·  `crates/ruvector-solver-wasm`  ✅B16-bridge

## crates/ruvector-sparse-inference  (1 crates)  [  cluster-level]
- [x] `ruvector-sparse-inference` — PowerInfer-style sparse inference engine for efficient neural network inference on edge devices  ·  `crates/ruvector-sparse-inference`  ✅code-walked

## crates/ruvector-sparse-inference-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-sparse-inference-wasm` — WebAssembly bindings for PowerInfer-style sparse inference  ·  `crates/ruvector-sparse-inference-wasm`  ✅B16-bridge

## crates/ruvector-sparsifier  (1 crates)  [  cluster-level]
- [x] `ruvector-sparsifier` — Dynamic spectral graph sparsification: always-on compressed world model for real-time graph analytics  ·  `crates/ruvector-sparsifier`  ✅B11

## crates/ruvector-sparsifier-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-sparsifier-wasm` — WASM bindings for dynamic spectral graph sparsification  ·  `crates/ruvector-sparsifier-wasm`  ✅B16-bridge

## crates/ruvector-temporal-tensor  (1 crates)  [  cluster-level]
- [x] `ruvector-temporal-tensor` — Temporal tensor compression with tiered quantization for RuVector  ·  `crates/ruvector-temporal-tensor`  ✅B9

## crates/ruvector-temporal-tensor-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-temporal-tensor-wasm` — WASM bindings for temporal tensor compression  ·  `crates/ruvector-temporal-tensor-wasm`  ✅B16-bridge

## crates/ruvector-tiny-dancer-core  (1 crates)  [  cluster-level]
- [x] `ruvector-tiny-dancer-core` — Production-grade AI agent routing system with FastGRNN neural inference  ·  `crates/ruvector-tiny-dancer-core`  ✅B13

## crates/ruvector-tiny-dancer-node  (1 crates)  [  cluster-level]
- [x] `ruvector-tiny-dancer-node` — Node.js bindings for Tiny Dancer neural routing via NAPI-RS  ·  `crates/ruvector-tiny-dancer-node`  ✅B16-bridge

## crates/ruvector-tiny-dancer-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-tiny-dancer-wasm` — WASM bindings for Tiny Dancer neural routing  ·  `crates/ruvector-tiny-dancer-wasm`  ✅B16-bridge

## crates/ruvector-verified  (1 crates)  [  cluster-level]
- [x] `ruvector-verified` — Formal verification layer for RuVector: proof-carrying vector operations with sub-microsecond overhead using lean-agentic dependent types  ·  `crates/ruvector-verified`  ✅code-walked

## crates/ruvector-verified-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-verified-wasm` — WASM bindings for ruvector-verified: proof-carrying vector operations in the browser  ·  `crates/ruvector-verified-wasm`  ✅B16-bridge

## crates/ruvector-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-wasm` — WASM bindings for Ruvector including kernel pack system (ADR-005)  ·  `crates/ruvector-wasm`  ✅B16-bridge

## crates/ruvllm  (1 crates)  [  cluster-level]
- [x] `ruvllm` — LLM serving runtime with Ruvector integration - Paged attention, KV cache, and SONA learning  ·  `crates/ruvllm`  ✅code-walked

## crates/ruvllm-cli  (1 crates)  [  cluster-level]
- [x] `ruvllm-cli` — CLI for RuvLLM model management and inference on Apple Silicon  ·  `crates/ruvllm-cli`  ✅B15

## crates/ruvllm-wasm  (1 crates)  [  cluster-level]
- [x] `ruvllm-wasm` — WASM bindings for RuvLLM - browser-compatible LLM inference runtime with WebGPU acceleration  ·  `crates/ruvllm-wasm`  ✅B16-bridge

## crates/ruvllm_retrieval_diffusion  (1 crates)  [  cluster-level]
- [x] `ruvllm_retrieval_diffusion` — Corpus-agnostic training-free retrieval LM and masked discrete diffusion built on ruvllm_sparse_attention. Works on any small-vocab token domain — game levels, drum patterns, configs, MIDI, visual tokens.  ·  `crates/ruvllm_retrieval_diffusion`  ✅code-walked

## crates/ruvllm_sparse_attention  (1 crates)  [  cluster-level]
- [x] `ruvllm_sparse_attention` — Subquadratic O(N log N) sparse attention kernel for Rust LLM inference on edge devices, with optional FastGRNN salience gating for near-linear O(N) scaling  ·  `crates/ruvllm_sparse_attention`  ✅code-walked

## crates/rvlite  (1 crates)  [  cluster-level]
- [x] `rvlite` — Standalone vector database with SQL, SPARQL, and Cypher - powered by RuVector WASM  ·  `crates/rvlite`  ✅B15

## crates/sona  (1 crates)  [  cluster-level]
- [x] `ruvector-sona` — Self-Optimizing Neural Architecture - Runtime-adaptive learning for LLM routers with two-tier LoRA, EWC++, and ReasoningBank  ·  `crates/sona`  ✅code-walked

## crates/thermorust  (1 crates)  [  cluster-level]
- [x] `thermorust` — Thermodynamic neural motif engine: energy-driven state transitions with Landauer dissipation and Langevin noise  ·  `crates/thermorust`  ✅B8

## docs  (1 crates)  [  cluster-level]
- [x] `musica` — Structure-first audio source separation via dynamic mincut graph partitioning  ·  `docs/examples/musica`  ✅B17 (music domain app on ruvector-mincut)

## examples/OSpipe  (1 crates)  [  cluster-level]
- [x] `ospipe` — OSpipe: RuVector-enhanced personal AI memory system integrating with Screenpipe  ·  `examples/OSpipe`  ✅B17h-agentic

## examples/a2a-swarm  (1 crates)  [  cluster-level]
- [x] `a2a-swarm` — rvAgent A2A swarm demo — three rvagent-cli nodes + a router dispatching tasks end-to-end over HTTP  ·  `examples/a2a-swarm`  ✅B17h-agentic

## examples/benchmarks  (1 crates)  [  cluster-level]
- [x] `ruvector-benchmarks` — Comprehensive benchmarks for temporal reasoning and vector operations  ·  `examples/benchmarks`  ✅B17j

## examples/boundary-discovery  (1 crates)  [  cluster-level]
- [x] `boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/boundary-discovery`  ✅B17a-strict

## examples/brain-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `brain-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/brain-boundary-discovery`  ✅B17b-agentic

## examples/climate-consciousness  (1 crates)  [  cluster-level]
- [x] `climate-consciousness` — Climate teleconnection consciousness analysis using IIT Phi  ·  `examples/climate-consciousness`  ✅B17c-agentic

## examples/cmb-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `cmb-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/cmb-boundary-discovery`  ✅B17a-strict

## examples/cmb-consciousness  (1 crates)  [  cluster-level]
- [x] `cmb-consciousness` — CMB radiation consciousness analysis using IIT Phi, causal emergence, and MinCut  ·  `examples/cmb-consciousness`  ✅B17c-agentic

## examples/delta-behavior  (1 crates)  [  cluster-level]
- [x] `delta-behavior` — Delta-behavior: constrained state transitions that preserve global coherence - systems that refuse to collapse  ·  `examples/delta-behavior`  ✅B17j

## examples/dna  (1 crates)  [  cluster-level]
- [x] `rvdna` — rvDNA — AI-native genomic analysis. 20-SNP biomarker risk scoring, streaming anomaly detection, 64-dim profile vectors, 23andMe genotyping, CYP2D6/CYP2C19 pharmacogenomics, variant calling, protein prediction, and HNSW vector search in pure Rust.  ·  `examples/dna`  ✅B17d-agentic

## examples/earthquake-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `earthquake-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/earthquake-boundary-discovery`  ✅B17a-strict

## examples/ecosystem-consciousness  (1 crates)  [  cluster-level]
- [x] `ecosystem-consciousness` — Ecosystem food web consciousness analysis using IIT Phi  ·  `examples/ecosystem-consciousness`  ✅B17c-agentic

## examples/edge  (1 crates)  [  cluster-level]
- [x] `ruvector-edge` — Edge AI swarm communication with ruv-swarm-transport and RuVector intelligence  ·  `examples/edge`  ✅B17i

## examples/edge-net  (1 crates)  [  cluster-level]
- [x] `ruvector-edge-net` — Distributed compute intelligence network - contribute browser compute, earn credits  ·  `examples/edge-net`  ✅B17i

## examples/esp32-mmwave-sensor  (1 crates)  [  cluster-level]
- [x] `ruvector-mmwave-sensor` — ESP32-S3 firmware reading a Seeed MR60BHA2 60 GHz mmWave radar over UART (ADR-063 + RuView ADR-SYS-0024)  ·  `examples/esp32-mmwave-sensor`  ✅B17i

## examples/frb-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `frb-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/frb-boundary-discovery`  ✅B17a-strict

## examples/gene-consciousness  (1 crates)  [  cluster-level]
- [x] `gene-consciousness` — Gene regulatory network consciousness analysis using IIT Phi  ·  `examples/gene-consciousness`  ✅B17c-agentic

## examples/google-cloud  (1 crates)  [  cluster-level]
- [x] `ruvector-cloudrun-gpu` — RuVector Cloud Run GPU benchmarks with self-learning models  ·  `examples/google-cloud`  ✅B17i

## examples/gw-consciousness  (1 crates)  [  cluster-level]
- [x] `gw-consciousness` — Gravitational wave background consciousness analysis using IIT Phi  ·  `examples/gw-consciousness`  ✅B17c-agentic

## examples/health-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `health-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/health-boundary-discovery`  ✅B17b-agentic

## examples/infrastructure-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `infrastructure-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/infrastructure-boundary-discovery`  ✅B17b-agentic

## examples/market-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `market-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/market-boundary-discovery`  ✅B17b-agentic

## examples/music-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `music-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/music-boundary-discovery`  ✅B17b-agentic

## examples/onnx-embeddings  (1 crates)  [  cluster-level]
- [x] `ruvector-onnx-embeddings` — ONNX-based embedding generation for RuVector - Reimagined embedding pipeline in pure Rust  ·  `examples/onnx-embeddings`  ✅B17i

## examples/onnx-embeddings-wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-onnx-embeddings-wasm` — WASM embedding generation with SIMD - runs in browsers, Cloudflare Workers, Deno, and edge runtimes  ·  `examples/onnx-embeddings-wasm`  ✅B17j

## examples/pandemic-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `pandemic-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/pandemic-boundary-discovery`  ✅B17b-agentic

## examples/quantum-consciousness  (1 crates)  [  cluster-level]
- [x] `quantum-consciousness` — Quantum circuit consciousness analysis using IIT Phi  ·  `examples/quantum-consciousness`  ✅B17c-agentic

## examples/real-eeg-analysis  (1 crates)  [  cluster-level]
- [x] `real-eeg-analysis` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/real-eeg-analysis`  ✅B17d-agentic

## examples/real-eeg-multi-seizure  (1 crates)  [  cluster-level]
- [x] `real-eeg-multi-seizure` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/real-eeg-multi-seizure`  ✅B17d-agentic

## examples/refrag-pipeline  (1 crates)  [  cluster-level]
- [x] `refrag-pipeline-example` — REFRAG Pipeline Example - Compress-Sense-Expand for 30x RAG latency reduction  ·  `examples/refrag-pipeline`  ✅B17h-agentic

## examples/robotics  (1 crates)  [  cluster-level]
- [x] `ruvector-robotics-examples` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/robotics`  ✅B17h-agentic

## examples/rvf  (1 crates)  [  cluster-level]
- [x] `rvf-examples` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/rvf`  ✅B17i

## examples/rvf-desktop  (1 crates)  [  cluster-level]
- [x] `rvf-desktop` — RuVector Causal Atlas — native desktop app with embedded Three.js dashboard  ·  `examples/rvf-desktop`  ✅B17i

## examples/rvf-kernel-optimized  (1 crates)  [  cluster-level]
- [x] `rvf-kernel-optimized` — Hyper-optimized RVF example: Linux kernel embedding with ruvector-verified formal proofs  ·  `examples/rvf-kernel-optimized`  ✅B17i

## examples/scipix  (1 crates)  [  cluster-level]
- [x] `ruvector-scipix` — Rust OCR engine for scientific documents - extract LaTeX, MathML from math equations, research papers, and technical diagrams with ONNX GPU acceleration  ·  `examples/scipix`  ✅B17j

## examples/seizure-clinical-report  (1 crates)  [  cluster-level]
- [x] `seizure-clinical-report` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/seizure-clinical-report`  ✅B17d-agentic

## examples/seizure-therapeutic-sim  (1 crates)  [  cluster-level]
- [x] `seizure-therapeutic-sim` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/seizure-therapeutic-sim`  ✅B17d-agentic

## examples/seti-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `seti-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/seti-boundary-discovery`  ✅B17a-strict

## examples/seti-exotic-signals  (1 crates)  [  cluster-level]
- [x] `seti-exotic-signals` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/seti-exotic-signals`  ✅B17a-strict

## examples/spiking-network  (1 crates)  [  cluster-level]
- [x] `spiking-network` — Event-driven spiking neural network for ASIC-optimized neuromorphic computing  ·  `examples/spiking-network`  ✅B17d-agentic

## examples/subpolynomial-time  (1 crates)  [  cluster-level]
- [x] `subpolynomial-time-mincut-demo` — Demo of subpolynomial-time dynamic minimum cut algorithm  ·  `examples/subpolynomial-time`  ✅B17j

## examples/temporal-attractor-discovery  (1 crates)  [  cluster-level]
- [x] `temporal-attractor-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/temporal-attractor-discovery`  ✅B17d-agentic

## examples/train-discoveries  (1 crates)  [  cluster-level]
- [x] `train-discoveries` — Cross-domain discovery ETL pipeline using RuVector sublinear solver  ·  `examples/train-discoveries`  ✅B17j

## examples/ultra-low-latency-sim  (1 crates)  [  cluster-level]
- [x] `ultra-low-latency-sim` — Meta-simulation achieving quadrillion simulations/second on CPU with SIMD  ·  `examples/ultra-low-latency-sim`  ✅B17j

## examples/verified-applications  (1 crates)  [  cluster-level]
- [x] `verified-applications` — 10 exotic applications of ruvector-verified: from weapons filters to legal forensics  ·  `examples/verified-applications`  ✅B17h-agentic

## examples/void-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `void-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/void-boundary-discovery`  ✅B17b-agentic

## examples/wasm  (1 crates)  [  cluster-level]
- [x] `ruvector-ios-wasm` — iOS & Browser optimized WASM vector database with HNSW, quantization, and ML  ·  `examples/wasm/ios`  ✅B17i

## examples/weather-boundary-discovery  (1 crates)  [  cluster-level]
- [x] `weather-boundary-discovery` — _(no Cargo desc; needs lib.rs walk)_  ·  `examples/weather-boundary-discovery`  ✅B17b-agentic

## patches  (1 crates)  [  cluster-level]
- [x] `hnsw_rs` — Ann based on Hierarchical Navigable Small World Graphs from Yu.A. Malkov and D.A Yashunin  ·  `patches/hnsw_rs`  ✅EXTERNAL (vendored patch of upstream hnsw_rs, not a ruvector crate)

## scripts  (1 crates)  [  cluster-level]
- [x] `hnsw_rs` — Ann based on Hierarchical Navigable Small World Graphs from Yu.A. Malkov and D.A Yashunin  ·  `scripts/patches/hnsw_rs`  ✅EXTERNAL (vendored patch of upstream hnsw_rs, not a ruvector crate)

## tests  (1 crates)  [  cluster-level]
- [x] `ruvector-attention-integration-test` — _(no Cargo desc; needs lib.rs walk)_  ·  `tests/docker-integration`  ✅test harness
