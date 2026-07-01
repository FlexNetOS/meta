---
id: 019f1f24-04e0-7a03-a607-75b85ea553ac
slug: context/extensible/product
title: "Product Context"
type: context
status: draft
priority: medium
---

# Product Context

## Problem

Engineering work often spans many repositories, but common solutions either
force everything into a monorepo or make cross-repo operations fragile. `meta`
keeps repositories independent while giving users and agents one operational
surface for cloning, status, updates, filtering, snapshots, builds, and scripted
execution.

## Primary Users

- Engineers working across many related repositories.
- Release and platform maintainers who need repeatable multi-repo operations.
- AI agents that need structured, machine-readable workspace state and safe
  batch execution.

## Product Principles

- Preserve Git repository independence.
- Make common multi-repo tasks feel like single-workspace tasks.
- Keep configuration minimal and inspectable.
- Prefer machine-readable output for automation and agents.
- Provide safety mechanisms such as snapshots before risky batch operations.

## Distribution Notes

Existing `.context` files still reference older `harmony-labs` and `gitkb`
distribution surfaces. In this FlexNetOS workspace, the active local source
checkout is `/home/flexnetos/FlexNetOS/src/meta` with remote
`https://github.com/FlexNetOS/meta.git`. Treat older org names as migration
evidence until they are intentionally reconciled.

The upstream `gitkb/meta` release is useful bootstrap evidence, but FlexNetOS
will break from it after the proper source build. A FlexNetOS release must ship
the Rust plugin command surface: `meta-rust` must be present and `meta rust
--help` must work from the installed release.
