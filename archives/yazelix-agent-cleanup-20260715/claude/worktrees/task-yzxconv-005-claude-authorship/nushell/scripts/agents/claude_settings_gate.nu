#!/usr/bin/env nu
# claude_settings_gate.nu — YZXCONV-005 runtime provenance gate for Claude
# settings authorship.
#
# Verifies that the settings.json in a Claude home directory is a byte-exact,
# receipt-backed materialization of the approved editable input, that it
# satisfies the shared invariants (ICM hooks present, no stale POSIX-shell
# wrapper hooks, no retired-workspace or inactive-profile paths), and that the
# claude binary is owned by the one Nix profile.
#
# EXPECTED RED against the live home (/home/flexnetos/.claude) until the
# mission RESET cutover writes the first receipt-backed materialization there.
# Staging validation points --home at a materialized staging directory.
#
# Usage:
#   nu claude_settings_gate.nu [--home <dir>] [--input <src>] [--review <path>]
#
# Emits per-clause booleans as JSON on stdout.
# Exit: 0 when every clause passes; 1 otherwise.

use ./claude_settings_invariants.nu *

def sha-of [f: path] {
    open --raw $f | hash sha256
}

def main [
    --home: path = "/home/flexnetos/.claude"
    --input: path = "/home/flexnetos/.config/yazelix/agents/claude/settings.json.src"
    --review: path  # optional repo-tracked review copy; enforces parity with the input
] {
    let target = ($home | path join "settings.json")
    let receipt_path = ($home | path join "settings.materialize-receipt.json")

    let input_exists = ($input | path exists)
    let target_exists = ($target | path exists)

    # C1: materialized settings satisfy every shared invariant.
    let invariants_ok = if $target_exists {
        (try { check-all (open --raw $target) } catch { ["target settings.json unparseable"] })
        | is-empty
    } else {
        false
    }

    # C2: a provenance receipt exists beside the target and its checksums
    # chain back to the approved input and forward to the target bytes.
    let receipt_ok = if (($receipt_path | path exists) and $input_exists and $target_exists) {
        let r = (try { open $receipt_path } catch { null })
        if $r == null {
            false
        } else {
            (
                (($r | get --optional input_sha256 | default "") == (sha-of $input))
                and (($r | get --optional output_sha256 | default "") == (sha-of $target))
            )
        }
    } else {
        false
    }

    # C3: settings checksum back to the approved input (byte-exact projection).
    let checksum_chain_ok = if ($input_exists and $target_exists) {
        (sha-of $input) == (sha-of $target)
    } else {
        false
    }

    # C4 (optional): the editable input matches the repo-tracked review copy.
    let review_parity_ok = if $review == null {
        null
    } else if (($review | path exists) and $input_exists) {
        (sha-of $review) == (sha-of $input)
    } else {
        false
    }

    # C5: claude launches from the one profile (~/.nix-profile owns the binary).
    let profile_claude = "/home/flexnetos/.nix-profile/bin/claude"
    let profile_binary_ok = if ($profile_claude | path exists) {
        (^realpath $profile_claude | str trim | str contains "claude-code")
    } else {
        false
    }

    let clauses = {
        input_exists: $input_exists
        target_exists: $target_exists
        invariants_ok: $invariants_ok
        receipt_provenance_ok: $receipt_ok
        checksum_chain_ok: $checksum_chain_ok
        review_parity_ok: $review_parity_ok
        profile_binary_ok: $profile_binary_ok
    }
    print ($clauses | to json --indent 2)

    let required = (
        [$input_exists $target_exists $invariants_ok $receipt_ok $checksum_chain_ok $profile_binary_ok]
        | append (if $review_parity_ok == null { [] } else { [$review_parity_ok] })
    )
    if ($required | all {|x| $x }) {
        exit 0
    } else {
        exit 1
    }
}
