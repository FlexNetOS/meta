---
id: 019f2450-4c7c-7623-83bc-da6340b46a46
slug: register-envctl-peer-and-refresh-envctl-kb
title: "Register envctl peer and refresh envctl KB"
type: task
status: completed
priority: medium
---

# Summary
Register `envctl` as a meta peer so the workspace control plane can discover
it, include it in graph-aware operations, and let follow-on GitKB work use
`meta` as the frontdoor instead of ad hoc path assumptions.

# Evidence
- `.meta.yaml` now contains:
  - `envctl:`
  - `repo: https://github.com/FlexNetOS/envctl.git`
  - `path: ../envctl`
  - `depends_on: [loop-lib, plugin-protocol]`
- `meta project list -r` shows `envctl (../envctl)` as a registered peer.
- `meta exec --include envctl -- pwd` resolves and executes in `/home/flexnetos/FlexNetOS/src/envctl`.
- Root `.gitignore` did not need a change because `envctl` lives outside the
  root repo directory tree at `../envctl`, so it is not a nested tracked child
  path like `agent/` or `loop_cli/`.

# Outcome
The peer registration is live in the control plane and verified through both
project discovery and targeted execution.
