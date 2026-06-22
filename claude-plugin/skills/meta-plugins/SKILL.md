---
name: meta-plugins
description: How the rtk meta plugin system intercepts and enhances commands.
---

# Meta Plugins Skill

Meta uses a plugin system to intercept commands and provide enhanced behavior.

## How Plugins Work

When you run `rtk meta <command>`, meta checks if a plugin handles that command pattern:

1. **Plugin matches** → Plugin executes with special logic
2. **No plugin** → Shows help (use `rtk meta exec -- rtk <command>` for arbitrary commands)

Example:
- `rtk meta git status` → git plugin runs `rtk git status` in all repos
- `rtk meta git clone <url>` → git plugin clones parent + all children from `.meta`
- `rtk meta npm install` → unrecognized, shows help; use `rtk meta exec -- rtk npm install`

## Built-in Plugins

### Git Plugin (`meta-git`)

Handles all `rtk meta git *` commands with special cases:

| Command | Behavior |
|---------|----------|
| `rtk meta git clone <url>` | Clone parent, read `.meta`, clone all children |
| `rtk meta git update` | Clone missing repos, pull existing ones |
| `rtk meta git snapshot *` | Create/restore workspace state |
| `rtk meta git setup-ssh` | Configure SSH multiplexing |
| `rtk meta git <other>` | Pass through to all repos |

### Project Plugin (`meta-project`)

Workspace management:

```bash
rtk meta project list      # List projects from .meta
rtk meta project check     # Verify all repos exist
rtk meta project sync      # Clone missing repos
```

### Rust Plugin (`meta-rust`)

Cargo workspace awareness:

```bash
rtk meta rust build        # Build with workspace detection
rtk meta rust test         # Test with proper ordering
```

## Plugin Discovery

Plugins are discovered from:
1. `.meta-plugins/` in current directory
2. `~/.meta-plugins/` in home directory
3. Executables named `meta-*` in PATH

## Plugin Management

```bash
# List installed plugins
rtk meta plugin list

# Search registry for plugins
rtk meta plugin search <query>

# Install from registry
rtk meta plugin install <name>

# Uninstall
rtk meta plugin uninstall <name>
```

## Understanding Command Flow

```
rtk meta git status
  │
  ├─ Is there a 'git' plugin? Yes (meta-git)
  │
  ├─ Plugin receives: command="git status", projects=[list]
  │
  ├─ Plugin returns: ExecutionPlan with commands per repo
  │
  └─ Meta executes plan via loop engine
```

For commands with special handling (like `clone`), the plugin does the work directly instead of returning an execution plan.

## Why This Matters

Plugins let you:
- **Extend meta** with domain-specific behavior
- **Intercept patterns** like `rtk git clone` to add meta-aware logic
- **Provide help text** via `rtk meta <plugin> --help`

When you see a command behave "magically" (like `rtk meta git clone` cloning multiple repos), a plugin is handling it.
