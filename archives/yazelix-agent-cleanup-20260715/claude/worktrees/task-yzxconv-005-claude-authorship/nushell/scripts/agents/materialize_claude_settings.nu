#!/usr/bin/env nu
# materialize_claude_settings.nu — YZXCONV-005 deterministic Claude settings
# materializer.
#
# Projects the reviewed editable input (settings.json.src) byte-exactly to
# <out-dir>/settings.json and writes a provenance receipt beside it at
# <out-dir>/settings.materialize-receipt.json.
#
# Ownership contract (YZXCONV-002 ratified-by-default convention; reconcile
# against OWNERSHIP_MATRIX.md when it lands):
#   editable input : ~/.config/yazelix/agents/claude/settings.json.src
#   review copy    : <yazelix repo>/defaults/agents/claude/settings.json.src
#   live target    : ~/.claude/settings.json  (cutover only at mission RESET,
#                    orchestrator-run, after a checksum-backed archive copy)
#
# Determinism: settings.json output bytes are a pure function of the input;
# the receipt is byte-stable when SOURCE_DATE_EPOCH is set.
#
# Refuses to materialize any input that violates the shared invariants
# (missing ICM hooks, stale POSIX-shell wrapper hooks, retired-workspace or
# inactive-profile paths) — see claude_settings_invariants.nu.
#
# Usage:
#   nu materialize_claude_settings.nu <input.src> <out-dir>

use ./claude_settings_invariants.nu *

def fail [msg: string] {
    print --stderr $"claude-settings-materializer: ($msg)"
    exit 1
}

def main [input: path, out_dir: path] {
    if not ($input | path exists) {
        fail $"input not found: ($input)"
    }
    let raw = (open --raw $input)
    let parse_ok = (try { let _ = ($raw | from json); true } catch { false })
    if not $parse_ok {
        fail $"input is not valid JSON: ($input)"
    }
    let violations = (check-all $raw)
    if ($violations | is-not-empty) {
        for v in $violations {
            print --stderr $"claude-settings-materializer: invariant violation: ($v)"
        }
        exit 1
    }
    mkdir $out_dir
    let out_file = ($out_dir | path join "settings.json")
    $raw | save --force --raw $out_file
    let input_sha = ($raw | hash sha256)
    let output_sha = (open --raw $out_file | hash sha256)
    if $input_sha != $output_sha {
        fail "output bytes diverged from input (materialization must be byte-exact)"
    }
    let epoch = ($env.SOURCE_DATE_EPOCH? | default "")
    let materialized_at = if $epoch == "" {
        date now | date to-timezone UTC | format date "%Y-%m-%dT%H:%M:%SZ"
    } else {
        (("1970-01-01T00:00:00Z" | into datetime) + (($epoch | into int) * 1sec))
        | date to-timezone UTC
        | format date "%Y-%m-%dT%H:%M:%SZ"
    }
    let receipt = {
        schema_version: "yazelix.claude-settings.materialize-receipt.v0"
        input_path: ($input | path expand)
        input_sha256: $input_sha
        output_path: ($out_file | path expand)
        output_sha256: $output_sha
        generator: "yazelix/nushell/scripts/agents/materialize_claude_settings.nu"
        materialized_at: $materialized_at
    }
    $receipt
    | to json --indent 2
    | save --force ($out_dir | path join "settings.materialize-receipt.json")
    print $"materialized ($out_file) sha256=($output_sha)"
}
