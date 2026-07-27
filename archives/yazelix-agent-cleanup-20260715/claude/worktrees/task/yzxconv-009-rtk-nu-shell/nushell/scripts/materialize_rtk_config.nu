# Materialize the Yazelix-owned RTK config from its editable input.
#
# Ownership (YZXCONV-002 ratified-by-default convention, pending
# OWNERSHIP_MATRIX.md reconciliation):
#   editable input:   ~/.config/yazelix/rtk/config.toml.src
#   reviewed copy:    packaging/rtk/config.toml.src (this repo)
#   generated output: <target> — ~/.config/rtk/config.toml at the approved
#                     cutover; a staging path before that.
#
# Wave-B discipline: pass a staging --target now; the live cutover happens
# at the mission RESET checkpoint with checksum-backed backups. A
# pre-existing target is archived with a dated suffix, never deleted.
#
# Usage:
#   nu materialize_rtk_config.nu <target-config.toml> [--source <input.src>]

def fail [message: string] {
    print --stderr $"materialize_rtk_config: ($message)"
    exit 1
}

def main [
    target: path  # output config.toml (staging path now; live path only at cutover)
    --source: path = "~/.config/yazelix/rtk/config.toml.src"  # editable input
] {
    let source = ($source | path expand)
    let target = ($target | path expand)

    if not ($source | path exists) {
        fail $"missing editable input ($source)"
    }

    let raw = (open --raw $source)
    let config = ($raw | from toml)
    let mode = ($config.shell?.mode? | default "absent")
    if $mode != "nu_shell" {
        fail $"input does not select nu_shell: shell.mode = ($mode)"
    }

    mkdir ($target | path dirname)
    if ($target | path exists) {
        # Never delete: archive the previous output with a dated suffix.
        let stamp = (date now | date to-timezone UTC | format date "%Y%m%dT%H%M%SZ")
        let archive = $"($target).archived-($stamp)"
        mv $target $archive
        print $"archived previous output to ($archive)"
    }
    $raw | save $target

    let staged = (open --raw $target | from toml)
    if ($staged.shell?.mode? | default "absent") != "nu_shell" {
        fail $"materialized output ($target) does not select nu_shell"
    }
    print $"ok materialized ($target) selecting shell.mode = nu_shell from ($source)"
}
