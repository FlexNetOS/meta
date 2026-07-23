---
id: 019f2159-5ecb-7de3-ab28-bc22297d06df
slug: tasks/meta-core-atomic-write-temp-collision
title: "Make meta_core atomic writes collision-safe"
type: task
status: completed
priority: medium
tags: [meta_core, store, concurrency]
---

# Summary

`meta_core` `write_atomic` should avoid a fixed sibling temp path when used outside the store lock.

# Evidence

The initial-10 source walk found `meta_core/src/store.rs` `write_atomic` writing to `path.with_extension("tmp")` before rename. The locked store path has synchronization, but `write_atomic` is a public helper and concurrent direct callers for the same target can collide on the same `.tmp` file.

# Acceptance Criteria

- Atomic writes use a unique temporary path or the helper is made private/documented as lock-only.
- Concurrent writes to the same logical target do not corrupt data or panic unexpectedly.
- Tests cover concurrent direct `write_atomic` behavior or the narrowed API boundary.
