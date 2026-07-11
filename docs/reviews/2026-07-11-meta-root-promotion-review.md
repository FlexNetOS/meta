# Meta root promotion review

## Decision

The root promotion was directionally correct but its first LifeOS placement was
not. LifeOS is a Meta peer and must use the same peer namespace as the rest of
the fleet.

```text
/home/flexnetos/meta/
|-- .git
|-- .kb
|-- .meta.yaml
`-- src/
    |-- lifeos/
    `-- <other peers>/
```

## Findings corrected

1. **Critical - wrong LifeOS topology.** The first pass registered `lifeos` at
   `path: lifeos`. It is now registered at `path: src/lifeos` and was moved
   atomically without changing its Git identity.
2. **High - false policy language.** Meta policy described LifeOS as a special
   root-level product child. It now identifies LifeOS as a normal Meta peer.
3. **High - stale consumer paths.** Host Codex trust and GTK navigation pointed
   to the wrong root-level location. Their owner inputs now use `src/lifeos`.
4. **High - stale generated proof.** The Planning Spine marked the wrong
   topology complete. Superseding source rows and proof revisions correct the
   canonical graph without deleting historical evidence.
5. **Medium - GitNexus launch path.** The host launcher still referenced the
   retired pre-Meta root. Its owning installer and generated frontdoor require
   the canonical Meta runtime path.

## Non-findings

- The Meta checkout promotion itself remains valid.
- The root `.git`, `.kb`, and `.meta.yaml` remain the sole Meta identity.
- Peer repositories remain independent Git histories; moving LifeOS into
  `src/` does not turn Meta into a monorepo.
- `/home/flexnetos/FlexNetOS` remains only a compatibility link to the Meta
  root.
