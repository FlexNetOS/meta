---
id: 019ea301-30b3-7f63-8a6f-d4cd215aae57
slug: tasks/codex-rust-env
title: "Build Codex Rust environment parity"
type: task
status: draft
priority: medium
---

## Overview
Route the meta workspace Codex front door to the pinned Rust Codex CLI and remove stale Bun-installed Codex binaries/packages so PATH and Codex-owned hooks cannot fall back to the old JS shim.

## Acceptance Criteria
- [x] `codex` resolves through the meta wrapper to `$META_ROOT/.toolchains/openai-codex/current/bin/codex`.
- [x] `.codex` hook environment exports `CODEX_BIN_PATH`/`CODEX_CLI_BIN` to the Rust binary.
- [x] legacy Bun `@openai/codex` shims/packages/caches are removed from both historical Bun roots.
- [x] envctl codex-cli manifest regenerates this state and verifies absence of Bun Codex leftovers.

## Progress Log

### 2026-06-27
- Removed Bun-global `@openai/codex` from `.toolchains/bun` and `.toolchains/.bun`, including stale `.bin` shims and cache/vendor directories.
- Added Codex Rust binary exports to `.codex/hooks/with-meta-env.sh` and the generated envctl wrapper template.
- Strengthened envctl `codex-cli` detect/verify/remove hooks to fail if legacy Bun Codex shims/packages remain.
- Verification: `codex --version` -> `codex-cli 0.142.0`; `file .toolchains/openai-codex/current/bin/codex` -> ELF; envctl `codex-cli` detected healthy.
