# Retired Claude shell wrapper

This directory preserves the pre-v0.37.2 Claude `PreToolUse` shell wrapper for
historical inspection only. It is not built, installed, tested, or referenced
by the active runtime.

The supported Claude integration is the native binary command:

```text
rtk hook claude
```

`rtk init -g` registers that command in `~/.claude/settings.json` and removes
the old installed wrapper plus its hash sidecar. The cleanup code remains so
existing machines can migrate safely; this archive must never be copied into
`~/.claude/hooks/` or registered in `settings.json`.

The wrapper was retired on 2026-07-15. Its executable source previously lived
at `hooks/claude/rtk-rewrite.sh`.
