---
id: 019f245a-3b43-73e2-8667-1d40ffc41b6c
slug: register-teri-peer-with-meta
title: "Register teri peer with meta"
type: task
status: completed
priority: medium
---

# Summary
Register `teri` as a meta peer so the workspace control plane can discover it
and include it in multi-repo operations from the same root graph as the rest
of the FlexNetOS peers.

# Evidence
- `.meta.yaml` now contains:
  - `teri:`
  - `repo: https://github.com/FlexNetOS/teri.git`
  - `path: ../teri`
- `meta project list -r` shows `teri (../teri)` as a registered peer.
- `meta git status --short --sequential` reports `teri` as a known peer and
  shows its live git state through the workspace frontdoor.
- Root `.gitignore` did not need a change because `teri` lives outside the
  root repo directory tree at `../teri`.

# Outcome
The peer registration is live in the control plane and verified through
project discovery and workspace status reporting.
