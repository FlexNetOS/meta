---
id: 019f23f5-dd31-7c62-b190-941dc30cab32
slug: tasks/meta-lifeos-portable-agentic-os-release-roadmap
title: "Add LifeOS portable agentic OS release roadmap"
type: task
status: completed
priority: high
tags: [lifeos, release, roadmap, agentic-os, github-issue-98]
---

# Overview

GitHub issue #98 asks for a real roadmap and release-architecture package that makes
`meta` the release control plane for a portable, self-contained LifeOS release
targeting `FlexNetOS/lifeos` on Ubuntu 26.04 x86_64. This is intentionally a
roadmap and execution package first: do not claim the release exists until later
build evidence proves it.

The work must produce repository files through a normal PR titled
`Add LifeOS portable release roadmap`. The resulting package should make the next
implementation run obvious, bounded, and verifiable while preserving the meta-repo
boundary between `meta`, `lifeos`, `flexnetos_runner`, and Yazelix.

Prompt source: https://github.com/FlexNetOS/meta/issues/98

## Goals

- Extract issue #98 into this GitKB task and use this task as the active execution rail.
- Inspect the required current-state evidence across `meta`, `lifeos`,
  `flexnetos_runner`, and Yazelix before source edits.
- Create the requested LifeOS portable release roadmap and supporting docs/task maps.
- Separate verified `FACT`, desired `TARGET`, unresolved `QUESTION`, and
  proof-gated `BLOCKER` claims.
- Keep the design user-space only: no default Docker, Kubernetes, chroot,
  bubblewrap, systemd, `/usr`, `/opt`, `/etc`, `/var`, `/nix`, kernel, or
  privileged-host ownership claims.
- Record validation results in this task and in the PR body.

## Required Evidence Before Editing

Inspect at minimum:

- `meta`: `README.md`, `docs/architecture_overview.md`, `docs/mcp_server.md`,
  `.context/VISION_PLAN.md`, `.context/tasks/cicd-distribution-gaps.md`,
  `Makefile`, `Cargo.toml`, `.github/workflows/*`,
  `release-please-config.json`.
- `lifeos`: `README.md`, `AGENTS.md`, `DESIGN.md`,
  `src-tauri/tauri.conf.json`, `src-tauri/Cargo.toml`,
  `crates/*/Cargo.toml`, `package.json`, and `bun.lock` or `bun.lockb`
  if present.
- `flexnetos_runner`: `_work/README.md`,
  `scripts/install-runner-services.sh`,
  `crates/runner-actions/src/main.rs`, and `_work/identity/*` if present.
- Yazelix/Nix foundation evidence sufficient to pin the runtime-bedrock strategy.

If direct cross-repo inspection is unavailable, document exact manual inspection
steps and mark the missing evidence as `QUESTION`, not `FACT`.

## Required Deliverables

Create or update these files unless existing conventions clearly require another
location:

- `docs/lifeos-portable-release-roadmap.md`
- `docs/lifeos-agentic-os-architecture.md`
- `docs/lifeos-release-filesystem-layout.md`
- `docs/lifeos-runner-build-pipeline.md`
- `docs/lifeos-install-update-rollback-contract.md`
- `docs/lifeos-security-and-sandbox-policy.md`
- `docs/lifeos-toolchain-and-dependency-bundle.md`
- `docs/lifeos-release-acceptance-gates.md`
- `.context/tasks/lifeos-portable-release-roadmap.md`
- `.context/tasks/lifeos-release-task-graph.csv`
- `.context/tasks/lifeos-release-task-file-map.csv`

Update durable navigation/handoff surfaces where appropriate:

- `README.md`
- `docs/architecture_overview.md`
- `docs/mcp_server.md`
- `.context/VISION_PLAN.md`
- `.context/CONTEXT.md` if present
- `CHANGELOG.md` only if repo convention requires unreleased roadmap entries

## Roadmap Must Include

