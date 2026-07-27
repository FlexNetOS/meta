# Behavior tests for the Yazelix-owned RTK nu_shell config input and its
# materializer (nushell/scripts/materialize_rtk_config.nu).
#
# Usage: nu test_rtk_nu_shell_config.nu <repo-root>

def fail [message: string] {
    print --stderr $"rtk nu_shell config test: ($message)"
    exit 1
}

def main [root: path] {
    let root = ($root | path expand)
    let reviewed = ($root | path join "packaging" "rtk" "config.toml.src")
    let materializer = ($root | path join "nushell" "scripts" "materialize_rtk_config.nu")

    # 1. The reviewed repo copy parses as TOML and selects nu_shell.
    if not ($reviewed | path exists) { fail $"missing reviewed input ($reviewed)" }
    let config = (open --raw $reviewed | from toml)
    if ($config.shell?.mode? | default "absent") != "nu_shell" {
        fail "reviewed input does not select shell.mode = nu_shell"
    }
    # The input must not restore legacy shell rewrite hooks.
    if (open --raw $reviewed | str contains "rtk-rewrite.sh") {
        fail "reviewed input references a legacy rewrite hook script"
    }

    # 2. The materializer stages the input into a fresh target.
    let tmp = (mktemp -d)
    let target = ($tmp | path join "rtk" "config.toml")
    let first = (do { ^nu $materializer $target --source $reviewed } | complete)
    if $first.exit_code != 0 { fail $"materializer failed: ($first.stderr)" }
    let staged = (open --raw $target | from toml)
    if ($staged.shell?.mode? | default "absent") != "nu_shell" {
        fail "staged output does not select shell.mode = nu_shell"
    }

    # 3. Re-materializing archives the previous output (never deletes).
    let second = (do { ^nu $materializer $target --source $reviewed } | complete)
    if $second.exit_code != 0 { fail $"second materialize failed: ($second.stderr)" }
    let archives = (glob $"($target).archived-*")
    if ($archives | is-empty) {
        fail "previous output was not archived on re-materialize"
    }

    # 4. An input that does not select nu_shell is rejected.
    let legacy = ($tmp | path join "legacy.toml.src")
    "[shell]\nmode = \"legacy\"\n" | save $legacy
    let rejected = (do { ^nu $materializer ($tmp | path join "rejected.toml") --source $legacy } | complete)
    if $rejected.exit_code == 0 {
        fail "materializer accepted an input that does not select nu_shell"
    }

    print "ok rtk nu_shell config: reviewed input selects nu_shell; materializer stages, archives, and rejects non-nu_shell inputs"
}
