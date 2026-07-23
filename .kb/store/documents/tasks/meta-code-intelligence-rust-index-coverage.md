---
id: 019f2173-4a4a-7443-8909-7421f289434a
slug: tasks/meta-code-intelligence-rust-index-coverage
title: "Restore Rust coverage for GitKB code intelligence in meta workspace"
type: task
status: completed
priority: high
tags: [gitkb, code-intelligence, rust]
---

# Summary

GitKB code-intelligence prep succeeded mechanically, but the current index does not cover Rust source in the meta workspace.

# Source Evidence

- `/home/flexnetos/FlexNetOS/usr/bin/git-kb code doctor --json` initially reported zero symbols and recommended `git kb code index`.
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb code index` completed but indexed only two Ruby symbols from 76 files.
- Follow-up `code doctor` reported only `distribution/homebrew/meta-cli.rb` in file breakdown and no Rust language capability.
- `git-kb code impact meta_cli/src/main.rs --json` returned zero callers/impact even though Rust source exists.

# Acceptance Criteria

- Determine whether this workspace is missing Rust code-intelligence support, excluded Rust file discovery, or stale index configuration.
- Make `git-kb code symbols --file meta_cli/src/main.rs --json` return useful Rust symbols, or document why Rust is intentionally unsupported here.
- Add a repeatable prep command sequence for agents before refactor/source changes.
