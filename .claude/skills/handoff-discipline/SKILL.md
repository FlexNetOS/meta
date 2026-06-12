---
name: handoff-discipline
description: The continuity contract for ALL session/work handoffs in the meta workspace. ALWAYS use this when starting a session, ending a session, handing work to a future session, checkpointing progress, resuming someone else's work, or when tempted to write any HANDOFF.md, SESSION-HANDOFF.md, or *-PROMPT.md file. Also triggers on "pick up where we left off", "close out", "wrap up", "next session", "continuity". Do NOT use for kb planning-doc authoring (that's the kb workflow) or for git commit mechanics.
---

# Handoff Discipline — the kernel is the only handoff path

Sessions die; context compacts; chat history lies by omission. The only state the
next session can trust is what the continuity layer witnessed. This skill is the
contract for putting state there and getting it back out (ADR-0003, ADR-0004,
policy P7).

## The two planes

| Plane | Lives in | Holds | Verbs |
|---|---|---|---|
| **Planning** | git-kb (database) | why/what: tasks, incidents, specs, context docs | `git kb create/show/board/commit` |
| **Execution** | `.handoff/` + fleet ledger (`handoff/.handoff/ledger.db`) | who/when/proof: cards, claims, checkpoints, packets, witnessed events | `hf mint/claim/checkpoint/ship/handoff/resume` |

Work crosses the seam exactly one way: **minting** (`/mint <kb-slug>` →
`hf task mint --from-kb`). Results flow back via write-back + derived cards.
Never copy kb content into prompts; never hand-author cards.

## State precedence (settle every conflict with this)

**Git > `.handoff/ledger.db` > task cards > packets/prose.**
Cards are derived views — regenerate (`hf checkpoint --sync-cards`), never hand-edit.
Packets are rendered views — re-render (`hf packet render`), never hand-write.

## The rhythm

1. **Session start → `/resume`.** Packet + fleet board + kb board, then *manually
   verify* packet claims against live state (PRs, `meta git status`) before acting.
   The SessionStart hook injects a compact packet automatically; `/resume` is the
   full sweep.
2. **Work in fresh worktrees** (policy P6.25). Shared checkouts are read-only —
   another session may be live in them (check `weave_sessions` / lease list when
   a checkout looks dirty).
3. **Witness as you land → `/checkpoint <note>`** after each merged PR, each
   decision others must not re-litigate, or ~20 tool calls of unwitnessed progress.
   Notes are state, not narrative: what landed, what's verified, next safe step.
4. **Segment end → `/handoff`.** Checkpoint → `hf handoff` → rendered packet.
   The packet IS the next-session prompt.

## Why you must not write HANDOFF/PROMPT markdown at repo roots

Every hand-written `SESSION-HANDOFF.md` / `*-MISSION-PROMPT.md` forks continuity
truth: it isn't witnessed, it goes stale silently, and the next session can't
tell it from the rendered packet. That drift is exactly what ADR-0004 §1
deprecates. The `agent guard` hook denies NEW files matching `*HANDOFF*.md` /
`*-PROMPT*.md` outside `.handoff/` (existing files are grandfathered — edit them,
don't clone them). If you feel the urge to write one, the kernel is missing a
verb — say so in the checkpoint note instead of routing around it.

## Graceful degradation (kernel tranche in flight)

| Want | Verb | If unavailable |
|---|---|---|
| compact resume | `hf resume --compact` | `hf resume \| head -25` |
| mint from kb | `hf task mint --from-kb` | checkpoint the intent; queue behind tranche |
| card refresh | `hf checkpoint --sync-cards` | leave cards stale; NEVER hand-edit |
| fleet board | `hf fleet status` | read capsules directly (see `/fleet`) |
| auto checkpoint | `hf checkpoint --auto` | explicit `/checkpoint <id> <note>` |
| rendered prompt | `hf packet render --prompt` | `hf handoff` packet + `hf resume` IS the prompt |

## Anti-patterns (each one has burned a real session)

- Trusting a packet/memory without manual verification — recalled state may predate
  merges. Verify, then act.
- Working in the shared checkout — a concurrent session's edits and yours
  interleave invisibly (leases exist: `hf claim` / weave).
- Marking done without witnessed evidence — checkpoint the commit hashes and test
  results, then claim done.
- Hand-editing derived views (cards, packets, capsules) — they get overwritten by
  the next sync; fix the source (ledger/kb) instead.
- Smuggling scope: a steward verdict sequences work WITHIN approved scope, never
  expands it (NORTH-STAR scope law). Classifier denial ×2 → escalate verbatim.
