---
id: 019f2191-017c-7d00-af9c-03c18bd8af1b
slug: tasks/loop-cli-library-surface-parity
title: "Reconcile loop CLI and loop_lib surface parity"
type: task
status: draft
priority: medium
tags: [loop_cli, loop_lib, docs, verification]
---

Summary: Live loop CLI testing found behavior that differs from docs or loop_lib capability. Evidence: repeated --include flags select multiple directories; comma form --include one,two is treated as one literal directory. The standalone loop CLI rejects --json even though loop_lib has json_output support. An explicit directory listed in .looprc still ran when also named by --exclude skip. Spawn failure for a missing command returned exit 127 without panic, which confirms the prior loop_lib fix. Acceptance: decide intended include delimiter behavior, expose or document JSON support consistently, define exclude precedence for explicit directories, and add CLI-focused tests for the chosen behavior.