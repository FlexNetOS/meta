---
id: 019f1f47-96ec-76d2-a56f-de55ad49da7a
slug: tasks/register-yazelix-meta-peer
title: "Register Yazelix as meta peer"
type: task
status: active
priority: high
tags: [meta, yazelix, gitkb]
---

# Overview

Register the existing local Yazelix checkout as a peer in the clean-room `FlexNetOS/meta` workspace.

## Scope

- Add `yazelix` to `.meta.yaml` using the local sibling path `../yazelix`.
- Use the actual local remote URL from disk: `https://github.com/FlexNetOS/yazelix.git`.
- Add branch mapping for the new peer to GitKB code intelligence config.
- Verify `meta project list` and `git-kb repo list` include the new peer.
- Keep GitKB local-first. This workspace syncs durable KB state through GitHub
  by tracking `.kb/store` and related repo files, not through GitKB cloud sync.

## Notes

The user wrote `FlexNetOS/yaxelix`, but the local repo on disk is `/home/flexnetos/FlexNetOS/src/yazelix` with remote `https://github.com/FlexNetOS/yazelix.git`.

## Progress Log

### 2026-07-01

- Removed the GitKB cloud sync remote after confirming this workspace is using
  local GitKB state plus GitHub for durable transport.
- Added `yazelix` to `.meta.yaml` with remote
  `https://github.com/FlexNetOS/yazelix.git`.
- Used an in-root symlink `src/meta/yazelix -> ../yazelix` so `meta` and GitKB
  can use a safe peer path while the actual checkout remains at the canonical
  workspace path `/home/flexnetos/FlexNetOS/src/yazelix`.
- Added `.gitkbignore` entries for `yazelix` because GitKB code indexing
  currently rejects symlink-resolved absolute Yazelix file paths during prune.
- Initialized GitKB and Codex scaffolding in the Yazelix peer.

## Verification

- `meta project list --json`: includes 15 child projects including `yazelix`.
- `meta project check`: all projects are cloned and present.
- `git-kb repo list --refresh --json`: includes 16 repos including root `meta`
  and peer `yazelix`.
- `git-kb code index --force --prune`: succeeds after `.gitkbignore` excludes
  the symlinked Yazelix path from code indexing.
- `meta exec -- git-kb verify`: ok for root, all existing children, and
  `yazelix`.
- `meta exec -- git-kb status --json`: clean for root, all existing children,
  and `yazelix`.

## Sync Policy

Use normal Git/GitHub to publish durable KB state:

- Track `.kb/store` and reviewed GitKB scaffold/config files in the owning repo.
- Use `git status`, `git add`, `git commit`, and `git push origin <branch>` when
  publishing.
- Do not require `git-kb push` / `git-kb pull` cloud sync for this local
  FlexNetOS workspace.
