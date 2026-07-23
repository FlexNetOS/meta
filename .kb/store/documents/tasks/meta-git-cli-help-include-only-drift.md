---
id: 019f2173-4a1a-70a1-8547-29722e45d53b
slug: tasks/meta-git-cli-help-include-only-drift
title: "Fix stale --include-only help in meta_git_cli"
type: task
status: completed
priority: high
tags: [code, help, meta-git]
---

# Summary

`meta_git_cli/src/lib.rs` embeds help text for `--include-only`, but the current live global filter is `--include`.

# Source Evidence

- `meta_git_cli/src/lib.rs` help text says `--include-only      Only run in specified directories`.
- The same help example uses `meta git checkout -b feature/new --include-only api,frontend`.
- Live `meta --help` shows `-i, --include <INCLUDE>` and does not show `--include-only`.

# Acceptance Criteria

- Update the embedded help and examples to the supported filter flag.
- Add or update tests so stale `--include-only` cannot reappear unless intentionally supported.
