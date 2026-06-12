---
name: verifier-cli
description: Evidence-capture protocol for verifying CLI binaries in this workspace (hf, meta, agent, teri, envctl, rtk, weave, …). ALWAYS use this when /verify targets a CLI change, when asked to "prove it works", "drive the binary", or before marking any CLI-surface task done. Runtime observation only — do NOT use for web/API surfaces (drive the socket instead) and do NOT substitute `cargo test` runs for it (tests are CI's job, not verification evidence).
---

# verifier-cli — drive the binary, capture what it says

Verification is runtime observation at the surface a user touches. For CLI work
that surface is the terminal: type what a user would type, capture what the
binary prints, including the ways it fails. Reading the code or re-running CI
proves nothing about the surface.

## Protocol

1. **Establish the change.** `git diff @{u}.. --stat` (or `origin/HEAD...`,
   or `gh pr diff <n>`) in the repo under test. The diff is ground truth; the PR
   description is a claim about it. Note mismatches — they're findings.

2. **Build the real artifact.** `cargo build -p <bin>` (debug is fine unless the
   claim is about perf). Build output is setup, not evidence — don't quote it as
   proof.

3. **Drive the documented surface, happy path first.** Run the exact invocation
   the docs/claim name. Capture stdout+stderr SEPARATELY when the contract
   distinguishes them (`cmd >out.txt 2>err.txt`), and capture the exit code
   **unpiped** — `cmd | head` clobbers `$?` with head's status (verified gotcha:
   use `cmd >f; echo $?` or `PIPESTATUS[0]`).

4. **Probe around the claim** (≥1 probe or the verdict is a happy-path replay):
   - flags: empty value, twice, conflicting pair, typo'd (does the error NAME the flag?)
   - args: missing required, extra positional, `--` handling
   - env: required vars unset (keyless `--help` must still work — exit 0),
     bogus values; for envctl-injected tools, verify the documented
     `envctl run -- <tool> …` shape, never raw exports
   - state: run twice (idempotent?), run from a different CWD (path resolution),
     run against missing/locked state files
   - exit codes: usage error = 2, runtime error = 1, success = 0 — check each

5. **Isolation.** Shared state (ledgers, sockets, tmux) → isolate: `mktemp -d`
   homes, `tmux -L <name>`, never the live checkout of a repo another session
   owns. rtk hook rewrites bare `grep`/`curl` — use `rtk proxy grep` or tool
   alternatives inside probes.

6. **Report inline** (the /verify format):
   - **Verdict:** PASS | FAIL | BLOCKED | SKIP — no partial pass; ambiguous
     output is FAIL with the raw capture attached.
   - **Steps:** one line per thing done to the RUNNING binary → what it showed,
     with the actual output quoted. Mark probes 🔍 — a probe that held is still
     a finding ("🔍 empty --from → clean error, exit 2").
   - **Findings:** anything that made you pause — unhelpful errors, odd
     defaults, doc/behavior drift, slowness. Pre-existing breakage is a finding,
     not noise.

7. **Witness it.** `/checkpoint "<verdict>: <surface> — <one-line evidence>"` so
   the verification survives the session.

## House truths (save yourself the rediscovery)

- `hf` verbs run from `handoff/`; the ledger is `handoff/.handoff/ledger.db`
  (sqlite3 CLI absent — use `python3 -c "import sqlite3, …"`).
- `teri` historically died on missing `LLM_API_KEY` before arg-parse — keyless
  `--help` is THE regression probe for it.
- `shimmy` SafeTensors engine returns canned text — a 1-token completion that
  says "coming soon" means stub backend, not success.
- Monitors, not sleep, for anything async (CI, auto-merge).
