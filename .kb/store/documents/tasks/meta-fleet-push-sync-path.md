---
id: 019f0a74-78af-7680-aa2f-eadc22bb7644
slug: tasks/meta-fleet-push-sync-path
title: "Find automated meta fleet push/sync path"
type: task
status: draft
priority: medium
tags: [meta, codex, automation, git]
---

Deep-scan the current meta workspace and tooling until there is a clean, simple, automated path for safely pushing/syncing the meta peer repo fleet. Preserve dirty upgrade state; prefer existing rtk meta/envctl primitives; prove with dry-run/read-only scans before any mutation.