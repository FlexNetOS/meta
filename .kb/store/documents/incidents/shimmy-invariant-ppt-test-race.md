---
id: 019ebd4a-9e58-7982-bcce-8d571dfad7ab
slug: incidents/shimmy-invariant-ppt-test-race
title: "shimmy invariant_ppt tests race on global log (CI flake)"
type: incident
status: resolved
priority: high
tags: [ci, flake, shimmy, tests]
---

## Symptoms

meta PR #11 rerun (run 27429059428 attempt 5, 2026-06-12 19:09Z) failed `Test (ubuntu-latest)`:

```
invariant_ppt::tests::test_contract_test_success  — panic at shimmy/src/invariant_ppt.rs:73
  Contract test 'test_contract' failed. Missing invariants: ["Required contract"]
invariant_ppt::tests::test_invariant_logging      — panic at shimmy/src/invariant_ppt.rs:246
  assertion failed: checked.iter().any(|msg| msg.contains("Test invariant"))
test result: FAILED. 358 passed; 2 failed
```

Same commit passed on macos-latest and in the 2026-06-12 local battery → timing-dependent flake,
not a regression from teri#2.

## Root cause

`INVARIANT_LOG` is a crate-global `Mutex<HashSet<String>>` (invariant_ppt.rs:8). Tests follow a
clear → insert → read-assert sequence on it, and cargo runs tests on parallel threads:

- `test_property_test_success` → `property_test()` calls `clear_invariant_log()` **10× in a loop**
- `test_invariant_logging` / `test_contract_test_success` assert presence right after inserting

A foreign `clear()` landing between insert and read produces exactly the two observed panics.
Upstream already knew: `#[serial_test::serial]` is applied to 2 tests in `src/tests/ppt_contracts.rs`
(lines 177, 244) — but serial_test only serializes *marked* tests, so the remaining 12 clearing
tests still race (3 in invariant_ppt always compiled; 9 in ppt_contracts under llama features).

## Resolution

Fixed by extending upstream's own mechanism: `#[serial_test::serial]` on all 12 tests that clear
the shared log (serial_test 3.1 is an unconditional dev-dependency).

## Completion Evidence

- Reproduction: 198/600 stress failures pre-fix → **0/600 post-fix**; full lib suite 360 passed, 0 failed.
- Fix PR **FlexNetOS/shimmy#4** merged 2026-06-12 19:34:54Z as `4ba612d` (CodeQL ×5 green).
- meta PR #11 rerun attempt 6: `Test (ubuntu-latest)` — the previously failing job — **SUCCESS**.
- fmt/clippy gates clean; workspace battery 52 suites / 3527 tests / 0 failed includes the fixed shimmy.

Insert-only paths (`test_invariant_violation`, production `assert_invariant` callers) are not
serialized: every assertion in the crate is a presence check, so concurrent inserts are harmless.
