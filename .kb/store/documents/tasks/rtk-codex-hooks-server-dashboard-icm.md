---
id: 019f8bf0-7d1d-7f30-8d40-9d8e86e7bca3
slug: tasks/rtk-codex-hooks-server-dashboard-icm
title: "Implement RTK Codex hooks, server, dashboard, and ICM integration"
type: task
status: completed
priority: high
tags: [rtk, codex, yazelix, icm, hooks]
---

# Overview

Recover and reconcile the RTK feature branch, add native Codex interception and unified all-agent lifecycle management, expose authenticated read-only server and dashboard surfaces, integrate ICM over localhost HTTP, and publish the reviewed Yazelix Codex hook configuration transactionally.

## Goals

- Preserve existing FlexNetOS RTK work while merging current upstream behavior.
- Make Codex Bash and unified command execution use the native RTK rewrite and permission engines.
- Establish one registry for native-hook, plugin, and prompt-only agent integrations.
- Provide verifiable all-agent installation state without crossing Codex trust boundaries.
- Deliver authenticated server, dashboard/TUI, and optional ICM health integration.
- Extend Yazelix Codex publication from two outputs to config.toml, RULES.md, and hooks.json.

## Acceptance Criteria

- [x] Commit 04f9e28 is protected by an archive tag and the feature branch is recreated from current origin/develop and restored remotely without a force push.
- [x] Current rtk-ai/rtk develop is merged without losing rtk_nu, GitKB, agent rules, native hooks, or profile ownership.
- [x] rtk hook codex rewrites supported Codex Bash and unified exec payloads and fails open for malformed or unsupported input.
- [x] rtk init --all-agents and removal are idempotent, preserve unrelated configuration, and distinguish native hooks, plugins, and prompt-only integrations.
- [x] rtk verify --all-agents supports text and JSON and validates registrations, paths, hashes, payload compatibility, live rewrites, audit logging, trust state, and stale artifacts.
- [x] Yazelix publishes reviewed Codex lifecycle hooks transactionally as config.toml, RULES.md, and hooks.json with rollback and forbidden-path protection.
- [x] rtk server authenticates every non-health endpoint with RTK_SERVER_TOKEN and provides the requested redacted versioned read-only API.
- [x] rtk dashboard and hidden tui alias render five views from shared DTOs using local state by default and optional server state.
- [x] ICM integration uses its localhost HTTP API and all lifecycle events are covered without adding a Rust crate dependency.
- [x] Formatting, Clippy, Rust tests, Yazelix tests, Nix checks, regression checks, and fresh-process integration evidence are recorded.

## Context

Implements the user-approved RTK Hook, Server, Dashboard, and ICM Integration plan. Related records: [[tasks/meta-design-codex-hook-parity]], [[tasks/architecture-rtk-nu-adapter]], [[codex-compact-lifecycle-hooks-disabled-in-lifeos-a]]. Preserve the single-profile path law and Codex hook trust review boundary.

## Progress Log

### 2026-07-22

