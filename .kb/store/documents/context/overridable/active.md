---
id: 019f1f24-04fc-7c91-b3cc-9b967dedb6fc
slug: context/overridable/active
title: "Active Context"
type: context
status: draft
priority: medium
---

# Active Context

## Current Focus

The `FlexNetOS/meta` clean-room branch has been bootstrapped with GitKB context
and all `.meta.yaml` child repos are present locally. The upstream `gitkb/meta`
release binary is installed through the workspace frontdoor as bootstrap proof,
but it is not the final FlexNetOS release contract.

The current major lane is to build and repackage the FlexNetOS-owned clean-room
source so the installed release includes the `meta-rust` plugin binary. Upstream
v0.2.22 omits `meta-rust`; FlexNetOS will not carry that omission forward.

Active branch:

```text
codex/clean-room-foundation-base-20260628
868edfee4e5104a18c6818f2fb604305598fb01c
```

## Immediate Work

- Keep `.kb/store` trackable and keep GitKB caches/workspaces ignored.
- Keep `.meta.yaml` aligned with the local clone sources.
- Use installed `meta` for repo discovery proof, while remembering that the
  current installed binary proves upstream runtime behavior only.
- Build and package `meta` from the clean-room source before treating release
  distribution as complete.
- Resolve [[tasks/flexnetos-meta-release-repackage]] and
  [[incidents/meta-rust-release-install-surface-gap]] before publishing or
  repackaging FlexNetOS release artifacts.
- Index GitKB code symbols after repo discovery and source roots are final.

## Guardrails

- If `rtk-tokenkill` appears as a Cargo workspace member, stop and check the
  branch. That belongs to `main`, not this clean-room branch.
- Do not run broad child-repo operations until the clean-room branch context is
  committed and repo inventory is confirmed.
- Preserve the accidental earlier `main` GitKB work in stash; do not apply it
  blindly to the clean-room branch.
- Do not accept the upstream release archive as the FlexNetOS shipping surface:
  it omits `meta-rust`, while this branch includes `meta_rust_cli`.
