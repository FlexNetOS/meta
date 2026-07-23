---
id: 019f8a29-40aa-7423-953b-a9602653495d
slug: incidents/preserve-provenance-drift-inert-gate
title: "PRESERVE provenance CSV drifted; its validator was silently inert (no pytest)"
type: incident
status: completed
priority: medium
tags: [preserve, planning-spine, lifeos, provenance, test-gap]
---

## What happened

Discovered 2026-07-22 during the ARCHBP-134 spine flip (lifeos worktree
`archbp-frontier`). Two coupled defects:

1. **Inert gate.** `planning-spine-v0/test_preserve_artifacts.py` (the
   PRESERVE-002/003 validator) is written in pytest style — module-level
   `test_*` functions, no `unittest.TestCase`, no `__main__` runner. The
   foundation-tools python3 has **no pytest module**, and
   `python3 test_preserve_artifacts.py` exits 0 having executed **zero tests**
   (`python3 -m unittest test_preserve_artifacts -v` → "NO TESTS RAN"). Every
   per-flip gate run to date has therefore silently skipped it while the other
   four spine gates (unittest-style) genuinely ran.

2. **Provenance drift it was built to catch.** When the functions are invoked
   directly, `test_provenance_csv_exists_and_covers_all_peers` fails: the
   main-checkout artifact
   `/home/flexnetos/meta/src/lifeos/planning-spine-v0/generated/preserve_provenance_baselines.csv`
   no longer matches the live peer set under `/home/flexnetos/meta/src/`.
   - csv-only (recorded, now absent from disk): `mrv-ci-fix`,
     `meta-ruvector-router-wt`, `flexnetos_runner-kache-shim-wt`,
     `mrv-95-sync`, `flexnetos_runner-meta-prefix-wt`, `meta-ruvector-qat-wt`,
     `mrv-reconcile-wt` — all transient `-wt`/fix worktree peers cleaned up
     after their PRs landed (normal lifecycle, not data loss; their branches
     live in their parent repos).
   - disk-only (live, unrecorded): `envctl-wt-archbp042`, `atc`.
   `test_provenance_csv_head_commits_are_current` is also expected stale for
   any recorded peer whose HEAD advanced.

## Why it was not fixed inline

The CSV is a **main-checkout** artifact of the PRESERVE lane; re-baselining it
is a preservation-contract action (one row per live peer with provenance,
capability boundary, baseline command, parity gate) that must be done from the
main checkout with its own red→green + proof, not as a side effect of an
unrelated spine flip from an isolated worktree. Recording, not side-stepping.

## Fix path (acceptance)

- [x] Make the validator actually runnable — converted to unittest style with
      a loud `__main__` runner (zero new deps); SPINE now resolves relative to
      the file so each checkout validates its own artifacts.
- [x] Re-baseline `preserve_provenance_baselines.csv` — done in the
      archbp-frontier worktree (flows to main via PR #98): 7 stale rows dropped
      with final HEADs preserved in the topology reconciliation note, `atc` +
      `envctl-wt-archbp042` added, all surviving HEAD/branch/state refreshed;
      37 rows == 37 live peers.
- [x] All four validator tests execute and pass; PRESERVE-002 bumped to rev 2
      and PRESERVE-003 to rev 3 with the re-baseline evidence (ledger seq
      376/377, append-only).
- [x] Gate added to the per-flip pipeline (now 5 python gates); the unittest
      runner exits loudly on failure and can never silently no-op.

## Evidence

- `python3 -m unittest test_preserve_artifacts -v` → NO TESTS RAN, exit 0.
- Direct invocation → `AssertionError: peer set mismatch: csv-only={'mrv-ci-fix',
  'meta-ruvector-router-wt', 'flexnetos_runner-kache-shim-wt', 'mrv-95-sync',
  'flexnetos_runner-meta-prefix-wt', 'meta-ruvector-qat-wt', 'mrv-reconcile-wt'}
  disk-only={'envctl-wt-archbp042', 'atc'}`.
- Related: [[tasks/yzx-iso/t10-0-lane-index]] (the flip in flight when found).
