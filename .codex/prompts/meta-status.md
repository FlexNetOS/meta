---
description: Summarize the FlexNetOS meta workspace state.
argument-hint: [FOCUS="optional repo or concern"]
---

Run `rtk meta project list --json` and `rtk meta git status --json` from `$META_ROOT` (the directory containing `.meta`, `.meta.yaml`, or `.meta.yml`).
Treat this as a meta-repo of independent child repositories.
Summarize root state, dirty child repos, ahead/behind branches, and any scoped follow-up needed.
If `FOCUS` is provided, prioritize that repo or concern: $FOCUS.
