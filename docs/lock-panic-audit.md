# Lock Panic Hardening Audit

## Scope
This repository must avoid `unwrap()`/`expect()` directly on lock operations.
Target patterns are:

- `.(lock|read|write|try_lock)().unwrap()`
- `.(lock|read|write|try_lock)().expect()`
- `.(try_read)().unwrap()`
- `.(try_read)().expect()`
- `.(try_write)().unwrap()`
- `.(try_write)().expect()`

## One-time implementation evidence
- A reusable guard script was added: `.github/scripts/check-lock-panics.sh`
- Script command:
- Default command:
- `.github/scripts/check-lock-panics.sh`
- Peer-repo audit mode (opt-in):
- `META_CHECK_PEER_REPOS=1 .github/scripts/check-lock-panics.sh`

  With `META_CHECK_PEER_REPOS=1`, the script also scans repositories declared in
  `.meta.yaml` when they are present locally as non-bare worktrees.
- Current state from verification run:
- `No lock/read/write/try_lock/try_read/try_write unwrap/expect patterns found.`

## Enforcement points
- Local checks:
  - `Makefile`
    - `verify` target depends on `lock-panic-check`
    - `lock-panic-check` runs `.github/scripts/check-lock-panics.sh`
  - `test`, `integration-test`, `bats` targets depend on `lock-panic-check`
- Git hooks:
  - `.githooks/pre-commit`
  - `.githooks/pre-push`
- CI workflows:
  - `.github/workflows/ci.yml` (all jobs)
  - `.github/workflows/release.yml` (build + publish jobs)

## Command evidence to keep current
Run after changes:

```sh
make verify
```

If `make verify` is unavailable in your environment, run:

```sh
.github/scripts/check-lock-panics.sh
```

Also verify locations:

```sh
rg -n --no-heading 'Check lock panic handling|check-lock-panics\.sh' .github/workflows/ci.yml .github/workflows/release.yml .githooks/pre-commit .githooks/pre-push Makefile
```

For quick documentation-link validation:

```sh
make verify-links
```

One-off peer-repo verification:

```sh
META_CHECK_PEER_REPOS=1 .github/scripts/check-lock-panics.sh
```
