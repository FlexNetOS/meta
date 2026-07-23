---
id: 019f2201-b2c0-7100-a20f-20166e53efa3
slug: tasks/meta-gitkb-cli-option-level-parity
title: "Verify every documented GitKB CLI option and flag"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Verify every documented GitKB CLI option and flag against the live installed `git-kb` binary before any adapter, hook, or `meta-plugin` generator depends on that option.

# Source Evidence

- The repeat symbol walk found 176 actionable tokens not present in the first task rail, most of them CLI options from `docs/gitkb/cli-reference.md`.
- `docs/gitkb/cli-reference.md` is generated from `git-kb 0.2.6`, so local parity must be verified against the installed FlexNetOS binary.

# Option Families To Inventory

- Global/common: `--verbose`, `--quiet`, `--color`, `--log-format`, `--no-pager`, `--help`, `--version`
- Init/health/upgrade: `--remote`, `--cloud-remote`, `--org`, `--instance`, `--name`, `--no-verify`, `--check`, `--fix`, `--dry-run`, `--repair`, `--rollback`, `--cleanup`, `--root`
- Upgrade repair flags: `--adopt-current-live-state`, `--accept-missing-body-as-delete`, `--drop-missing-body-commits`, `--adopt-uncommitted-docs`, `--drop-uncommitted-docs`, `--drop-stale-duplicate-live-docs`
- Documents/search/list: `--type`, `--title`, `--body`, `--status`, `--priority`, `--tags`, `--assignee`, `--path`, `--slug`, `--template`, `--parent`, `--component`, `--blocks`, `--blocked-by`, `--refs`, `--related`, `--no-body`, `--limit`, `--offset`, `--sort`, `--asc`, `--desc`, `--since`, `--until`, `--format`, `--json`, `--unassigned`, `--assigned-to`, `--unblocked`, `--no-links`, `--save`, `--remote`, `--hybrid`, `--vector-weight`, `--keyword-weight`
- List traversal: `--recursive`
- Destructive/document mutation: `--force`, `--hard`, `--commit`, `--message`, `--amend`, `--close`
- Graph/views: `--to`, `--from`, `--position`, `--code`, `--repo`, `--depth`, `--direction`, `--rel-type`, `--critical-path`, `--scope`, `--columns`, `--sort-by`, `--sort-direction`, `--titles`, `--width`, `--summary`
- Workspace/log: `--flat`, `--short`, `--no-graph`, `--stat`, `--name-only`, `--oneline`, `--patch`
- Sync/auth/bundle: `--include-embeddings`, `--wire-json`, `--auto-rebase`, `--continue`, `--abort`, `--output`, `--slugs`, `--commits`, `--author`, `--stdout`, `--output-dir`, `--skip-documents`, `--skip-commits`, `--skip-stashes`
- Integrations/context: `--port`, `--host`, `--no-embeddings`, `--filter`, `--idle-timeout`, `--count`, `--task`, `--compact`, `--code-refs`, `--smart-code`, `--token-budget`, `--expand-callers`, `--expand-callees`, `--call-depth`, `--include-semantic`, `--semantic-limit`, `--min-score`, `--env`, `--branch`, `--auto`, `--fallback-recent`
- Ready/context aliases: `--context`, `--budget`
- Code intelligence: `--force`, `--dry-run`, `--prune`, `--language`, `--include-deps`, `--index-only`, `--embed-only`, `--branch`, `--worktree`, `--file`, `--kind`, `--parent`, `--body`, `--count`, `--compact`, `--group-by`, `--strict`, `--include-tests`, `--exclude-tests`, `--include-entrypoints`, `--include-public`, `--explain`, `--textual`, `--wikilinks-only`, `--include-maybe`, `--stale`, `--target`, `--include-docs`, `--refresh`, `--lines`
- AI: `--scope`, `--doc-type`, `--threshold`, `--file-path`, `--expand`
- Integrity/conflict: `--full`, `--strategy`

# Acceptance Criteria

- [x] Generate a live option inventory from `git-kb --help` and every `git-kb <command> --help` page.
- [x] Compare the live inventory to the option families above.
- [x] Mark docs-only options as blocked before using them.
- [x] Mark live-only options as documentation drift before adding adapter behavior.
- [x] Classify each option as read-only, mutating, destructive, networked, or auth-sensitive.
- [x] Destructive options require dry-run/check proof and explicit approval before any use.

# Completion Evidence

- 2026-07-02: Live help inventory produced 175 live option names from 121 help pages.
- 2026-07-02: Extracted docs option set contained 165 options. Docs-only options absent from live help were `--kb`, `--log-level`, and `--strategy`.
- 2026-07-02: Live-only options not in the extracted docs set were `--absolute-paths`, `--all-terms`, `--apply`, `--background`, `--copy`, `--kb-root`, `--local`, `--next`, `--push`, `--ready-file`, `--timeout`, `--where`, and `--yes`.
- 2026-07-02: Destructive/auth/network options remain prohibited for routine automation unless a dry-run/check path and explicit approval are recorded first.

# Progress Log

### 2026-07-02
- Completed option-level parity inventory and classified docs-only/live-only options as adapter blockers or documentation drift.
