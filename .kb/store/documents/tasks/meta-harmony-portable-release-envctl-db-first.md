---
id: 019f0f4f-5c97-7c10-8c31-c4cdfcf62d00
slug: tasks/meta-harmony-portable-release-envctl-db-first
title: "Gap hunt meta harmony portable release and envctl database first"
type: task
status: active
priority: high
tags: [codex, research, envctl, yazelix, release, database]
---

# Overview

Gap hunt current paths and solutions for portable release foundation: nix-bundle/Yazelix, full multi-repo package including Nix -> meta parent -> envctl, meta-harmony release repo, crates.io+napi/npm key model, container-benefit verification, and envctl database-first config/certs/secrets/keys/variables/spec.

## Goals

- Find current repo paths and existing solutions before proposing new build work.
- Create/verify `FlexNetOS/meta-harmony` as the release orchestration repo.
- Define portable install design: installed from release first, then provider activation.
- Verify container-like benefits without container runtime being the primary foundation.
- Create durable KB spec for envctl database-first drift remediation.

## Acceptance Criteria

- [x] Current paths/solutions inspected for meta, envctl, Yazelix, nix-portable, release tooling, and DB surfaces.
- [x] `FlexNetOS/meta-harmony` repository created/verified in the org.
- [x] Gap-hunt architecture report written.
- [x] Draft ADR written.
- [x] KB spec for envctl database-first release control plane created.
- [ ] Meta-harmony repo initialized and adopted into `.meta.yaml` after local clone exists.
- [ ] First measured Yazelix portable release artifact built.
- [ ] envctl DB-first CLI/UI table implementation built.

## Context

- Report: `.handoff/loop/plan/reports/meta-harmony-portable-release-envctl-db-first-gap-hunt.md`
- ADR: `.handoff/decisions/ADR-0003-meta-harmony-envctl-db-first-release.md`
- Spec: `specs/envctl-database-first-release-control-plane`
- Repo created: `https://github.com/FlexNetOS/meta-harmony`

## Progress Log

- 2026-06-28: Created private GitHub repo `FlexNetOS/meta-harmony`, wrote gap hunt report and ADR, and created KB spec for envctl database-first release control plane. Found envctl already has secret/cert DB schema, but component/config/provider/manifest/artifact layers remain file-first and need table-backed projections.
