# claude_settings_invariants.nu — YZXCONV-005 shared invariant checks for
# materialized Claude settings (~/.claude/settings.json lineage).
#
# Pure checks: each returns a list of human-readable violation strings
# (empty list = pass). Used by both the materializer and the provenance gate
# so the two surfaces can never drift apart.

# The six hook events that must each carry an ICM hook entry. ICM memory
# capture is a hard runtime dependency; losing any of these entries is a
# blocking regression (YZXCONV-005 mission constraint).
export const ICM_EVENTS = [
    PreToolUse
    PostToolUse
    PreCompact
    UserPromptSubmit
    SessionStart
    SessionEnd
]

# Flatten every hook command string out of a parsed settings record.
export def hook-commands [settings: record]: nothing -> list<string> {
    let hooks = ($settings | get --optional hooks | default {})
    $hooks
    | values
    | flatten
    | each {|grp| $grp | get --optional hooks | default [] }
    | flatten
    | each {|h| $h | get --optional command | default "" }
    | where {|c| $c != "" }
}

# Every ICM event must keep at least one hook invoking the pinned nix-store
# icm binary ("…/bin/icm hook <phase>").
export def check-icm-hooks [settings: record]: nothing -> list<string> {
    let hooks = ($settings | get --optional hooks | default {})
    $ICM_EVENTS
    | each {|ev|
        let cmds = (
            $hooks
            | get --optional $ev
            | default []
            | each {|grp| $grp | get --optional hooks | default [] }
            | flatten
            | each {|h| $h | get --optional command | default "" }
        )
        if ($cmds | where {|c| $c =~ '/bin/icm hook ' } | is-empty) {
            $"missing ICM hook entry for event ($ev)"
        }
    }
    | compact
}

# No stale POSIX-shell wrapper hooks (the retired bash-to-nu wrapper style,
# e.g. "$HOME"/.claude/hooks/*.sh or bash -c/-lc shims). Yazelix agent hooks
# are Nushell/profile-binary only.
export def check-stale-wrappers [settings: record]: nothing -> list<string> {
    hook-commands $settings
    | each {|c|
        if ($c =~ '(^|[ /"(])bash([ "]|$)') or ($c =~ '\.sh([ ")]|$)') {
            $"stale POSIX-shell wrapper hook: ($c)"
        }
    }
    | compact
}

# No references into retired workspace .claude mirrors.
export def check-retired-workspaces [raw: string]: nothing -> list<string> {
    ["/home/flexnetos/lifeos/" "/home/flexnetos/meta/"]
    | each {|p|
        if ($raw | str contains $p) {
            $"retired workspace path referenced: ($p)"
        }
    }
    | compact
}

# No references into inactive Nix profile selections. ~/.nix-profile is the
# sole selector; pinned /nix/store/* content paths remain legitimate.
export def check-inactive-profiles [raw: string]: nothing -> list<string> {
    mut violations = []
    if ($raw | str contains "/nix/var/nix/profiles/") {
        $violations = ($violations | append "inactive profile path referenced: /nix/var/nix/profiles/")
    }
    if ($raw =~ 'profile-[0-9]+-link') {
        $violations = ($violations | append "inactive profile generation link referenced (profile-N-link)")
    }
    if ($raw | str contains "/.local/state/nix/profiles/") {
        $violations = ($violations | append "inactive profile path referenced: ~/.local/state/nix/profiles/")
    }
    $violations
}

# Run every invariant against the raw settings bytes. Throws if the input is
# not valid JSON (callers decide how to surface that).
export def check-all [raw: string]: nothing -> list<string> {
    let settings = ($raw | from json)
    check-icm-hooks $settings
    | append (check-stale-wrappers $settings)
    | append (check-retired-workspaces $raw)
    | append (check-inactive-profiles $raw)
}
