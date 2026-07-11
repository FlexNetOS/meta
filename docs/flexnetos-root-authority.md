# FlexNetOS Meta Root Authority

## Canonical topology

```text
/home/flexnetos/meta/             FlexNetOS/meta checkout and control plane
|-- .git/                         Meta Git identity
|-- .kb/                          Meta GitKB identity and knowledge base
|-- .meta.yaml                    Peer-repository ownership manifest
`-- src/                          Independent peer repositories
    `-- lifeos/                   FlexNetOS/lifeos Meta peer
```

`/home/flexnetos/FlexNetOS` may remain as a compatibility symlink to
`/home/flexnetos/meta`. `/home/flexnetos/lifeos` is retired and must remain
absent so it cannot compete with Meta for workspace identity or authority.

## Promotion

On 2026-07-10, the former unversioned `/home/flexnetos/lifeos` parent was
atomically renamed to `/home/flexnetos/meta`. The existing Meta checkout was
then promoted from its staged `src/meta` location into that root. Root
collisions and pre-change repository state were archived before mutation under
`/home/flexnetos/.local/state/meta/archives/`.

The promotion preserves independent repository histories. The large LifeOS,
peer, runtime, release, and evidence trees are not committed into
`FlexNetOS/meta`; `.gitignore` protects that boundary and `.meta.yaml` declares
the repositories Meta operates.

## LifeOS peer correction

The first promotion pass incorrectly left LifeOS at the root-level path
`/home/flexnetos/meta/lifeos`. Review established that LifeOS is a Meta peer,
not a privileged child outside the peer namespace. The canonical path is
`/home/flexnetos/meta/src/lifeos`, alongside the other independent repositories
declared by `.meta.yaml`.

## Identity test

Meta is identified from its source by the conjunction of:

1. the root `FlexNetOS/meta` Git remote and history;
2. the root `.meta.yaml` project manifest;
3. the root `.kb` GitKB database and configuration; and
4. tracked Meta policy and product source.

Any parent directory that supplies competing `.git`, `.kb`, `.meta*`, or
workspace policy is an authority conflict, not an additional valid Meta layer.
