---
description: Mint a witnessed task card from a kb planning doc — the only sanctioned way work enters the execution plane (ADR-0003)
---

Turn a kb document into a kernel task card: `/mint <kb-slug>` (e.g.
`/mint tasks/fleet-handoff-rollout`).

kb is the **planning plane**; `.handoff` is the **execution plane**. Work crosses
that seam exactly one way: minting. A minted card carries `kb_ref` +
`correlation_id` back to the kb doc and an IntentLock over objective + criteria
(ADR-0003 rule 2). Never hand-author task cards and never copy kb content into
prompts — mint instead, so the ledger can witness the lineage.

## Steps

1. **Locate the kernel.** `HF="${CLAUDE_PROJECT_DIR:-$PWD}/handoff/target/debug/hf"`
   (prefer release build); run from `handoff/`.

2. **Confirm the source doc exists:** `git kb show <slug>` — the mint copies its
   objective and acceptance criteria. Empty body? Fix the kb doc first (edit under
   `.kb/workspaces/main/`, the path the 0.2.10 binary actually reads).

3. **Mint:** `"$HF" task mint --from-kb <slug>`.

4. **Verify:** `"$HF" status` lists the new card; its `kb_ref` matches the slug.

5. **Report:** card ID, IntentLock hash if printed, and the claim command
   (`"$HF" claim <ID>`) for whoever picks it up.
