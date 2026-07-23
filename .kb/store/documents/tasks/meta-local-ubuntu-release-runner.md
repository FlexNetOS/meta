---
id: 019f22ac-fb51-7632-bef4-85a037cbe20e
slug: tasks/meta-local-ubuntu-release-runner
title: "Build local Ubuntu release through flexnetos_runner"
type: task
status: completed
priority: high
---

## Overview

Set up the FlexNetOS local release path so `src/flexnetos_runner` owns the host-local build/provenance lane and `/home/flexnetos/FlexNetOS/release` is the output surface. The first release target is this box only: Linux Ubuntu 26.04 x86_64. The release must include Yazelix and avoid depending on Nix store paths for the packaged runtime.

Related work: [[tasks/meta-rust-release-packaging]], [[tasks/meta-release-workflow-meta-rust-artifact-drift]], [[tasks/meta-peer-local-kb-bootstrap]], [[tasks/meta-clean-foundation-build-order]].

## Acceptance Criteria

- [x] Identify the release host repo/surface and record why it is the right owner.
- [x] Add a local release build lane under `src/flexnetos_runner` that outputs into `/home/flexnetos/FlexNetOS/release`.
- [x] Build for Linux Ubuntu 26.04 x86_64 only.
- [x] Compile FlexNetOS runner binaries locally with Cargo.
- [x] Include Yazelix by building its Rust workspace locally and staging its runtime assets/configs without Nix store references.
- [x] Emit a single release archive plus manifest/provenance files.
- [x] Run the local release build on this box and record evidence.

## Progress Log

- 2026-07-02: Found `/home/flexnetos/FlexNetOS/release` as the empty workspace release output directory and `src/flexnetos_runner` as the release runner/provenance repo named by the root workspace contract.
- 2026-07-02: Added `src/flexnetos_runner/scripts/build-local-ubuntu-release.sh` and `docs/local-ubuntu-release.md`. The release lane is strict to Ubuntu 26.04 x86_64, accepts an explicit runner-local `FXRUN_CARGO`, builds `flexnetos_runner`, `meta`, and `yazelix`, stages Yazelix runtime assets/configs, and emits archive/provenance into `/home/flexnetos/FlexNetOS/release`.
- 2026-07-02: Built candidate `release/flexnetos-ubuntu-26.04-x86_64-20260702T115802Z.tar.gz` with runner-local Cargo `1.96.1`. SHA-256 verification passed for `release/flexnetos-ubuntu-26.04-x86_64-20260702T115802Z.tar.gz.sha256`.
- 2026-07-02: Candidate staged binaries: `fxrun`, `fxrun-actions`, `fxrun-dispatch`, `loop`, `meta`, `meta-git`, `meta-mcp`, `meta-project`, `meta-rust`, `yazelix_zellij_config_pack`, `yzx`, `yzx_control`, `yzx_core`, `yzx_repo_maintainer`, `yzx_repo_validator`.
- 2026-07-02: Proof scan found no `/nix/store` references in the valid candidate stage and no `/nix/store` strings in staged binaries.
