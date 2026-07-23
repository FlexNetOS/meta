---
id: 019f5f02-3ef6-7262-b423-f0f35447a2dc
slug: tasks/lifeos-real-bun-native-napi-receipt
title: "Verify LifeOS real Bun native N-API receipt"
type: task
status: active
priority: high
---

# Overview

Strengthen the LifeOS real-install Node authority receipt so it proves the
installed Linux x64 native N-API optional-package surface and the RuVector
capability flags, rather than only proving the JavaScript package graph.

## Goals

- Add a focused RED test that requires the runtime receipt to list installed
  Linux x64 native package paths and every RuVector capability flag as true.
- Extend `scripts/verify-node-authority.mjs` to resolve those optional packages
  from the real root `node_modules` tree and record their receipts.
- Regenerate the Bun-produced raw proof and verify the focused, authority,
  full-check, build, planning, and diff gates.

## Acceptance Criteria

- [ ] The initial focused test failure is captured before implementation.
- [ ] Receipt coverage includes `ruvllm-linux-x64-gnu`,
  `rvf-node-linux-x64-gnu`, `sona-linux-x64-gnu`, and
  `tiny-dancer-linux-x64-gnu`, plus actual native RuVector optional packages.
- [ ] The receipt proves every RuVector capability flag is true.
- [ ] Required verification commands pass using the real Bun frontdoor.

## Constraints

- Preserve existing unrelated edits in the Planning Spine reports.
- Do not touch Yazelix, nu_plugin, envctl, NBSOURCE-004, or secrets.
