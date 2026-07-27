# Contributing

Use Conventional Commit style for commit subjects and PR titles:

```text
feat: add workspace snapshot filtering
fix(meta_git_cli): preserve child repo commit type
ci: enforce semantic PR titles
docs: clarify plugin installation
```

If you are working from an internal GitKB task, include the task wikilink in
commit messages:

```text
fix: remove legacy meta agent workspace entry [[tasks/harmony-678]]
```

GitHub merge subjects are derived from PR titles, so the semantic PR title check
is the merge-blocking guard for release notes. Local hooks catch malformed commit
messages before push when installed with:

```sh
make install-hooks
```

Before running `git push`, run the repository verification target:

```sh
make verify
```

`make verify` now runs:

- `make lock-panic-check` to reject `lock()/read()/write()/try_lock()/try_read()/try_write()` with
  `unwrap()`/`expect()`
- formatting check
- clippy with warnings as errors
- full workspace tests
