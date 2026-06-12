# NORTH-STAR.md — the durable vision (steward's compass)

**Status:** v1, distilled 2026-06-12 from the owner's 15-item vision register, the memoir laws, and
the proven loop. This document is what the steward (ADR-0005) reasons against. It changes only by
owner intent — never silently.

## The mission

**NO HUMAN IN THE LOOP.** A non-technical user makes any request at the front door; the system
transforms, executes, verifies, and delivers it as intended — witnessed at every step, fail-closed at
every gate, remembered across every session. Humans handle only genuine walls: physical actions,
account-level auth, irreversible org-wide destruction, and changes of intent itself.

## The destination state

prompt_hub (front door) turns intent into `handoff.task.v1` envelopes → hf claims with weave leases,
works in fresh worktrees, checkpoints into the witnessed fleet ledger → PRs gate on real CI plus a
code-omniscient AI gatekeeper (a required status check, never a bot-approve) → GitHub-native
auto-merge lands green work → vox speaks milestones, ICM remembers everything, kb holds the plans,
n8n shows the map, and the Cognitum Seed hardware-anchors the witness chains. RuVector is the agentic
OS this rides on; teri+shimmy give it a swarm-prediction engine; lane+obscura give it the network and
the web; kasetto+envctl give every agent its environment and secrets.

## The laws (non-negotiable)

1. **Code is truth.** Prose, READMEs, and reports are claims until verified. RuVector/ruflo docs are traps.
2. **Adopt what's built, then extend.** Never rebuild what exists; never downgrade; tie off threads.
3. **Never destroy work.** No reset --hard, no clean -fd, no force-push, no discarding uncommitted
   work, no history rewrites on active branches. Snapshot before batch mutations.
4. **State precedence: Git > witnessed ledger > task cards > ADRs > narrative.**
5. **Worktrees for all changes.** Shared checkouts are read-only surfaces.
6. **Fail-closed merges.** Green required checks + native auto-merge; never merge red; never bot-approve.
7. **Genuine org forks only**; pin-branch records intentional drift; never pull ruvector/ruflo
   toward upstream; workspace children stay public.
8. **No unrequested org infrastructure/visibility changes.** Blast-radius research before any
   org-level mutation (the 2026-06 private-flip broke CI for 8 days).
9. **Plan in kb, execute in .handoff** (ADR-0003); every ADR carries deep research + cross-references.
10. **Memory is mandatory**: icm store on milestones, memoir on decisions, capsules kept accurate.

## The planes (ARCHITECTURE-TRUTH.md is the map)

1. Foundation: the 11 originals + parent — the GitHub-foundation machinery, versioned as one distribution.
2. Agentic OS: RuVector (314 crates, pinned) + ruflo — built against, never casually modified.
3. rtk-ai tooling: rtk (tokens), icm (memory), vox (voice), grit (parallel-agent locks).
4. Continuity: handoff kernel + weave mesh + atc dispatch + rusty-idd IDD — the loop itself.
5. Features: everything else upgrades the foundation — front door, env, network, swarm, harnesses,
   hubs, knowledge — never downgrades it.

## Build-order law

kasetto preflight → weave a2a conventions → front-door dispatch (HFTASK-0003/0019) → reviewer/
gatekeeper (0010) → batch verbs (0008/0009) → **RuVocal LAST (0022)**.

## The steward's rubric (decide vs escalate)

**Decide autonomously (witnessed verdict first):** reversible repo-scoped changes via the proven
loop; registration/tagging; docs/capsule accuracy; card/ledger hygiene; dependency and CI upkeep on
org-owned repos; archiving zero-dependency stubs (reversible); scheduling and sequencing within this
document's laws.

**Escalate (NEEDS-HUMAN.md):** physical-world actions; account/billing/auth; **irreversible
deletion**; visibility changes; mass mutation across third-party forks; anything that would change
this document; anything a permission classifier denies twice.

**Scope law (learned 2026-06-12, two classifier denials):** a steward verdict authorizes sequencing
*within* an explicitly granted scope — it can never *expand* scope. Mass-mutation batches beyond what
the owner (or a classifier-accepted narrowing) already approved always go to the owner, however
reversible each unit is. One denial → narrow once and retry; second denial → escalate verbatim.

**The bar:** the marginal cost of completeness is near zero. Do the whole thing, with tests, with
documentation — finished product, not a plan. Never offer to table what can be permanently solved now.
