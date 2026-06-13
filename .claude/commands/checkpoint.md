---
description: Witness progress into the fleet ledger — tamper-evident checkpoint events, the kernel's unit of durable memory
---

Record a witnessed checkpoint: `/checkpoint <note>` (work order inferred from the
active claim) or `/checkpoint <WORK-ORDER-ID> <note>`.

Checkpoints are how progress survives session death: each is a hash-chained event
in `handoff/.handoff/ledger.db` (rvf-crypto WitnessChain). If it isn't
checkpointed, the next session can't trust that it happened — chat history and
root markdown are NOT durable state (precedence: Git > ledger > cards > prose).

## Steps

1. **Locate the kernel.** `HF="${CLAUDE_PROJECT_DIR:-$PWD}/handoff/target/debug/hf"`
   (prefer release build); run from `handoff/`.

2. **Resolve the work order.** If the user gave only a note, find the active card
   via `"$HF" status` (claimed/in-flight). Multiple candidates → ask which one.

3. **Checkpoint:** `"$HF" checkpoint <WORK-ORDER-ID> "<note>"`. Write the note as
   state, not narrative: what landed (commits/PRs), what's verified, next safe step.
   `--auto` checkpoints the active/resume-target task; `--quiet` suppresses stdout.

4. **Card sync:** `"$HF" checkpoint --sync-cards` (or `"$HF" sync-cards`) rewrites
   card statuses from ledger truth (cards are derived views — never hand-edit them).

5. **Verify:** `"$HF" status` event count incremented; `"$HF" resume` reflects the note.

When to checkpoint: after each landed PR, before ending a segment, after any
decision another session must not re-litigate, and whenever >~20 tool calls of
real progress have accumulated unwitnessed.