`docs/lifeos-portable-release-roadmap.md` must include all headings from issue #98:

- Executive decision
- Source architecture summary
- Current state from repo evidence
- Target release definition
- Non-goals and hard rejections
- Release filesystem layout
- Meta control-plane responsibilities
- Runner build/proof responsibilities
- LifeOS target responsibilities
- Yazelix/Nix foundation responsibilities
- Toolchain and dependency bundle strategy
- Build pipeline phases
- Installation, update, and rollback model
- Agentic OS runtime model
- Security and sandboxing model
- Hardware and GPU routing model
- MCP/agent control-plane model
- Validation and release gates
- Task graph
- Open questions
- PR/implementation sequencing

## Fixed Release Contract

The initial target is Ubuntu 26.04 x86_64. Use these exact artifact names:

- `lifeos-agentic-os-ubuntu-26.04-x86_64.tar.zst`
- `lifeos-agentic-os-ubuntu-26.04-x86_64.SHA256SUMS`
- `lifeos-agentic-os-ubuntu-26.04-x86_64.SBOM.json`
- `lifeos-agentic-os-ubuntu-26.04-x86_64.provenance.json`
- `lifeos-agentic-os-ubuntu-26.04-x86_64.install.sh`

The install contract must publish a Nix package and activate it only through
`/home/flexnetos/.nix-profile`. The development staging prefix
`FlexNetOS/lifeos/dist/lifeos-agentic-os/ubuntu-26.04-x86_64` may remain build
proof only when documentation states explicitly that it is never an installed
or active prefix.

The roadmap must fully specify the portable prefix tree from issue #98, including
`bin/`, `sbin/`, `lib/`, `libexec/`, `etc/lifeos/`, `share/`, `var/`,
`opt/`, `home/default/`, `repos/`, `sources/`, `toolchains/`, `manifests/`,
and `tests/`.

## Implementation Notes

- `meta` should own planning, repo graph, release command shape, MCP/agent
  visibility, dirty/source-drift gates, and evidence ledgers.
- `flexnetos_runner` should own build/proof execution, host preflight, logs,
  artifact output, retention, and rerun/resume strategy.
- `lifeos` should own the target staging layout, Tauri permission implications,
  runtime supervisor/update/adopt components, and final app integration.
- Yazelix/Nix should be treated as a pinned foundation whose closure or runtime
  extraction strategy must be documented honestly. If relocatability is unproven,
  mark it as a `BLOCKER` with alternatives.
- GPU/CUDA and hardware routing must stay future/proof-gated unless current
  evidence proves the exact path.
- Planned commands are allowed, but only commands actually run in this PR may be
  logged as passing.

## Acceptance Criteria

- [ ] This GitKB task captures the issue #98 prompt and is active/checked out.
- [ ] Required evidence is inspected before source edits and summarized in the docs.
- [ ] Roadmap docs exist and are linked from repo navigation/docs.
- [ ] Current-state evidence separates `FACT`, `TARGET`, `QUESTION`, and
  `BLOCKER`.
- [ ] The portable OS directory tree and artifact names are fully specified.
- [ ] Meta, runner, LifeOS, Yazelix, and runtime-manager responsibilities are
  separated.
- [ ] Ubuntu 26.04 x86_64 is the explicit initial target.
- [ ] LifeOS staging locations and large-artifact policy are documented.
- [ ] Manifest, checksum, SBOM, provenance, installer, update, and rollback
  contracts are documented.
- [ ] The no-Docker/no-default-container stance is encoded without implying
  kernel-level isolation.
- [ ] GPU/CUDA routing is treated as future/proof-gated unless current evidence
  proves it.
- [ ] `.context/tasks/lifeos-release-task-graph.csv` and
  `.context/tasks/lifeos-release-task-file-map.csv` parse as CSV and include
  the required columns.
- [ ] No secrets, tokens, private keys, host-specific secret paths, or large
  compiled binaries are introduced.
