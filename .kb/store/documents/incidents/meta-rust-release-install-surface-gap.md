---
id: 019f1f36-18fe-7521-b31c-6df284e44187
slug: incidents/meta-rust-release-install-surface-gap
title: "Meta release omits meta-rust plugin binary"
type: incident
status: active
priority: high
tags: [packaging, release, meta-rust]
---

# Overview

The clean-room meta workspace has 14 peer repositories under `.meta.yaml`, but the upstream `gitkb/meta` release/install surface only produces five shipped binaries: `meta`, `meta-git`, `meta-project`, `meta-mcp`, and `loop`. The local workspace also has a wrapper `meta`, preserving the upstream binary as `meta-release`, so `/home/flexnetos/FlexNetOS/usr/bin` shows six meta-related entries.

Part of the difference is expected: several peer repos are libraries or registries and should not produce binaries. The product defect is that `meta_rust_cli` declares a `meta-rust` binary, but the release workflow, Unix installer, Windows installer, Homebrew formula, and upstream tarball omit it.

## Evidence

- `src/meta/.meta.yaml` lists 14 child repos.
- `meta project list --json` returns 14 child projects.
- `src/meta/meta_rust_cli/Cargo.toml` declares `[[bin]] name = "meta-rust"`.
- `src/meta/.github/workflows/release.yml` clones `meta_rust_cli` but does not run `cargo build -p meta_rust_cli`.
- The same workflow packages `meta`, `meta-git`, `meta-project`, `meta-mcp`, and `loop`, but not `meta-rust`.
- `src/meta/install.sh` expected binaries are `meta`, `meta-git`, `meta-project`, `meta-mcp`, and `loop`.
- `src/meta/install.ps1` expected binaries omit `meta-rust.exe`.
- `src/meta/distribution/homebrew/meta-cli.rb` installs the same five binaries and omits `meta-rust`.
- The downloaded upstream `v0.2.22` `meta-linux-x64.tar.gz` contains exactly: `loop`, `meta`, `meta-git`, `meta-mcp`, `meta-project`.
- `/home/flexnetos/FlexNetOS/usr/bin/meta rust --help` fails with `unrecognized command 'rust'`.

## Expected

Release packaging and installers must include `meta-rust` as an installed
plugin binary. FlexNetOS will not remove or disable `meta_rust_cli` to match the
upstream omission.

## FlexNetOS Decision

The upstream `gitkb/meta` v0.2.22 release/install surface is bootstrap evidence
only. After the proper clean-room source build, FlexNetOS will break from the
upstream package shape and ship a release surface that includes `meta-rust`.
This is tracked by [[tasks/flexnetos-meta-release-repackage]].

## Impact

Users see source/config evidence of a Rust plugin but cannot run `meta rust ...` from the installed release. This creates a mismatch between the multi-repo source shape, release artifact contents, and installed command surface.

## Acceptance Criteria

- [ ] Release workflow builds `meta_rust_cli` for every target.
- [ ] FlexNetOS release archive contains `meta`, `meta-git`, `meta-project`,
      `meta-mcp`, `meta-rust`, and `loop`.
- [ ] Unix and Windows package steps include `meta-rust` / `meta-rust.exe`.
- [ ] Unix and Windows install scripts expect and install `meta-rust` / `meta-rust.exe`.
- [ ] Homebrew formula installs `meta-rust`.
- [ ] Installed release exposes `meta rust --help` through plugin discovery.
- [ ] Release notes or docs explain why non-binary peer repos do not appear in `bin`.
