---
id: 019f0a74-78af-7680-aa2f-eadc22bb7644
slug: tasks/meta-fleet-push-sync-path
title: "Find automated meta fleet push/sync path"
type: task
status: active
priority: medium
tags: [meta, codex, automation, git]
---

Deep-scan the current meta workspace and tooling until there is a clean, simple, automated path for safely pushing/syncing the meta peer repo fleet. Preserve dirty upgrade state; prefer existing rtk meta/envctl primitives; prove with dry-run/read-only scans before any mutation.

## Result

A clean automated path now exists in envctl PR #340:

```bash
# 0. Keep local worktree/branch husks from confusing the fleet audit.
(cd envctl && rtk bash scripts/reap-worktrees.sh --apply)

# 1. Snapshot before any fleet mutation.
rtk meta git snapshot create before-fleet-sync-$(date +%Y%m%d-%H%M%S)

# 2. Refresh remote tracking refs only; this does not touch worktrees.
rtk meta --sequential exec -- git fetch --all --prune

# 3. Dry-run/classify. Dirty, diverged, no-upstream, gone-upstream, and missing repos are skipped.
rtk python3 envctl/scripts/meta-fleet-sync.py \
  --meta-root /home/drdave/Desktop/meta \
  --no-fetch \
  --output /home/drdave/Desktop/meta/.codex/tmp/meta-fleet-sync-safe-report.json

# 4. Apply only if the report shows the intended safe buckets.
#    The script only runs git pull --ff-only for clean behind-only repos
#    and git push for clean ahead-only repos.
rtk python3 envctl/scripts/meta-fleet-sync.py \
  --meta-root /home/drdave/Desktop/meta \
  --apply \
  --output /home/drdave/Desktop/meta/.codex/tmp/meta-fleet-sync-apply-report.json
```

## Evidence

- Source scan: `meta git update` currently clones missing repos only; it does not pull existing repos despite help text. Raw `meta exec -- git pull --ff-only` / `meta exec -- git push` can fan out, but it does not classify safe vs dirty/diverged/no-upstream/gone-upstream repos first.
- Existing primitive retained: `rtk meta --sequential exec -- git fetch --all --prune` worked across the 68-repo fleet and is the right remote-ref refresh step.
- Real fleet dry-run after fetch: `.codex/tmp/meta-fleet-sync-safe-report.json` reported 68 repos: `clean_synced=5`, `dirty_skip=62`, `no_upstream_skip=1`, with zero eligible safe pulls/pushes in the current dirty upgrade state.
- Envctl PR #340 adds `scripts/meta-fleet-sync.py` and `scripts/tests/test-meta-fleet-sync.sh`. The hermetic test proves clean behind-only repos are FF-pulled, clean ahead-only repos are pushed, and dirty/diverged/no-upstream/missing repos are skipped.

## Safety invariant

The path is intentionally two-phase: report first, apply second. The apply phase never commits, stashes, resets, rebases, merges, force-pushes, or touches dirty repos. It only mutates repos that are clean and have a simple upstream relationship.
