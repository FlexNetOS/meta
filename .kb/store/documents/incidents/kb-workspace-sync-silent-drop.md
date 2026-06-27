---
id: 019ebd8e-0a38-7560-a858-4c08c4193984
slug: incidents/kb-workspace-sync-silent-drop
title: "kb workspace edits silently dropped: status/diff/commit see clean while disk differs"
type: incident
status: resolved
priority: high
---

## Symptoms
`git kb checkout <slug>` → append/edit `.kb/workspace/<slug>.md` → `git kb status` reports
"workspace clean", `git kb diff` reports "No changes"; a subsequent `git kb commit` stores the
document with an **empty (or stale) body**. Reproduced three times across two sessions
(2026-06-12). Two real casualties: `tasks/fleet-handoff-rollout` and this incident doc itself —
both committed with empty bodies while full bodies sat on disk.

## Investigation (2026-06-12 FIX-MISSION session)
- No daemon involved: `ps` shows no git-kb process; binary `git-kb 0.2.10`
  (`~/.local/bin/git-kb`, 78MB regular file dated May 27 — NOT a symlink into meta; portability
  violation noted separately) has no `service` subcommand at all, so the parent SessionStart hook's
  `git kb service status || git kb service start` has been a silent no-op.
- `strace -f git-kb status` (the decisive probe): status reads ONLY `.kb/config.toml` and
  `.kb/.cache/gitkb.db` (+WAL). It **never stats or opens `.kb/workspace/`** — not one syscall.
- Fresh `git kb checkout` prints the smoking gun:
  `Checking out 1 document(s) to /home/drdave/Desktop/meta/.kb/workspaces/main`.

## Root cause
**Workspace path migration.** git-kb 0.2.10 materializes and tracks the workspace at
`.kb/workspaces/main/` (named-workspace layout). The estate's documentation and muscle memory —
`.kb/AGENTS.md`, `.claude/commands/kb-*.md`, prior sessions — all target the pre-0.2.10 path
`.kb/workspace/`. Files there are leftovers the binary never reads: edits land in a directory the
tool does not look at, status/diff legitimately (from the binary's view) report clean, and commit
consumes the checkout with its unmodified content. No hashing bug, no watcher, no daemon.

## Proof of resolution
Editing the SAME document under `.kb/workspaces/main/tasks/fleet-handoff-rollout.md` immediately
yields `status: modified: tasks/fleet-handoff-rollout` and a correct `git kb diff` (+1 line).
The backfill of all dropped bodies (this doc, the task doc, context/active, context/progress) was
performed and committed through that path — the resolution is self-demonstrating.

## Resolution
1. Edit path corrected: **always `.kb/workspaces/main/<slug>.md`** with git-kb 0.2.10.
2. Dropped bodies backfilled (task, incident, active, progress) and committed via the working path.
3. Legacy `.kb/workspace/` renamed to `.kb/workspace.pre-0.2.10.bak/` (content preserved; prevents
   future mis-edits).
4. Docs re-pointed in the parent repo: `.kb/AGENTS.md` + `.claude/commands/kb-*.md` references
   `.kb/workspace/` → `.kb/workspaces/main/` (parent PR).
5. Parent SessionStart hook's dead `git kb service …` line slated for the same docs PR
   (the 0.2.10 binary has `serve`, not `service`; no daemon is required for correctness).

## Gotchas for future agents
- The binary in `~/.local/bin` is a copy, not a symlink into meta — version drift between the
  binary and the in-repo docs is exactly how this incident happened. Portability principle says
  binaries live in meta with global symlinks pointing in.
- `git-kb` has no `add` verb: the workspace IS the staging area, but only the workspace the binary
  actually reads.
- gitkb upstream org is dead; no source checkout exists locally. If a real code bug surfaces next
  time, the path is fork-and-pin, not patch-upstream.

## Timeline
- 2026-06-12 ~20:0xZ: first drop observed (task body committed empty); incident filed (body itself dropped).
- 2026-06-12 ~22:3xZ: strace root-cause; right-path flow proven; backfills committed; resolved.
