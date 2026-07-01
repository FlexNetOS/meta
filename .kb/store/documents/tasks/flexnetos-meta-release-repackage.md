---
id: 019f1f3b-ab47-7341-b89a-d177b63e2051
slug: tasks/flexnetos-meta-release-repackage
title: "FlexNetOS meta release repackage"
type: task
status: active
priority: high
tags: [packaging, release, meta-rust, flexnetos]
---

# Overview

Build and repackage the FlexNetOS-owned `meta` release from the clean-room source tree instead of inheriting the upstream `gitkb/meta` release omission.

Upstream `gitkb/meta` v0.2.22 was installed through the workspace Yazelix/Nushell frontdoor as bootstrap proof only. It is not the final FlexNetOS release contract because its archive and installers omit the `meta-rust` plugin binary even though `meta_rust_cli` is part of the clean-room workspace and declares `[[bin]] name = "meta-rust"`.

## Scope

- Use the clean-room `FlexNetOS/meta` branch as the packaging source.
- Keep upstream release artifacts as comparison evidence, not as the shipped FlexNetOS surface.
- Build and package the expected binary-producing crates: `meta_cli`, `meta_git_cli`, `meta_project_cli`, `meta_mcp`, `meta_rust_cli`, and `loop_cli`.
- Keep library and registry peer repos documented so the 14-repo inventory does not imply 14 installed binaries.
- Preserve the workspace-local install frontdoor under `/home/flexnetos/FlexNetOS/usr/bin` for local proof.

## Acceptance Criteria

- [ ] FlexNetOS release workflow builds `meta_rust_cli` on every release target.
- [ ] FlexNetOS archive contents include `meta`, `meta-git`, `meta-project`, `meta-mcp`, `meta-rust`, and `loop`.
- [ ] Unix and Windows installers expect and install `meta-rust` / `meta-rust.exe`.
- [ ] Homebrew or equivalent package formula installs `meta-rust`.
- [ ] `/home/flexnetos/FlexNetOS/usr/bin/meta rust --help` works after installing the FlexNetOS-built release.
- [ ] Release notes or docs explain why non-binary peer repos do not appear in `bin`.

## Related

- Blocks closing [[incidents/meta-rust-release-install-surface-gap]].
- Replaces the stale `.context` claim that distribution is complete with a FlexNetOS-specific repackage requirement.

## Progress Log

### 2026-07-01

- Revisited `.context/` and root GitKB documents after installing upstream
  `meta` through the workspace frontdoor.
- Confirmed child repo KBs are initialized but have zero documents under
  `.kb/store/documents`; the substantive release context is root-only.
- Recorded that the upstream release is bootstrap proof only and that
  FlexNetOS must ship `meta-rust`.
