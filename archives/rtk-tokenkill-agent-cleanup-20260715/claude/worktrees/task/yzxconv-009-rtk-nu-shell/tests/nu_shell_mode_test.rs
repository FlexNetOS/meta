//! End-to-end proof of the documented `[shell] mode = "nu_shell"` selection.
//!
//! `nu_shell` is the native Nushell integration mode: interactive commands
//! route through the rtk binary via Nushell wrapper defs, so `rtk init` must
//! NOT emit legacy bash/zsh rewrite hooks (Claude settings.json PreToolUse
//! entries, Cursor hooks.json entries, or the Gemini bash hook script).
//! `rtk config` must print the selection.

use std::path::Path;
use std::process::{Command, Stdio};

/// Run rtk hermetically against a temp HOME: config, data, Claude, Cursor,
/// and Gemini dirs all resolve inside `home`. The agent dirs are pre-created
/// as they would be on a machine with the agents installed.
fn rtk_with_home(home: &Path, args: &[&str]) -> (String, Option<i32>) {
    for dir in [home.join(".claude"), home.join(".cursor")] {
        std::fs::create_dir_all(&dir).expect("create agent dir");
    }
    let out = Command::new(env!("CARGO_BIN_EXE_rtk"))
        .args(args)
        .env("HOME", home)
        .env("XDG_CONFIG_HOME", home.join(".config"))
        .env("XDG_DATA_HOME", home.join(".local/share"))
        .env("CLAUDE_CONFIG_DIR", home.join(".claude"))
        .stdin(Stdio::null())
        .stderr(Stdio::null())
        .output()
        .expect("spawn rtk");
    (
        String::from_utf8_lossy(&out.stdout).into_owned(),
        out.status.code(),
    )
}

/// Stage a config selecting nu_shell mode at every path rtk resolves as
/// its config dir (XDG on Linux, Application Support on macOS).
fn write_nu_shell_config(home: &Path) {
    let content = "[shell]\nmode = \"nu_shell\"\n";
    for dir in [
        home.join(".config/rtk"),
        home.join("Library/Application Support/rtk"),
    ] {
        std::fs::create_dir_all(&dir).expect("create config dir");
        std::fs::write(dir.join("config.toml"), content).expect("write config.toml");
    }
}

fn read_or_empty(path: &Path) -> String {
    std::fs::read_to_string(path).unwrap_or_default()
}

#[test]
fn config_prints_nu_shell_selection() {
    let home = tempfile::tempdir().expect("tempdir");
    write_nu_shell_config(home.path());

    let (out, code) = rtk_with_home(home.path(), &["config"]);
    assert_eq!(code, Some(0), "rtk config failed: {out}");
    assert!(
        out.contains("[shell]"),
        "rtk config must print the [shell] section: {out}"
    );
    assert!(
        out.contains("mode = \"nu_shell\""),
        "rtk config must print the documented nu_shell selection: {out}"
    );
}

#[test]
fn config_default_documents_legacy_shell_mode() {
    let home = tempfile::tempdir().expect("tempdir");

    let (out, code) = rtk_with_home(home.path(), &["config"]);
    assert_eq!(code, Some(0), "rtk config failed: {out}");
    assert!(
        out.contains("mode = \"legacy\""),
        "default config must document the shell mode field (legacy): {out}"
    );
}

#[test]
fn init_hook_only_does_not_emit_bash_rewrite_hook_in_nu_shell_mode() {
    let home = tempfile::tempdir().expect("tempdir");
    write_nu_shell_config(home.path());

    let (out, code) = rtk_with_home(home.path(), &["init", "-g", "--hook-only", "--auto-patch"]);
    assert_eq!(code, Some(0), "rtk init failed: {out}");
    assert!(
        out.contains("nu_shell"),
        "init must report the nu_shell selection: {out}"
    );

    let settings = read_or_empty(&home.path().join(".claude/settings.json"));
    assert!(
        !settings.contains("rtk hook claude"),
        "nu_shell mode must not emit the Claude PreToolUse rewrite hook: {settings}"
    );
    assert!(
        !settings.contains("rtk-rewrite.sh"),
        "nu_shell mode must not emit legacy rewrite hook scripts: {settings}"
    );
}

#[test]
fn init_default_mode_skips_settings_patch_but_keeps_rtk_md_in_nu_shell_mode() {
    let home = tempfile::tempdir().expect("tempdir");
    write_nu_shell_config(home.path());

    let (out, code) = rtk_with_home(home.path(), &["init", "-g", "--auto-patch"]);
    assert_eq!(code, Some(0), "rtk init failed: {out}");
    assert!(
        out.contains("nu_shell"),
        "init must report the nu_shell selection: {out}"
    );

    // Instruction files are not shell hooks: RTK.md must still be installed.
    assert!(
        home.path().join(".claude/RTK.md").exists(),
        "RTK.md must still be written in nu_shell mode"
    );

    let settings = read_or_empty(&home.path().join(".claude/settings.json"));
    assert!(
        !settings.contains("rtk hook claude"),
        "nu_shell mode must not emit the Claude PreToolUse rewrite hook: {settings}"
    );
}

#[test]
fn init_hook_only_still_patches_settings_in_legacy_mode() {
    // Control: without nu_shell selected, the legacy hook flow is unchanged.
    let home = tempfile::tempdir().expect("tempdir");

    let (out, code) = rtk_with_home(home.path(), &["init", "-g", "--hook-only", "--auto-patch"]);
    assert_eq!(code, Some(0), "rtk init failed: {out}");

    let settings = read_or_empty(&home.path().join(".claude/settings.json"));
    assert!(
        settings.contains("rtk hook claude"),
        "legacy mode must keep emitting the Claude hook: {settings}"
    );
}

#[test]
fn init_cursor_does_not_emit_hook_in_nu_shell_mode() {
    let home = tempfile::tempdir().expect("tempdir");
    write_nu_shell_config(home.path());

    let (out, code) = rtk_with_home(
        home.path(),
        &["init", "-g", "--agent", "cursor", "--auto-patch"],
    );
    assert_eq!(code, Some(0), "rtk init failed: {out}");

    let hooks_json = read_or_empty(&home.path().join(".cursor/hooks.json"));
    assert!(
        !hooks_json.contains("rtk hook cursor"),
        "nu_shell mode must not emit the Cursor rewrite hook: {hooks_json}"
    );
}

#[test]
fn init_gemini_does_not_emit_bash_hook_in_nu_shell_mode() {
    let home = tempfile::tempdir().expect("tempdir");
    write_nu_shell_config(home.path());

    let (out, code) = rtk_with_home(home.path(), &["init", "-g", "--gemini", "--auto-patch"]);
    assert_eq!(code, Some(0), "rtk init failed: {out}");
    assert!(
        out.contains("nu_shell"),
        "init must report the nu_shell selection: {out}"
    );
    assert!(
        !home
            .path()
            .join(".gemini/hooks/rtk-hook-gemini.sh")
            .exists(),
        "nu_shell mode must not emit the Gemini bash rewrite hook script"
    );
}
