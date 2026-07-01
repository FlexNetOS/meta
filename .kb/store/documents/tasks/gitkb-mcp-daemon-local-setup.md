---
id: 019f1f69-5389-7643-9d13-a11a34b95f47
slug: tasks/gitkb-mcp-daemon-local-setup
title: "Set up local GitKB MCP daemons"
type: task
status: draft
priority: medium
---

## Scope

Configure and prove local GitKB MCP/daemon readiness for the FlexNetOS
meta workspace and Yazelix peer repo without relying on GitKB cloud sync.

## Acceptance Criteria

- MCP client entries start from workspace wrapper frontdoors under
  `/home/flexnetos/FlexNetOS/usr/libexec`.
- The wrappers execute `/home/flexnetos/FlexNetOS/usr/bin/git-kb mcp`.
- The meta wrapper pins `GITKB_ROOT` to `/home/flexnetos/FlexNetOS/src/meta`.
- The Yazelix wrapper pins `GITKB_ROOT` to
  `/home/flexnetos/FlexNetOS/src/yazelix`.
- Wrapper PATH includes the workspace tool surface, the Yazelix profile bin
  through `${HOME}`, and the system Nix profile bin.
- `src/meta` and `src/yazelix` each have code indexing run and daemon status
  checked from their own KB root.
- `git-kb doctor` passes or any remaining diagnostic gap is recorded.
- Codex global MCP registration is present and points at these workspace
  wrappers, not an ambient user-local `git-kb`.

## Verification Notes

- GitKB version: `0.2.12`.
- Codex MCP registrations:
  - `gitkb` -> `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`
  - `gitkb-yazelix` ->
    `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-yazelix`
- Project MCP configs were added for Claude Code and Cursor in both
  `src/meta` and `src/yazelix`.
- Windsurf and Cline user-level MCP configs were added with both meta and
  Yazelix servers.
- MCP JSON files validate with `python3 -m json.tool`.
- MCP `initialize` and `tools/list` through both wrappers report GitKB
  `0.2.12` and 49 tools.
- MCP `kb_list` and `kb_callers` succeed through both wrappers.
- Meta code stats: 724 indexed symbols across 504 files, 1,348 call edges,
  zero stale files.
- Yazelix code stats: 4,358 indexed symbols across 369 files, 8,789 call
  edges, zero stale files.
- `src/meta` `git-kb doctor` passed 11 checks with no issues.
- `src/yazelix` `git-kb doctor` passed 7 checks with one warning: no `[repos]`
  section. The Yazelix KB is currently used as a single-repo code/document KB,
  so `git-kb repo list --json` returns `[]`.

## Runtime Finding

The pasted daemon docs say manual `git-kb daemon start` starts the daemon as a
background service, but the installed `git-kb 0.2.12` help says manual start
runs in the foreground unless `--background` is passed. `daemon start
--background` reaches readiness and writes watcher/socket state, but the process
does not remain resident after the client exits in this environment. MCP and
code-intelligence tool calls still succeed through the configured stdio wrappers.

## Repo Count Finding

`git-kb repo list --refresh --json` in `src/meta` discovers 16 repos: 14 child
source repos, the `yazelix` peer, and the meta root repo. The daemon watcher
root cache reports 14 active roots because it watches the 14 child source repos
and excludes the meta root plus the Yazelix symlink.
