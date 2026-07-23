---
id: 019f21fc-720e-7ac2-bd05-7460eaa34c6c
slug: tasks/meta-gitkb-daemon-embedding-proof-suite
title: "Prove GitKB daemon and embedding behavior"
type: task
status: completed
priority: medium
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Prove daemon lifecycle, file watching, MCP dependency, and optional embedding behavior before enabling adapter features that assume live daemon or semantic search support.

# Source Evidence

- `docs/gitkb/core-concepts-daemon.md` documents one daemon per KB, socket `.kb/cache/gitkb.sock`, file watching, auto-start, embeddings, logs, and resource use.
- `docs/gitkb/reference-troubleshooting.md` documents daemon status/start/stop/debug and stale socket repair.
- `docs/gitkb/reference-configuration.md` documents `[embeddings]` and `[embeddings.index]`.

# Commands And Configs Covered

- `git-kb daemon start`
- `git-kb daemon status`
- `git-kb daemon stop`
- `git-kb daemon restart`
- `git-kb daemon await-event`
- `git-kb daemon start --log-level debug`
- `git-kb serve --host <host> --port <port>`
- `git-kb serve --no-embeddings`
- `git-kb doctor`
- `git-kb ai embed`
- `git-kb ai embed --dry-run`
- `git-kb ai semantic <query>`
- `git-kb ai semantic --remote`
- `git-kb ai semantic --expand`
- `git-kb ai semantic --threshold <n>`
- `git-kb ai semantic --scope documents|code|all`
- `.kb/cache/gitkb.sock`
- `.kb/cache/daemon.log`
- `[embeddings] enabled`, `backend`, `model`, `batch_size`, `queue_size`, `batch_delay_ms`
- `[embeddings.index] path`

# Acceptance Criteria

- [x] Capture daemon status before starting or stopping anything.
- [x] Prove MCP server behavior with daemon auto-start or document why manual daemon start is required.
- [x] Do not remove `.kb/cache/gitkb.sock` unless ownership/staleness is proven.
- [x] Do not enable embeddings by default; require explicit resource decision.
- [x] If embeddings are enabled, record model/backend/resource impact and run dry-run or scoped embedding first.
- [x] Verify semantic search only after `[embeddings] enabled = true` and daemon readiness are proven.
- [x] Serving HTTP sync is treated as network-exposed and requires host/port/auth review before use.

# Completion Evidence

- 2026-07-02 correction: `git-kb init codex --dry-run` and `git-kb init codex` both reported 53 existing Codex/GitKB skill and instruction assets skipped; no Codex files needed to be written.
- 2026-07-02 correction: `git-kb init git hooks --dry-run` first reported 14 child repo `reference-transaction` hooks would be created, 0 already installed.
- 2026-07-02 correction: `git-kb init git hooks` installed the GitKB `reference-transaction` hook into all 14 child repos.
- 2026-07-02 correction: a follow-up `git-kb init git hooks --dry-run` reported 0 would be modified, 14 already installed, 0 errors.
- 2026-07-02 correction: `git-kb doctor --json` reported repo discovery, code symbols, KB projection, workspace checkouts, and lineage all ok.
- 2026-07-02 correction: `git-kb daemon status` now reports the daemon is not running for this KB, with code indexing enabled, repo discovery ok (meta), and 14 index roots; the earlier stale PID state was cleared through the GitKB CLI stop/status path.
- 2026-07-02 correction: Earlier embedding execution in this session modified local cache state and proved the model/runtime failure remains: full `git-kb ai embed --scope all` failed with `index-select invalid index 512 with dim size 512`.
- 2026-07-02: `git-kb daemon status` reported the daemon is not running for `/home/flexnetos/FlexNetOS/src/meta`.
- 2026-07-02: `git-kb mcp` tools/list succeeded after the MCP initialize handshake and returned 49 tools without requiring this task to start or stop a daemon.
- 2026-07-02: `git-kb info --json` reported embeddings with `document_count: 0`, `code_count: 0`, `models: []`, and vector dimensions/counts of 0.
- 2026-07-02: `git-kb ai embed --dry-run` returned `Embedding operations require the daemon. Run 'git-kb daemon start' first.`
- 2026-07-02 original proof note: No socket, daemon log, embedding index, or HTTP serving state was removed or modified during the earlier read-only proof pass. Later correction runs did start the daemon foreground and write local cache/vector state while testing embeddings.

# Progress Log

### 2026-07-02
- Corrected the proof record after running the missing `git-kb init` surfaces and live embedding attempt. Git hooks are installed in all 14 child repos; Codex init was already satisfied; embeddings remain blocked by the GitKB model/runtime error above.
- Completed daemon/embedding proof in read-only mode; embeddings and HTTP serving remain explicit opt-in work.
