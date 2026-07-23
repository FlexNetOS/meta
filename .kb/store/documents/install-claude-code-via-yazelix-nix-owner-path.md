---
id: 019f5f02-3ee9-77c1-b17c-27da55bdf9e0
slug: install-claude-code-via-yazelix-nix-owner-path
title: "Install Claude Code via Yazelix Nix owner path"
type: task
status: active
priority: high
tags: [claude-code, yazelix, nix, runtime-ownership]
---

# Overview

Install and expose Claude Code only through the profile-owned Yazelix/Nix runtime model. Eliminate user-local binary, launcher, configuration, or generated-runtime shadows that create a second authority path.

## Goals

- Define the Nix/Yazelix source input that owns Claude Code installation and active configuration.
- Prove the installed binary and runtime are materialized through the single active profile.
- Remove or archive stale user-local shadows after their valuable state is incorporated into the owner path.

## Acceptance Criteria

- [ ] A failing ownership test detects any Claude Code binary or active config outside the declared profile/input/runtime surfaces.
- [ ] The profile build installs the required Claude Code binary and active configuration.
- [ ] Runtime proof resolves Claude Code through the single Yazelix/Nix profile.
- [ ] No stale user-local binary, launcher, config, or generated-runtime shadow remains active.
- [ ] Verification evidence is recorded and the owning repository change is merged through a PR without cherry-picking.

## Context

- Parent enforcement task: [[tasks/enforce-kache-nushell-yazelix-single-owner]].
- Reviewed Claude source/configuration is shipped by the Yazelix Nix package; mutable process state is confined to `/home/flexnetos/.nix-profile/runtime/claude`; and every active Claude/Yazelix command resolves through `/home/flexnetos/.nix-profile`. No home-owned binary, config, state, cache, runtime, launcher, or compatibility path is permitted.
- Existing state must be preserved and integrated before removing shadows.
