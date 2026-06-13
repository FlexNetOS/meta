---
description: Close the current work segment through the handoff kernel — witness a checkpoint, emit the handoff event, and render the next-session packet (never hand-write a handoff file)
---

Close out the current work segment via the handoff kernel (ADR-0004). Hand-written
`*HANDOFF*.md` / `*-PROMPT*.md` files at repo roots are deprecated and guard-denied;
the kernel renders packets instead.

## Steps

1. **Locate the kernel.** `HF="${CLAUDE_PROJECT_DIR:-$PWD}/handoff/target/debug/hf"`
   (prefer `target/release/hf` when present). If missing, build it first:
   `cargo build -p hf` in `handoff/`. Run all verbs from the `handoff/` directory —
   the fleet ledger lives at `handoff/.handoff/ledger.db`.

2. **Witness the closing checkpoint** for the work order you carried this segment:
   `"$HF" checkpoint <WORK-ORDER-ID> "<one-line summary: what landed, what's next>"`.
   Pick the ID from `"$HF" status` (the active card). No active card → skip to step 3.

3. **Emit the handoff:** `"$HF" handoff`. This writes the witnessed handoff event and
   renders the resume packet to `handoff/.handoff/packets/latest.md`.

4. **Render a per-member packet** when handing a specific repo's loop forward:
   `"$HF" fleet render <member>` → that member's `.handoff/packets/latest.md`.

5. **Report:** the packet path, the ledger event count from `"$HF" status`,
   and the one command the next session should start with (`/resume`).
