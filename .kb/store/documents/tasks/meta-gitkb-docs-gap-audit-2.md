---
id: 019f2201-b2b1-7363-ac53-e0b2a5f95889
slug: tasks/meta-gitkb-docs-gap-audit-2
title: "Repeat GitKB docs symbol walk and close task rail gaps"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Repeat the GitKB docs extraction as a gap audit after the first task rail was committed. The goal is to catch commands, options, MCP parameters, paths, and skill symbols that were too coarse or missing from the first pass.

# Method

- Parsed all 19 extracted docs under `docs/gitkb/*.md`, excluding only the snapshot wrapper `docs/gitkb/README.md`.
- Counted 8,036 lines in the 19 docs and 247 fenced code blocks.
- Extracted actionable symbols by class: `git-kb` commands, `codex` commands, MCP tools, config sections, env vars, path/config tokens, inline code tokens, CLI options, MCP parameter names, and skill names.
- Compared the extracted tokens against existing `meta-gitkb-*` and `meta-plugin-*` task bodies.

# Gaps Found

- CLI command families were represented, but individual options and flags were not fully covered.
- MCP tools were represented, but parameter schemas and query-template names were not fully covered.
- Harness generation missed `.hermes/` from the live CLI reference's Windsurf/Hermes initializer text.
- Skill inventory was too implicit and missed explicit parity checks for `kb-progress` and all canonical task/code skills.
- Local skill-pack symlink examples such as `.claude/skills/atc` and `.codex/skills/atc` were not captured.
- Bundle/archive details `.kbbundle`, `.kbbundle.gz`, `bundle create`, and `bundle apply` needed a dedicated policy task because they replay history across KBs.
- Several sync, auth, search, context, code-intelligence, and recovery options needed to be added to existing tasks.
- The docs repeatedly name `.kb/workspace/`, while this repository materializes KB files under `.kb/workspaces/main/`; this doc/runtime mismatch must be verified before changing instructions.

# Tasks Created

- [[tasks/meta-gitkb-cli-option-level-parity]]
- [[tasks/meta-gitkb-mcp-parameter-schema-parity]]
- [[tasks/meta-gitkb-skill-inventory-adapter-parity]]
- [[tasks/meta-gitkb-bundle-archive-policy]]

# Existing Tasks Updated

- [[tasks/meta-gitkb-docs-command-config-extraction]]
- [[tasks/meta-plugin-gitkb-harness-generation]]
- [[tasks/meta-plugin-mcp-single-owner-policy]]
- [[tasks/meta-gitkb-config-schema-policy]]
- [[tasks/meta-gitkb-document-graph-view-policy]]
- [[tasks/meta-gitkb-code-intel-meta-proof-suite]]
- [[tasks/meta-gitkb-daemon-embedding-proof-suite]]
- [[tasks/meta-gitkb-sync-auth-remote-policy]]
- [[tasks/meta-gitkb-recovery-safety-policy]]

# Acceptance Criteria

- [x] Repeat mechanical extraction across all 19 docs.
- [x] Identify missing actionable command/config/symbol coverage.
- [x] Create or update KB tasks for the missing coverage.
- [x] Keep this as planning/proof work only; no implementation changes.
- [x] Run a second coverage comparison and reduce remaining actionable missing tokens to documented doc/runtime mismatch or exact-spelling additions.
