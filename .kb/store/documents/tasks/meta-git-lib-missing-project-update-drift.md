---
id: 019f2173-4a29-7242-a06f-b2d6d23be5fd
slug: tasks/meta-git-lib-missing-project-update-drift
title: "Fix stale meta project update missing-repo hint"
type: task
status: completed
priority: high
tags: [code, help, meta-git-lib]
---

# Summary

`meta_git_lib/src/missing.rs` tells users to run `meta project update`, but current update behavior belongs to `meta git update`.

# Source Evidence

- `meta_git_lib/src/missing.rs` prints `Run meta project update to clone this repository`.
- Root README and plugin docs describe `meta git update` as the clone-missing/pull-existing command.
- `meta_project_cli/src/lib.rs` tests assert removed project subcommands do not appear.

# Acceptance Criteria

- Update the missing-repo hint to the current supported command.
- Add a focused test for the missing-repo hint.
