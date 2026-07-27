#!/usr/bin/env nu
# claude_settings_authorship_test.nu — YZXCONV-005 tests for the Claude
# settings materializer + provenance gate.
#
# Read-only with respect to the live home: /home/flexnetos/.claude is only
# ever read (settings.json is CONFIG, not a secret). All writes go to a
# scratch staging root (mktemp).
#
# Run:
#   nu nushell/scripts/agents/tests/claude_settings_authorship_test.nu
# Exit: 0 when every test passes; 1 otherwise.

use ../claude_settings_invariants.nu *

const LIVE_SETTINGS = "/home/flexnetos/.claude/settings.json"

def script-dir [] {
    $env.FILE_PWD
}

def mat-script [] {
    script-dir | path join ".." "materialize_claude_settings.nu" | path expand
}

def gate-script [] {
    script-dir | path join ".." "claude_settings_gate.nu" | path expand
}

def review-copy [] {
    script-dir
    | path join ".." ".." ".." ".." "defaults" "agents" "claude" "settings.json.src"
    | path expand --no-symlink
}

def run-mat [input: path, out_dir: path] {
    do { ^nu (mat-script) $input $out_dir } | complete
}

def run-gate [home: path, input: path, review: any] {
    if $review == null {
        do { ^nu (gate-script) --home $home --input $input } | complete
    } else {
        do { ^nu (gate-script) --home $home --input $input --review $review } | complete
    }
}

# Extract the per-event ICM hook entries (serialized) from raw settings bytes.
def icm-entries [raw: string] {
    let settings = ($raw | from json)
    let hooks = ($settings | get --optional hooks | default {})
    $ICM_EVENTS
    | each {|ev|
        let groups = ($hooks | get --optional $ev | default [])
        let icm_groups = (
            $groups
            | where {|grp|
                ($grp | get --optional hooks | default [])
                | any {|h| ($h | get --optional command | default "") =~ '/bin/icm hook ' }
            }
        )
        { event: $ev, entries: ($icm_groups | to json --indent 2) }
    }
}

