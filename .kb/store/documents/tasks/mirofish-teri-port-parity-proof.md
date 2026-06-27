---
id: 019eed02-acf5-7e53-b520-cb138726fd8b
slug: tasks/mirofish-teri-port-parity-proof
title: "Prove MiroFish->teri full-feature port parity (evidence per capability matrix)"
type: task
status: active
priority: medium
---

## Overview
The MiroFish->teri Rust port merge "just finished" but there is NO PROOF the full
feature set was ported. Authoritative spec: `~/Desktop/meta/MIROFISH-PORT-PLAN.md`
(parity matrix, W4 2026-06-12) — 5-stage pipeline (graph build / env setup / sim /
report / deep interaction). Parity is by-spec (MiroFish AGPL, teri MIT — no code copy).

## Goals
- Re-walk the parity matrix against CURRENT teri source + tests (the plan is a
  2026-06-12 snapshot; verify each P1/P2/P3 capability's real state now).
- Produce decision-grade PROOF: per capability -> implemented? tested? evidence (file:line + test).
- Differential/behavioral verification where feasible (not existence-checking).
- Identify any remaining gaps (missing/partial) and file follow-up cards.

## Acceptance Criteria
- [ ] Every matrix capability has a CONFIRMED/QUALIFIED/MISSING verdict with file:line + test evidence.
- [ ] `cargo test` in teri run + pass count recorded (baseline plan cited 140 tests).
- [ ] Keystone items verified: extraction orchestration (graph/mod.rs build), temporal
      memory write-back (sim<->memory wiring), sim loop composition.
- [ ] Parity report written; gaps -> follow-up cards.

## Context
Vehicle verdict: extend teri, don't re-port. shimmy = inference slot. Do NOT port Flask/Vue.
Source: `~/Desktop/meta/MiroFish` (Flask3+Vue3). Port target: `~/Desktop/meta/teri`.

## PROOF RESULT (2026-06-21)
Method: 4 parallel adversarial rust-port-parity-verifier agents vs current teri + tests.
Baseline: `cargo test --lib` = 1614 passed / 0 failed (vs plan's 140).
Full evidence: teri/.handoff/loop/findings/mirofish-port-parity-proof.md

VERDICT: port is MODULE-COMPLETE + heavily tested, but NOT end-to-end runnable.
CONFIRMED ported (plan flags STALE): graph extraction keystone real, memory write-back
WIRED, axum server real, embeddings/cosine real, ReACT report + 4 graph tools, OASIS
14-action set, sim loop composed (via HTTP).
GAPS: G1 CLI spine unwired (main.rs:83 bails — no `teri run` pipeline); G2 no verdict.json;
G3 build_llm always OpenAI (Anthropic/Gemini dead); G4 max_tokens not sent (256 truncation);
G5 Anthropic/Gemini stream() use OpenAI SSE framing (latent bug).
FIX: dispatched feature-forge-implementer on teri branch fix/mirofish-spine-and-llm (G1-G5).
