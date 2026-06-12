# MIROFISH-PORT-PLAN — full-feature Rust port: vehicle verdict + straightest line (W4, 2026-06-12)

**Method:** three parallel deep-reads (upstream 666ghj/MiroFish + offline forks + CLI fork via web/GitHub;
teri full source walk with `cargo test` run; shimmy API-surface walk matched against teri/src/llm.rs
request shapes), workflow `wf_5cdc9018`. All file:line evidence retained in the session task output.

## Verdicts (the user's question, answered)

1. **teri SPEEDS UP the timeline decisively — it is the vehicle. Extend it; do not port fresh.**
   teri is an honest ~6.7k-LOC Rust skeleton with **140 passing tests** (133 unit + 7 integration, 0
   failures) whose module map mirrors MiroFish's five-stage pipeline 1:1. Five of seven stages carry
   real, tested logic; what's missing is composition, not capability. A fresh port would discard
   working seed-ingestion, agent, sim, report, and LLM layers. (Adopt-then-extend law.)
2. **shimmy is the inference slot — yes, with four named gaps** (below). Its `/v1/chat/completions`
   request/response/SSE shapes match teri's OpenAiAdapter exactly (verified field-by-field both sides).
3. **Do NOT port Flask/Vue.** meta already owns the front-door plane (prompt_hub + RuVocal-later) and
   the visualization plane (n8n; D3 data shape = a JSON endpoint). MiroFish's web stack is replaced by
   planes we already operate — that's the structural advantage of porting *into the meta estate*.
4. **License note:** upstream MiroFish is AGPL-3.0; teri is MIT (independent rewrite). Parity is
   achieved **by spec, never by code copy** — feature behavior re-implemented from the matrix below.

## Upstream baseline (what "full-feature" means)

MiroFish v0.1.2 (Flask 3 + Vue 3, ~66k stars, Shanda-backed): five stages — (1) Graph Building: pdf/md/txt
→ 500-char chunks → LLM-designed ontology (10 entity + 6-10 edge types, Pydantic) → **Zep Cloud**
GraphRAG; (2) Environment Setup: graph entities → OASIS personas (~2000-char persona text + age/gender/
mbti/country/profession/interests; individual vs group/institutional accounts) + LLM-generated sim
config (time/event/agent phases = opinion bias, reaction speed, influence); (3) Simulation: OASIS
(CAMEL-AI) subprocess, **dual Twitter+Reddit platforms**, action set CREATE_POST/comment/quote/like/
dislike/follow/mute/search/DO_NOTHING, **real-time graph memory write-back** per round; (4) Report:
ReACT ReportAgent — outline then per-section reasoning loops over **four graph tools** (InsightForge
sub-question decomposition, entity/edge search, interview IPC); (5) Deep Interaction: in-character chat
with any agent + report chat. Offline forks: Zep→**Neo4j CE** behind an abstract GraphStorage, LLM→
Ollama (qwen2.5 + nomic-embed-text 768-dim, hybrid 0.7 vector / 0.3 BM25). CLI fork: Python CLI,
verdict.json + SVG artifacts.

## Parity matrix (MiroFish capability → teri reality → action)

| Capability | teri today (evidence) | Action |
|---|---|---|
| Doc ingestion (pdf/md/txt/json/url) | **implemented** — seed/ dispatches by ext, pdfium PDF, reqwest URL+scraper (seed/mod.rs:19–241) | parity already EXCEEDS upstream (URL+JSON); keep |
| Chunking/preprocess | implicit in seed; no 500/50 chunker | small: add chunker w/ config |
| Ontology generation | **missing** (upstream LLM-designs schema) | P2: LLM ontology pass reusing graph prompt builders |
| Entity/relation extraction | **partial** — prompt builders + parsers real; `KnowledgeGraph::build` is an explicit placeholder (graph/mod.rs:223–237, 376–511) | **P1 keystone**: wire extraction orchestration (chunk → LLM → parse → insert) — local, no Zep |
| Graph store | **petgraph + JSON/bincode**, BFS subgraph, indexes (real) | keep embedded (vs Neo4j) — Rust-native; pgvector later via ruvector-postgres if needed |
| Persona generation | **implemented** — minijinja persona templates (agent/mod.rs:674–752) | P2: enrich template to OASIS attribute coverage (mbti/country/profession/interests/influence/reaction-speed; individual vs institutional) |
| Sim config generation (opinion bias/reaction/influence) | partial (config exists; no LLM-phase generator) | P2: config generator from graph+requirement |
| Sim loop | **implemented** — two-phase ticks, futures buffered LLM concurrency, God-events injection (sim/mod.rs:337–405) | P1: wire; P2: platform presets (Twitter/Reddit action sets incl. DO_NOTHING bias) |
| Temporal memory write-back | hook exists (`_graph` TODO at sim/mod.rs:341–343); redb MemoryStore real but **unwired** (memory/mod.rs) | **P1**: wire MemoryStore + graph write-back per tick |
| Agent interview / live IPC | missing (DTOs only) | P3 (server phase): interview endpoints over ApiState |
| Report generation | **implemented** — ReportAgent generate + generate_stream, minijinja template, key-event extraction (report/mod.rs) | P2: add ReACT loop + 4 graph tools (InsightForge analog over petgraph+redb) |
| Deep interaction (chat) | missing | P3: chat endpoints reusing interview + report context |
| HTTP API + SSE | **stub** — DTOs + a real TickStream lag-gap module; NO server (api/) despite axum deps + README claims | P3: axum server on existing DTOs; teri/src/api/streaming.rs is ready |
| Web UI / D3 graph | n/a in teri | NOT ported: prompt_hub front door + `/graph/data` JSON endpoint (D3-shape) + n8n map |
| LLM providers | **implemented** — OpenAI/Ollama/LMStudio/vLLM via base_url + Anthropic + Gemini adapters, retry/backoff (llm.rs) | P1 fixes: provider-selection logic; SEND max_tokens; Anthropic base_url configurable; note Anthropic/Gemini stream parsers assume OpenAI SSE framing (fix or gate) |
| Embeddings/hybrid search | config carries embed_model; memory stores Vec<f32>; similarity stubbed | P4: embeddings (shimmy gap — see below) + hybrid scoring |
| Verdict artifacts (CLI fork) | n/a | P3: `teri run … --out verdict.json` parity |

