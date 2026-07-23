---
id: 019f5c95-48d1-7d91-8bb7-2e837c157251
slug: tasks/meta-envctl-fleet-agent-env-policy
title: "Converge envctl agent environment through Meta fleet policy"
type: task
status: active
priority: high
---

## Objective

Converge the parent Meta control plane and every declared `src/*` peer on one
reviewed agent-environment policy without turning the independent repositories
into a monorepo or introducing a second runtime/profile owner.

## Established evidence

- Meta root `.meta.yaml` declares the peer fleet; Meta's tracked policies and
  root GitKB are the coordination surface.
- `meta exec -- <command>` is the supported fan-out mechanism. Each child keeps
  an independent Git repository and its own local GitKB store.
- `meta git review` is only a pass-through today; the installed Git does not
  provide `git review`, so it is not a valid fleet review executor.
- Envctl's `agent sync` currently resolves one project config at a time. Of the
  declared `src/*` peers, only envctl currently owns `agent-env.yaml`.
- Yazelix remains the sole owner of the Nix profile and Nu/RTK runtime;
  agent-env may attest that contract but must not create another owner.

## Acceptance criteria

- [ ] Define a Meta-owned fleet policy/source of truth that selects parent Meta
  and every declared `src/*` peer while preserving independent repositories.
- [ ] Classify existing envctl skills for fleet applicability; do not copy
  envctl-specific skills into product peers.
- [ ] Add a preview-first, fail-closed fleet review/sync path that uses the
  Meta control plane and reports every peer's result.
- [ ] Give each selected peer an explicit, reviewable agent-env policy/config
  or an explicit exclusion with rationale.
- [ ] Run the fleet preview and apply sync only through the supported
  Meta/envctl frontdoors; record parent Meta and every `src/*` peer result.
- [ ] Update envctl runbook/CLI documentation so it does not imply single-repo
  sync is workspace-wide.
- [ ] Verify profile-owned RTK/Nu/Yazelix remains the sole active runtime
  frontdoor and record RTK adoption/utilization evidence.

## Related work

- [[tasks/meta-unified-agent-plugin-control-plane]]
- [[tasks/meta-kb-workflow-peer-component-smoke-test]]
- [[tasks/meta-peer-local-kb-bootstrap]]
- [[tasks/meta-github-sync-state-policy]]