- [ ] `git diff --check` passes.
- [ ] CSV validation command from issue #98 passes.
- [ ] Rust gates are run if Rust code or workflow logic changes.
- [ ] PR body includes summary, evidence, artifact names, prefix layout, task
  graph IDs, validation results, `QUESTION`/`BLOCKER` list, no-secrets/no-large-
  binaries confirmation, and host-mutation opt-in confirmation.

## Related Documents

- [[tasks/meta-release-catalog-portable-tools]] - existing portable release catalog work.
- [[tasks/meta-local-ubuntu-release-runner]] - existing local Ubuntu runner release path.
- [[tasks/meta-system-architecture-documentation]] - prior architecture documentation.
- [[tasks/meta-verification-parity]] - local/CI/release gate alignment.

## Implementation Evidence

Source evidence inspected before edits:

- meta local files: README.md, docs/architecture_overview.md, docs/mcp_server.md,
  .context/VISION_PLAN.md, .context/tasks/cicd-distribution-gaps.md, Makefile,
  Cargo.toml, .github/workflows/*, release-please-config.json.
- LifeOS remote files from FlexNetOS/lifeos main at
  2c6e43894e54c0fc6a79fd284e3eb36a25579636: README.md, AGENTS.md, DESIGN.md,
  src-tauri/tauri.conf.json, src-tauri/Cargo.toml, crates/*/Cargo.toml,
  package.json, bun.lock.
- flexnetos_runner local files: _work/README.md,
  scripts/install-runner-services.sh, crates/runner-actions/src/main.rs.
  The runner worktree was dirty and was inspected read-only.
- Yazelix local files from fdcecb70237406555c79a4d1acfd87463d28f9e8:
  README.md, flake.nix, flake.lock.

Source files created or updated:

- docs/lifeos-portable-release-roadmap.md
- docs/lifeos-agentic-os-architecture.md
- docs/lifeos-release-filesystem-layout.md
- docs/lifeos-runner-build-pipeline.md
- docs/lifeos-install-update-rollback-contract.md
- docs/lifeos-security-and-sandbox-policy.md
- docs/lifeos-toolchain-and-dependency-bundle.md
- docs/lifeos-release-acceptance-gates.md
- .context/tasks/lifeos-portable-release-roadmap.md
- .context/tasks/lifeos-release-task-graph.csv
- .context/tasks/lifeos-release-task-file-map.csv
- README.md
- docs/architecture_overview.md
- docs/mcp_server.md
- .context/VISION_PLAN.md

Validation evidence so far:

- Required file presence check: PASS.
- Required roadmap heading check: PASS.
- CSV DictReader check: PASS, 19 task graph rows and 19 task-file map rows.
- git diff --check: PASS after marking new files intent-to-add.
- Secret-marker scan over changed files: PASS, no matches.
- Large/binary file scan over changed files: PASS, changed files are text/CSV
  and small documentation files.
- Existing docs/link validator: NOT APPLICABLE, no repo-native markdown or link
  validation command was found in Makefile, Cargo.toml, workflows, or README.
- Rust gates: NOT RUN, because this roadmap PR changes docs and CSV only, not
  Rust code or workflow logic.

## PR and CI Evidence

- Source commit: 0e678c8d5288e2f82d59ad733119b0a9b667407d.
- Branch: codex/lifeos-portable-release-roadmap.
- PR: https://github.com/FlexNetOS/meta/pull/99.
- PR title was changed from the issue-requested phrase to
  docs: Add LifeOS portable release roadmap so the existing Semantic PR Title
  workflow could pass while preserving the requested phrase.
- GitHub checks: PASS for Semantic PR Title, CodeQL, Analyze (actions), Format,
  Clippy, Test (ubuntu-latest), Test (macos-latest), Test (windows-latest),
  Integration Tests (ubuntu-latest), and Integration Tests (macos-latest).
