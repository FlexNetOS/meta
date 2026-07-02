<!-- Source: https://gitkb.com/docs/getting-started/installation/ -->
<!-- Snapshot: 2026-07-02 -->

# Installation

## Install the GitKB CLI

GitKB is distributed as a single binary. Install it with your preferred method:

### Homebrew (macOS)

```
brew install gitkb/tap/gitkb
```

### Install script (macOS / Linux)

```
curl -fsSL https://get.gitkb.com/install.sh | bash
```

### Verify installation

```
git-kb --version
```

## Initialize a knowledge base

Navigate to your project root and initialize:

```
cd your-project
git-kb init
```

This creates a ` .kb/`  directory in your project root with the GitKB database and configuration.

## What’s in ` .kb/` ?

```
.kb/
├── config.toml      # KB configuration
├── gitkb.db         # SQLite database (document metadata, search index)
├── workspace/       # Ephemeral editing surface for checked-out documents
└── cache/           # Daemon socket, runtime files
```

The SQLite database caches document metadata and powers full-text search. Document content lives as Markdown files managed by GitKB’s own commit and sync protocol.

## Optional: colorized Markdown output

GitKB can pipe ` git-kb show`  output through glow  for syntax-highlighted, styled Markdown in your terminal.

Install glow via Homebrew or see glow’s install docs  for other methods:

```
brew install glow
```

Then add to ` .kb/config.toml` :

```
[pager]
markdown = "glow -p -w 0"
```

See Configuration  for details.

## Start using code intelligence immediately

Code intelligence works on any Git repo right after installation — no ` git-kb init`  required:

```
cd your-project
git-kb code index
git-kb code callers your-function
```

See Code Intelligence  for the full command reference, or continue to the Quick Start  for the full setup.

## Next steps

- Quick Start  — Set up the full knowledge engineering platform

- Code Intelligence  — Start with code intelligence alone
