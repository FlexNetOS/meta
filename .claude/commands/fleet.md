---
description: One board for the whole fleet — join every repo's .handoff capsule with witnessed ledger events (ADR-0004 §4)
---

Show fleet-wide continuity state: which repo does what (capsule `role`/`plane`),
what each one's `next_command` is, and what the ledger has witnessed about it.

## Steps

1. **Locate the kernel.** `HF="${CLAUDE_PROJECT_DIR:-$PWD}/handoff/target/debug/hf"`
   (prefer release build); run from `handoff/` (or any dir under the meta root).

2. **Board:** `"$HF" fleet status` (add `--json` for machine output) — enumerates
   `../.meta.yaml` members, reads each in-repo `.handoff/context/capsule.json` plus
   the central fork registry `handoff/.handoff/fleet/<repo>/capsule.json`, and joins
   with ledger events.

3. **Render a member packet:** `"$HF" fleet render <member>` writes that member's
   `.handoff/packets/latest.md` from its capsule + cards + ledger slice.

4. **Report:** members with vs without `.handoff` (presence gaps → P7 conformance;
   org-owned hub stubs are NEEDS-HUMAN A), and any capsule whose `next_command`
   references a verb/path that no longer exists (staleness — capsules are seeded
   views; re-render, don't hand-fix).
