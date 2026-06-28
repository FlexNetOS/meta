---
id: 019f0f2c-5586-7f63-8240-6beb538a7f65
slug: tasks/yazelix-nix-portable-containment-bridge
title: "Research Yazelix Nix portable containment bridge"
type: task
status: active
priority: medium
tags: [codex, research, yazelix, nix, portability, envctl]
---

# Overview

Deep research corrective path for Yazelix Nix-store confinement and portability leak: compare Yazelix docs, nix-portable, nix-bundle, and adjacent bundle/package strategies; propose bridge keeping meta env off OS/user depths.

## Goals

- Identify the real gap bridge for Yazelix portability and confinement.
- Separate mutable runtime/update ownership from immutable titan/offline bundle artifacts.
- Preserve strict-upgrade behavior: no removal of current Yazelix/Nix path before wrappers, detectors, and parity proofs exist.
- Produce durable planning artifacts and a draft ADR for Feature Forge implementation.

## Acceptance Criteria

- [x] Research starts with Yazelix installation/troubleshooting, nix-portable, and nix-bundle.
- [x] Additional bundle/package precedents are checked for titan-class artifact options.
- [x] Plan names the corrective bridge and provider lanes.
- [x] Plan includes concrete filesystem roots, provider env, and verification criteria.
- [x] ROADMAP and draft ADR are promoted.
- [ ] Feature Forge implementation builds the provider detector/wrapper/proof harness.

## Context

- Research: `.handoff/loop/plan/research/yazelix-nix-portable-bridge.trends.md`
- Plan: `.handoff/loop/plan/reports/yazelix-nix-portable-containment-solution.md`
- Draft ADR: `.handoff/decisions/ADR-0002-yazelix-runtime-provider-adapter.md`
- Prior plan: `.handoff/loop/plan/reports/meta-env-install-containment-plan.md`

## Progress Log

- 2026-06-28: Researched current Yazelix docs, nix-portable, nix-bundle, nix-appimage, nix-bundle-dir, and Nix bundle docs. Concluded the bridge is a `YazelixRuntimeProvider` adapter with `system-nix`, `nix-portable`, and `bundle` lanes; nix-portable is the confinement/portability lane, bundle tools are release-artifact lanes.