**teri hygiene (do in P1):** main.rs both subcommands bail ("Pipeline/API not yet implemented" —
main.rs:49–58); TODO.md stale in both directions (241 unchecked vs 224 checked, ~50 unchecked actually
done); README overclaims rayon + SSE server; upstream CLAUDE.md demands interactive review (conflicts
with autonomous ops) — refresh all three via the normal PR loop (defects D10/D12 family).

## shimmy fit (the inference slot) — 1:1 today, four gaps to plan around

**Works now:** teri `complete()`/`stream()` ↔ shimmy `/v1/chat/completions` exactly (SSE `data:` frames,
`choices[0].delta.content`, `[DONE]`), `GET /v1/models` for discovery; point `LLM_BASE_URL` at
`http://host:port/v1` + a registered GGUF. Linux reality: **Airframe/GGUF is the only real engine** —
SafeTensors engine returns a **canned placeholder string** ("Full transformer inference coming soon!")
and HuggingFace engine shells to a hardcoded Windows Python path. → **Guard rule: teri must verify the
model is GGUF-served or the swarm silently simulates on fake text.**

| Gap | Impact | Plan |
|---|---|---|
| Serialized inference (one `Arc<Mutex<GpuRuntime>>`, spawn_blocking + blocking_lock, no batching/queue caps) | hundreds of persona agents throttle to single-stream; SIM_PARALLELISM=8 survivable | P1: cap parallelism; P4: multi-instance shimmy pool or upstream continuous-batching contribution |
| No `/v1/embeddings` | memory similarity stays keyword-based | P4: add embeddings route to shimmy fork OR embed in-process (candle) — decide by bench |
| `response_format: json_object` silently ignored | teri `complete_json` relies on model discipline | P2: grammar/JSON-mode in shimmy fork or robust JSON repair in teri (already partial) |
| Default `max_tokens=256` when omitted (teri omits it) | every persona/report completion truncated | **P1 (one-liner): teri sends max_tokens explicitly** |
| Anthropic `/v1/messages` non-streaming + teri hardcodes api.anthropic.com | AnthropicAdapter can't target shimmy; stream() empty | P2: configurable base_url; treat OpenAI route as the shimmy contract |

## The straightest line (phases; each = worktree → PR → green → merge, tests ≥ the 140 baseline)

- **P1 — wire the spine (the e2e milestone):** compose `run` = seed → graph **build with real local
  LLM extraction** (existing prompts/parsers) → persona gen → sim (MemoryStore + graph write-back
  wired) → report; provider-selection; send max_tokens; GGUF guard. Acceptance: one full run against
  shimmy-served GGUF emits a real report + verdict.json. *(This alone leapfrogs the offline forks'
  core: no cloud, no Python, one binary + shimmy.)*
- **P2 — parity core:** ontology pass; OASIS-grade persona/config generators (bias/reaction/influence);
  Twitter/Reddit platform presets; ReACT report tools (InsightForge analog); JSON-mode hardening.
- **P3 — serve + integrate the estate:** axum server on existing DTOs (SSE module ready); interview +
  chat endpoints; `/graph/data` D3-shape JSON; **prompt_hub front door dispatch** (a prediction request
  becomes a `handoff.task.v1` → teri run → witnessed delivery — composes with HFTASK-0003/0021);
  n8n map node for sim runs.
- **P4 — scale + provenance:** embeddings + hybrid memory search; shimmy throughput (pool/batching);
  RVF/cognitum witness on sim runs (hardware anchoring via the Seed once its data port is live) —
  predictions with provenance, which upstream MiroFish does not have.

## Research / Cross-References

Workflow `wf_5cdc9018` (3 agents, 93 tool calls; full file:line ledger in session task output).
Upstream: github.com/666ghj/MiroFish (backend/app/{services,api}/*, README, v0.1.2);
nikmcfly/MiroFish-Offline + EleutheroiEdge/mirofish-offline (Neo4j/Ollama swap, GraphStorage
abstraction); amadad/mirofish-cli (verdict.json artifacts). teri: src/{main,llm,seed/,graph/,agent/,
sim/,memory/,api/,report/} (140 tests green, run live); TODO.md staleness audit. shimmy:
src/{server.rs,openai_compat/,anthropic_compat.rs,engine/{airframe,safetensors_native,huggingface}.rs}
(serialization point engine/airframe.rs:82–99; canned SafeTensors :570–580; max_tokens default
engine/mod.rs:19–32). Estate docs: ARCHITECTURE-TRUTH.md (swarm-inference plane), GAP-REGISTER.md item
6, NORTH-STAR.md laws 1–2, ADR-0003 (kb→card minting for the P1 task), COGNITUM-SEED.md (P4 anchoring).
Memoir: mirofish-port-decision (to add), architecture-truth-census-2026-06-12.