def main [] {
    let staging_root = (mktemp --directory --tmpdir "yzxconv-005-tests.XXXXXX")
    print $"staging root: ($staging_root)"

    if not ($LIVE_SETTINGS | path exists) {
        print --stderr $"FATAL: live settings not found at ($LIVE_SETTINGS)"
        exit 1
    }
    let live_raw = (open --raw $LIVE_SETTINGS)
    let live_parsed = ($live_raw | from json)
    let review = (review-copy)

    mut results = []

    # T1 — materializer refuses an input missing ICM hook entries.
    let t1_input = ($staging_root | path join "t1-missing-icm.src")
    $live_parsed
    | update hooks { $in | reject SessionEnd }
    | to json --indent 2
    | save $t1_input
    let t1 = (run-mat $t1_input ($staging_root | path join "t1-out"))
    $results = ($results | append {
        name: "T1 refuse input missing ICM hook entry"
        ok: (($t1.exit_code != 0) and ($t1.stderr | str contains "missing ICM hook entry for event SessionEnd"))
    })

    # T2 — materializer refuses a stale POSIX-shell wrapper hook.
    let t2_input = ($staging_root | path join "t2-stale-wrapper.src")
    $live_parsed
    | update hooks.PreToolUse {
        $in
        | append {
            matcher: "Bash"
            hooks: [{ type: "command", command: "\"$HOME\"/.claude/hooks/guard-bash.sh" }]
        }
    }
    | to json --indent 2
    | save $t2_input
    let t2 = (run-mat $t2_input ($staging_root | path join "t2-out"))
    $results = ($results | append {
        name: "T2 refuse stale bash/.sh wrapper hook"
        ok: (($t2.exit_code != 0) and ($t2.stderr | str contains "stale POSIX-shell wrapper hook"))
    })

    # T3 — materializer refuses retired-workspace paths.
    let t3_input = ($staging_root | path join "t3-retired-workspace.src")
    $live_raw
    | str replace "rtk hook claude" "nu /home/flexnetos/lifeos/.claude/hooks/rtk.nu"
    | save $t3_input
    let t3 = (run-mat $t3_input ($staging_root | path join "t3-out"))
    $results = ($results | append {
        name: "T3 refuse retired-workspace path"
        ok: (($t3.exit_code != 0) and ($t3.stderr | str contains "retired workspace path"))
    })

    # T4 — materializer refuses inactive-profile paths.
    let t4_input = ($staging_root | path join "t4-inactive-profile.src")
    $live_raw
    | str replace "rtk hook claude" "/nix/var/nix/profiles/per-user/flexnetos/profile-3-link/bin/rtk hook claude"
    | save $t4_input
    let t4 = (run-mat $t4_input ($staging_root | path join "t4-out"))
    $results = ($results | append {
        name: "T4 refuse inactive-profile path"
        ok: (($t4.exit_code != 0) and ($t4.stderr | str contains "inactive profile"))
    })

    # T5 — happy path: review copy materializes byte-exactly with a receipt.
    let t5_out = ($staging_root | path join "t5-out")
    let t5 = (run-mat $review $t5_out)
    let t5_settings = ($t5_out | path join "settings.json")
    let t5_receipt_path = ($t5_out | path join "settings.materialize-receipt.json")
    let t5_ok = if (($t5.exit_code == 0) and ($t5_settings | path exists) and ($t5_receipt_path | path exists)) {
        let receipt = (open $t5_receipt_path)
        let in_sha = (open --raw $review | hash sha256)
        let out_sha = (open --raw $t5_settings | hash sha256)
        (
            ($in_sha == $out_sha)
            and ($receipt.input_sha256 == $in_sha)
            and ($receipt.output_sha256 == $out_sha)
            and ($receipt.schema_version == "yazelix.claude-settings.materialize-receipt.v0")
        )
    } else {
        false
    }
    $results = ($results | append { name: "T5 byte-exact materialization + receipt", ok: $t5_ok })

    # T6 — determinism: re-running into the same destination under
    # SOURCE_DATE_EPOCH reproduces byte-identical settings and receipt.
    let t6a = ($staging_root | path join "t6a")
    let r6a = (do { with-env { SOURCE_DATE_EPOCH: "0" } { ^nu (mat-script) $review $t6a } } | complete)
    let snap_settings = if ($r6a.exit_code == 0) { open --raw ($t6a | path join "settings.json") } else { "" }
    let snap_receipt = if ($r6a.exit_code == 0) { open --raw ($t6a | path join "settings.materialize-receipt.json") } else { "" }
    let r6b = (do { with-env { SOURCE_DATE_EPOCH: "0" } { ^nu (mat-script) $review $t6a } } | complete)
    let t6_ok = if (($r6a.exit_code == 0) and ($r6b.exit_code == 0)) {
        (
            ($snap_settings == (open --raw ($t6a | path join "settings.json")))
            and ($snap_receipt == (open --raw ($t6a | path join "settings.materialize-receipt.json")))
            and ($snap_settings != "")
        )
    } else {
        false
    }
    $results = ($results | append { name: "T6 deterministic output and receipt", ok: $t6_ok })

    # T7 — materialized output preserves ALL current live ICM hook entries
    # byte-exactly (per-event serialized comparison).
    let t7_ok = if ($t5_settings | path exists) {
        (
            ((icm-entries $live_raw) == (icm-entries (open --raw $t5_settings)))
            and ((icm-entries $live_raw) | all {|e| $e.entries != "[]" })
        )
    } else {
        false
    }
    $results = ($results | append { name: "T7 ICM hook entries preserved byte-exactly vs live", ok: $t7_ok })

    # T8 — staged output passes every shared invariant.
    let t8_ok = if ($t5_settings | path exists) {
        (check-all (open --raw $t5_settings)) | is-empty
    } else {
        false
    }
    $results = ($results | append { name: "T8 staged output passes all invariants", ok: $t8_ok })

    # T9 — gate is RED on a home without a provenance receipt.
    let t9_home = ($staging_root | path join "t9-home")
    mkdir $t9_home
    open --raw $review | save --raw ($t9_home | path join "settings.json")
    let t9 = (run-gate $t9_home $review null)
    let t9_ok = (
        ($t9.exit_code != 0)
        and (($t9.stdout | from json | get receipt_provenance_ok) == false)
    )
    $results = ($results | append { name: "T9 gate red without receipt", ok: $t9_ok })

    # T10 — gate is GREEN on a fully materialized staging home.
    let t10 = (run-gate $t5_out $review $review)
    let t10_ok = (
        ($t10.exit_code == 0)
        and (($t10.stdout | from json | values | where {|v| $v == false } | is-empty))
    )
    $results = ($results | append { name: "T10 gate green on materialized staging home", ok: $t10_ok })

    # T11 — live-home gate contract: red while no live receipt exists
    # (pre-RESET), green once the cutover has written one (post-RESET).
    let live_receipt = "/home/flexnetos/.claude/settings.materialize-receipt.json"
    let t11 = (run-gate "/home/flexnetos/.claude" $review null)
    let t11_ok = if ($live_receipt | path exists) {
        $t11.exit_code == 0
    } else {
        (
            ($t11.exit_code != 0)
            and (($t11.stdout | from json | get receipt_provenance_ok) == false)
        )
    }
    $results = ($results | append { name: "T11 live-home gate matches cutover state", ok: $t11_ok })

    print ($results | table)
    let failed = ($results | where {|r| not $r.ok })
    if ($failed | is-not-empty) {
        print --stderr $"FAILED: ($failed | length) of ($results | length) tests"
        exit 1
    }
    print $"PASS: ($results | length)/($results | length) tests"
}
