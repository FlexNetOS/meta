---
id: 019f0f50-71d7-7551-861a-620670e237f5
slug: specs/envctl-database-first-release-control-plane
title: "Envctl database-first release control plane"
type: spec
status: draft
priority: high
tags: [envctl, database, spec, release, control-plane]
---

# Overview

Envctl must become database-first for configs, certs, secrets, keys, variables, providers, components, release artifacts, and generated manifests. TOML, JSON, YAML, Nix, npm, Cargo, and desktop artifacts are generated projections from typed rows.

## Goals

- Eliminate manifest/config drift by giving every generated artifact a table-backed source row set and snapshot hash.
- Extend the existing envctl secret/cert DB model to non-secret config, components, providers, variables, and release artifacts.
- Provide one CLI/GUI table control plane for editing rows, previewing diffs, and generating artifacts.
- Keep secrets/keys brokered; generated artifacts never contain plaintext tokens.
- Support Meta Harmony release orchestration for Yazelix/Nix/meta/envctl portable releases.


## Source Evidence Preflight

Before any generated release/control-plane artifact is created, envctl/meta-harmony must load and reconcile source evidence from:

- `.kb` active and archival documents returned by `git kb search <topic> --json`.
- `.context/CONTEXT.md` and `.context/tasks/*` distribution docs.
- `.handoff/census-*` and relevant handoff architecture reports.
- live `.meta.yaml` repo graph and GitHub redirect/remote state.

A namespace such as `obsolete/` is metadata only. A claim is obsolete only when a current authoritative source explicitly supersedes that specific claim.


Hard gate: each source-evidence item must have captured command output or a file/line citation before it can support a generated artifact, ADR, repo creation/adoption, or completion claim. Failed, empty, or truncated retrieval must be recorded as `UNVERIFIED` and blocks dependent release planning until resolved or explicitly scoped out.

## Proposed Tables

| Table | Purpose |
|---|---|
| `config_items` | config keys, defaults, scopes, validation, owner, provenance |
| `component_rows` | envctl component definitions and lifecycle recipes |
| `provider_rows` | providers such as system-nix, nix-portable, bundle, cargo, npm, GitHub release |
| `variables` | environment variables, scope, redaction class, generated targets |
| `secret_refs` | references to existing vault secrets, never plaintext |
| `cert_refs` | cert/CA references and trust projection state |
| `key_refs` | publish/signing key references for crates.io/npm/GitHub/releases |
| `artifact_targets` | GitHub release asset, Nix bundle, AppImage, crate, npm package, SBOM |
| `generated_artifacts` | output path, format, generator, content hash, source query/hash |
| `drift_findings` | detector result, severity, owner, remediation, status |
| `release_graphs` | pinned meta/envctl/yazelix/meta-harmony revisions and hardware matrix |

## CLI Requirements

```text
envctl table list
envctl table schema <table>
envctl table get <table> [--where ...]
envctl table set <table> <key> <field=value...> --preview|--apply
envctl table edit <table> --widget --preview|--apply
envctl table diff <artifact|component|provider>
envctl table generate --format toml|json|yaml|nix|npmrc|cargo-plan --preview|--apply
envctl table verify --fail-on-drift
```

The CLI table widget must be schema-aware, keyboard-driven, preview-by-default, and backed by the same engine APIs as the GUI.

## GUI Requirements

- Table browser for config/components/providers/variables/artifacts/drift findings.
- Row editor with validation and generated artifact preview.
- Secret/key fields render references and metadata only, never plaintext.
- Generate/apply buttons use the same preview/apply engine as CLI.

## Generated Artifacts

- `envctl/manifest/*.toml`
- hub `registry.json`
- release graph YAML/JSON
- Nix bundle plan/flake projection
- `.npmrc` template with `${NPM_TOKEN}` placeholder only
- Cargo publish plan
- SBOM/checksum/signature metadata

## Acceptance Criteria

- [ ] Existing envctl manifests can be imported into DB rows without losing data.
- [ ] Regenerating TOML/JSON/YAML from DB rows is byte-stable or diff-explained.
- [ ] CI fails when generated artifacts drift from DB snapshot hash.
- [ ] CLI widget can edit a provider/component/config row in preview mode.
- [ ] GUI table view uses the same engine APIs.
- [ ] Secrets/certs/keys are references only in generated outputs.
- [ ] Meta Harmony can consume release graph rows and emit a portable Yazelix release plan after `.context`, archival KB, handoff census, and GitHub redirect evidence are reconciled.
