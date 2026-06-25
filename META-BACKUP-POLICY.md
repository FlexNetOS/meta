# META-BACKUP-POLICY.md — Backup retention policy (FlexNetOS meta workspace)

**Status:** active · authored 2026-06-22 · referenced by `META-ORG-POLICY.md` P5.25
**Scope:** every member of `.meta.yaml`, all tiers. Governs tool-generated *safe-write
backups* — the `*.idd-bak-*` / `.idd-bak` artifacts emitted by `rusty-idd` and the `hf`
handoff kernel (both via `crates/core/src/fs_utils.rs::next_backup_path`), and any future
tool that snapshots a file before overwriting it.
**Why this exists:** the safe-write path appends an unbounded series of backup snapshots
(`<file>.idd-bak-1 … .idd-bak-N`, `N → 10000`) next to the live file with **no retention,
no compression, and no store**. A single repo (`rusty-idd`) had accumulated 100+ loose
`MANIFEST.tsv.idd-bak-*` snapshots; the same pattern is duplicated in the `hf` kernel, so
this is an org-wide artifact problem, not a one-repo cleanup.

---

## Principles (non-negotiable)

1. **Never delete a backup.** Backup *content* is immutable history and is retained
   forever. "Cleanup" means **relocate + compress into the store**, never destroy. The
   only file ever removed is a *loose* `.idd-bak` whose exact bytes are already preserved
   (content-verified by SHA-256) inside the store.
2. **One store per repo.** Each repo has exactly one backup store, not a scatter of loose
   files. The store is append-only.
3. **Compressed.** Backups live compressed (`zstd`) in the store, not as loose plaintext.
4. **Out-of-tree.** The store lives at the meta level, outside every child repo, so it
   never bloats any repo's git history and is one place to back up off-machine.
5. **Automated.** Relocation into the store is automated (tool + sweeper). No human is
   expected to hand-move backup files.
6. **Verifiable.** Every archived backup is content-addressed (SHA-256) and logged in an
   `index.tsv`, so any historical version is restorable and provable.

---

## The store

```
meta/.backups/<repo>/
  idd-backups.tar.zst   # append-only, zstd-compressed; entries are content-addressed
                        # by SHA-256; never deleted, rebuilt atomically on each sweep.
  index.tsv             # append-only log, one row per archived backup:
                        #   iso_ts <TAB> repo_rel_path <TAB> sha256 <TAB> orig_bytes <TAB> run_id
  README.md             # restore instructions (written on first run).
```

- **Content-addressed + deduplicated:** identical snapshots (e.g. byte-identical
  `MANIFEST.tsv` re-writes) are stored once; `index.tsv` records every occurrence with its
  original path and timestamp.
- **`meta/.backups/` is git-ignored** at the meta root (alongside the existing
  `.claude/backups/` / `.archives/` local-only precedent). It is **never committed** — it
  is durable *local* state, intended to be mirrored off-machine by the operator's own
  backup of the meta workspace.
- **Restore:** look up the version in `index.tsv` (by path + timestamp), then
  `tar -xOf idd-backups.tar.zst <sha256> > restored-file`.

---

## Automation (two layers — belt and suspenders)

1. **Sweeper (landed):** `meta/scripts/idd-backup-sweep.sh` finds loose `*.idd-bak-*` in a
   repo, archives each into that repo's store (content-verified), records `index.tsv`, and
   only then removes the loose copy. Dry-run by default; `--apply` to act. Idempotent and
   integrity-checked. It also `git rm --cached`s any backup that was historically tracked.
   Wire it via the SessionEnd hook and/or `meta exec -- meta/scripts/idd-backup-sweep.sh
   --apply` for periodic, fleet-wide rolling.
2. **Tool (follow-up, tracked):** patch `next_backup_path` / the safe-write path in
   `rusty-idd/crates/core` **and** `handoff/crates/core` so a new backup is appended to the
   store directly instead of being left loose. Each is a CI-gated shared crate, so it lands
   as its own per-repo PR (see goal `org-backup-retention-tooling`). Until then the sweeper
   fully covers the gap.

---

## Conformance

- A repo is **conformant** when it has zero *tracked* `.idd-bak` files and no loose
  `.idd-bak` files older than one sweep cycle.
- `*.idd-bak-*` MUST be git-ignored in every repo that runs the IDD/hf safe-write path
  (already true in `rusty-idd` root + `crates/core`; verify per repo).
- Never `rm` a `.idd-bak` by hand. Run the sweeper — it preserves the content first.

---

## Cross-references

- `META-ORG-POLICY.md` — P5.25 (this policy's hook into repo hygiene).
- `rusty-idd/crates/core/src/fs_utils.rs`, `handoff/crates/core/src/fs_utils.rs` — the
  `next_backup_path` source of the artifacts.
- `meta/scripts/idd-backup-sweep.sh` — the sweeper implementation.
