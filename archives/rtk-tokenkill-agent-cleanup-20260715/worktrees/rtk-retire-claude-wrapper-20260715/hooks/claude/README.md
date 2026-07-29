# Claude Code Hooks

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Specifics

- `rtk init -g` registers the native `rtk hook claude` command under Claude's
  `PreToolUse` settings; it does not install a shell wrapper.
- The Rust handler reads the hook JSON from stdin and returns `updatedInput`
  JSON for a transparent command rewrite.
- The handler does not require `bash` or `jq`, including on native Windows.
- `rtk-awareness.md` is a slim 10-line instructions file embedded into
  `CLAUDE.md` by `rtk init`.

## Testing

```bash
# Test the native handler directly
printf '%s\n' '{"tool_name":"Bash","tool_input":{"command":"git status"}}' \
  | rtk hook claude

# Run its Rust regression tests
cargo test hooks::
```
