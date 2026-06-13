---
description: Resume work from kernel truth — handoff packet, fleet board, and kb board in one sweep (state precedence Git > ledger > cards > prose)
---

Rebuild working context from the continuity layer instead of re-deriving it from
chat history or root markdown (ADR-0004 precedence: Git > `.handoff/ledger.db` >
task cards > packets/prose).

## Steps

1. **Locate the kernel.** `HF="${CLAUDE_PROJECT_DIR:-$PWD}/handoff/target/debug/hf"`
   (prefer release build when present); run verbs from `handoff/`.

2. **Read the packet:** `"$HF" resume` (add `--json` for fields, `--compact` for a
   one-liner). This is the authoritative resume signal.

3. **Read any loop relay** a prior session left for you:
   `cat .handoff/loop/HANDOFF.md` (if present — the hand-off-to-next-session notes
   live there; it is guard-allowed because it is under `.handoff/`).

4. **Fleet view:** `"$HF" fleet status` — one board joining every repo's
   `.handoff/context/capsule.json` with ledger events (plane / next_command columns).

5. **Planning plane:** `git kb board` for active kb tasks (kb = planning,
   `.handoff` = execution — ADR-0003).

6. **Verify before acting** (standing directive): the packet reflects the last
   checkpoint, not necessarily live state. Cross-check its claims —
   `meta git status`, open PR states (`gh pr view`), the worktree list — before
   resuming the named task.

7. **Report:** active work order, next safe step, and any drift found between the
   packet/relay claims and live state.