- Archived 04f9e28 locally and on origin as archive/feat-rtk-full-feature-config-pre-recovery-20260722.
- Recreated the feature branch at origin/develop and restored it without a force push.
- Merged current rtk-ai/rtk develop as aa2022f after a conflict-free merge-tree proof.
- Verified both parents are ancestors and fork-owned rtk_nu, GitKB, agent-rule, profile, and native-hook files remain byte-identical to origin/develop.
- Passed cargo fmt check, warnings-denied Clippy, and cargo test --all: 2,463 main tests plus all rtk_nu and integration binaries.
- Added and pushed the official Codex PreToolUse adapter and protocol fixtures as RTK commit ebe2370. It preserves Codex's supported allow-plus-updatedInput contract, uses RTK's existing rewrite and permission engines, and fails open for malformed, unsupported, denied, and untestable payloads.
- Re-ran the complete RTK gate: warnings-denied Clippy passed; cargo test --all passed with 2,469 main tests, 8 ignored, plus all rtk_nu and integration test binaries; rtk hook --help exposes codex.
- GitNexus detect-changes reported HIGH central-dispatcher reach (20 changed symbols, 12 flows); no permission-engine symbols changed.
- Added one typed registry for 14 integrations: six native hooks, three plugins, and five prompt-only agents. Prompt-only entries are structurally forbidden from claiming automatic interception.
- Added `rtk init --all-agents` install/uninstall orchestration with idempotent round-trip tests that retain unrelated hooks, rules, and plugin configuration. Fixed Droid cleanup so the install-time clean backup is never replaced by RTK-bearing state.
- Added `rtk verify --all-agents --format text|json` schema v1 covering registrations, expected paths and hashes, installed-binary hash parity, payload compatibility, a live `git status` rewrite, audit readiness, Codex trust review, and stale/duplicate artifacts. Codex remains incomplete until `/hooks` review; RTK never reads or mutates the host trust database.
- Removed the verifier/audit writer's implicit `~/.local/share/rtk` fallback. Audit state now requires `RTK_AUDIT_DIR` or the profile-owned `XDG_DATA_HOME` root.
- Passed `cargo fmt --all -- --check`, warnings-denied Clippy, and `cargo test --all`: 2,490 main tests passed, 8 ignored, plus all `rtk_nu` and integration binaries.
- Added loopback-only `rtk server` with a mandatory `RTK_SERVER_TOKEN` on every endpoint except `/health`, strict request/header bounds, no-store responses, read-only SQLite tracking access, and versioned hook/agent/gain/failure/audit/redacted-config/ICM endpoints.
- Added `rtk dashboard` with the hidden `rtk tui` alias, shared API DTOs, five deterministic views, direct local collection by default, and authenticated remote collection through `--server`.
- Added the optional loopback-only ICM HTTP health bridge with bounded timeouts and no Rust crate dependency. Pinned ICM/FlexNetOS branches are recorded as behavioral provenance rather than cherry-picked code; lifecycle firing remains coupled to the Yazelix slice.
- Live integration proved `/health` and all seven `/v1` endpoints return HTTP 200 with correct authorization, missing authorization returns 401, startup fails without a token, and the remote dashboard renders all five views. The live run caught and fixed the initial `/v1/hooks` client timeout.
- Passed `cargo fmt --all -- --check`, warnings-denied Clippy, and `cargo test --all`: 2,505 main tests passed, 8 ignored, plus all `rtk_nu` and integration binaries.
- Hardened the HTTP parser with one absolute request-header deadline and expanded recursive config redaction to cover camelCase credential keys; both regression tests pass.
- Re-ran the final RTK slice gate: `cargo fmt --all`, warnings-denied Clippy, and `cargo test --all` passed with 2,506 main tests, 8 ignored, plus every `rtk_nu` and integration binary.
- Refreshed GitNexus to 14,592 nodes and 28,784 edges. Staged `detect-changes` reports CRITICAL reach (10 files, 224 symbols, 300 flows) because the additive `server` and `dashboard` variants attach to the central `run_cli` dispatcher and the index noisily maps the slow-header test across unrelated flows. Exact diff inspection confirms existing dispatcher arms, rewrite logic, and permission logic are unchanged; the warning is retained alongside the full-gate and live-integration evidence.
- Final RTK repair commit `99c3751` accepts a complete managed Codex `RULES.md` awareness block, follows the executing immutable payload behind a profile wrapper, and makes audit probes concurrency-safe. Formatting, warnings-denied Clippy, and `cargo test --all` pass with 2,510 main tests, 8 ignored, plus all `rtk_nu` and integration binaries.
- Yazelix publishes reviewed `config.toml`, `RULES.md`, and `hooks.json` in one v2 recovery transaction while retaining v1 journal recovery, unrelated hooks, exact profile paths, deterministic bytes, two injected-crash rollback points, and forbidden-path rejection. The direct materializer, provenance gate, `nix flake show --all-systems`, and all 20 current-system `nix flake check` derivations pass.
- Migrated verified closure `/nix/store/1w6c6rgxk33hqbzsaw050ycd73w0qla2-lifeos-foundation-yzx` into profile `/nix/store/7bda6iz8c0xmhmk5k3z8zp8lsfyj0gpl-profile`. Live Codex verification passes registration, rules hash, payload compatibility, rewrite, audit, and RTK payload hash; trust alone remains incomplete as required.
- Direct live hook fixtures produced ICM telemetry IDs 21081–21086 with exit 0 for post, pre, start, compact, end, and prompt. A fresh Codex `/hooks` review showed 7 installed, 0 active, and 7 awaiting review; the trust database was not modified.
