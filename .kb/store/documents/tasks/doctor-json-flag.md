---
id: 019e958d-cd51-7b91-b6ef-9132a433fbc4
slug: tasks/doctor-json-flag
title: "Spec: `lane doctor --json`"
type: note
---

# Spec: `lane doctor --json`

## Intent (one sentence)
Add a `--json` flag to `lane doctor` that emits the diagnostic report as machine-readable JSON, mirroring the existing `lane list --json`, while the no-flag default keeps today's human-formatted checklist byte-for-byte unchanged.

## Goals
- `lane doctor --json` prints the full diagnostic report as JSON to stdout (no ANSI icons, no table formatting).
- Each check is represented as an object exposing its name, status, and message — the same three fields the human output renders.
- The JSON shape and style follow the `lane list --json` precedent: built with `serde`/`serde_json`, pretty-printed via `serde_json::to_string_pretty`, one top-level object.
- Status values serialize as stable lowercase strings (`pass` / `warn` / `fail`) so downstream tooling can branch on them.
- The default (no `--json`) output is identical to current behavior.

## Non-goals / out of scope
- Changing which checks run, their order, their messages, or the human-formatted output.
- Adding `--json` to any other command (`up`, `down`, `start`, etc.).
- A machine-readable exit code derived from check status (doctor's exit behavior is unchanged).
- Streaming/NDJSON, schema versioning, or a `--format` enum — only a boolean `--json` flag.
- Localizing or restructuring check `message` strings.

## Affected areas (high level)
- `src/cli/mod.rs` — the `Doctor` command variant currently carries no args; it must take a `DoctorArgs { json: bool }` (mirroring `ListArgs`), and the `Commands::Doctor => doctor::run().await` dispatch must pass the args through.
- `src/cli/doctor.rs` — `run()` gains a `--json` branch that serializes the `Report`; the existing `print_report`/`status_icon` human path is the `else`/default branch.
- `src/doctor/mod.rs` — `Status`, `CheckResult`, and `Report` need `serde::Serialize` (with `Status` serializing to lowercase `pass`/`warn`/`fail`) so the report can be marshaled. This is the data-model change; behavior of `run()` is untouched.

## Acceptance criteria
- [ ] `cargo build` and `cargo clippy --all-targets -- -D warnings` succeed in `/home/drdave/Desktop/meta/.worktrees/feat-doctor-json/lane`.
- [ ] `cargo test` passes; the pre-existing `src/cli/doctor.rs` tests (`test_print_report`, `test_status_icon`) still pass, proving the human path is intact.
- [ ] `cargo run -- doctor --help` lists a `--json` flag (grep the output for `--json`).
- [ ] `cargo run -- doctor` (no flag) produces icon/checklist output: stdout contains at least one of the glyphs `✓`/`!`/`✗` and contains NO `{` character (it is not JSON).
- [ ] `cargo run -- doctor --json` produces valid JSON: piping stdout through `jq .` exits 0.
- [ ] The `--json` output is a single top-level JSON object (top-level value parses as an object, e.g. `cargo run -- doctor --json | jq -e 'type == "object"'` exits 0), matching the `lane list --json` style of one object built with `serde_json`.
- [ ] Each diagnostic check appears in the JSON as an object exposing its `name`, `status`, and `message` — verifiable by `cargo run -- doctor --json | jq -e '[.. | objects | select(has("name") and has("status") and has("message"))] | length >= 1'` exiting 0.
- [ ] `status` values are the lowercase strings `pass`, `warn`, or `fail` only — verifiable by `cargo run -- doctor --json | jq -e '[.. | objects | .status? // empty] | all(. == "pass" or . == "warn" or . == "fail")'` exiting 0.
- [ ] A unit test in `src/doctor/mod.rs` (or `src/cli/doctor.rs`) serializes a `Report`/`CheckResult` and asserts the JSON contains `"status":"pass"` (and `warn`/`fail`), locking the lowercase-status contract regardless of host environment.
- [ ] The count and order of check objects in the JSON equals the count and order of rows in the default human output for the same environment (the JSON is a faithful serialization of the same `Report`, not a re-run with different checks).

## Open questions
- None blocking. Assumed default: a flat array of check objects under a top-level object (e.g. `{ "checks": [ {name,status,message}, ... ] }`) is acceptable; the architect may choose the exact top-level key name, since no external consumer contract exists yet. The acceptance criteria intentionally assert "object with name/status/message" rather than a fixed key path so this choice stays open without weakening verifiability.
