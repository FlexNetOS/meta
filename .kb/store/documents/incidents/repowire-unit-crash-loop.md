---
id: 019ebda8-e63b-78c0-aae7-740a4bbdc58e
slug: incidents/repowire-unit-crash-loop
title: "repowire.service crash-loops: binary absent, 268MB daemon.log"
type: incident
status: investigating
priority: medium
tags: [systemd, repowire, portability]
---

## Symptoms

`repowire.service` (user unit, enabled) is stuck `activating` — `ExecStart=/home/drdave/.local/bin/repowire serve`
but **no `repowire` binary exists in `~/.local/bin`** (portability sweep 2026-06-12,
`/tmp/portability-sweep.out` §2/§7). `Restart=always` + `RestartSec=5` → permanent flap;
`~/.repowire/daemon.log` has grown to **268.7MB**.

## Context

- The unit (dated Jun 2) and `~/.repowire/{config.yaml,spawn_ownership.json}` exist; the binary was
  removed or never reinstalled after some cleanup.
- repowire is still referenced as a hand-configured MCP server (envctl `.mcp.json`, kasetto.yaml
  safety note: "broker, repowire, weave"), so *something* is expected to provide it.

## Mitigation (applied 2026-06-12, portability mission)

Unit disabled to stop the flap — fully reversible:

```bash
systemctl --user disable --now repowire.service
# rollback: systemctl --user enable --now repowire.service
```

The unit file itself is now meta-owned (`envctl/home/.config/systemd/user/repowire.service`, linked
from `~/.config/systemd/user/`, carrying this incident header). `daemon.log` (268MB) is left in
place — deletion is the owner's call.

## Open questions (owner)

1. Where does repowire's source live, and should it be a meta member + envctl component?
2. Is the MCP-server reference still wanted (claude `.mcp.json` / broker config), or is repowire retired?
3. OK to truncate/delete the 268MB `~/.repowire/daemon.log`?

## Resolution

Move to `resolved` once repowire is either restored as a meta-built component (binary + unit wired by
envctl) or formally retired (unit + MCP references removed).
