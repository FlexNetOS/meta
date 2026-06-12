# NEEDS-HUMAN — consolidated walls (refreshed 2026-06-12 late evening, upgrade mission)

> Per **ADR-0005 (needs-human steward)**: split into *owner decisions* (steward-escalated under the
> scope law — one approval each unlocks autonomous execution) and *genuine walls*. Each entry has the
> exact command(s). Original 7-item queue status at refresh time: **0/7 actioned**.

## Owner decisions (steward-escalated)

### A. P7 `.handoff` stub batches (classifier-blocked twice → scope law, NORTH-STAR.md)
The A/B fleet (21 FlexNetOS-owned repos) is seeded and merged/arming; all 20 forks are covered by
central capsules (`handoff/.handoff/fleet/`). Two remaining batches need your explicit scope grant:
```bash
# (a) 11 org-owned hubs — /tmp/p7drive.sh TARGETS is already set to the hub list:
bash /tmp/p7drive.sh
# (b) optional: third-party fork in-repo stubs (vision item 2 says every repo; central capsules
#     already provide coverage with zero fork divergence — your call). Regenerate payloads anytime:
python3 /tmp/p7gen.py   # then edit TARGETS in /tmp/p7drive.sh to the fork list
```
Saying "run the hub stub batch" (± "and forks") in any session is sufficient authorization.

### B. Cognitum Seed — replug into a **data-capable USB-C port** (everything else is ready)
Mass storage reads (full analysis: COGNITUM-SEED.md) but the USB-Ethernet gadget never enumerates.
The device's own guide: *"Use the USB data port (not power-only)."* After replug:
```bash
ip -4 addr | grep 169.254 && curl -sk https://169.254.42.1:8443/api/v1/status
sudo bash /run/media/drdave/COGNITUM/trust/install-trust.sh   # optional; name-constrained CA
# then MCP wiring: .claude/settings.json → cognitum-seed @ http://169.254.42.1/mcp (streamable-http)
```
Unlocks: 114-tool MCP, hardware witness anchoring of the fleet ledger, custody-signed packets.

### C. meta dependabot alerts (8 on main: 1 high, 5 moderate, 2 low)
https://github.com/FlexNetOS/meta/security/dependabot — renovate is live; the steward folds its PRs
through the normal loop, but review the high-severity one.

## Genuine walls (unchanged from the audit; commands remain valid)

1. **Delete auto-suffix fork artifacts** (irreversible deletion → human):
   `gh repo delete FlexNetOS/shimmy-1 --yes` · `gh repo delete FlexNetOS/teri-1 --yes`
2. **Org-secrets listing** (classifier-blocked for agents): confirm `PARENT_REPO_PAT` +
   `REPO_WRITE_PACKAGES_PAT` org-level: `gh api orgs/FlexNetOS/actions/secrets --jq '.secrets[] | {name, visibility}'`
   — also feeds `incidents/release-please-token-empty`.
3. **meta_dashboard_cli / meta-plugins visibility** (visibility = human-only by law):
   `gh repo edit FlexNetOS/meta_dashboard_cli --visibility public --accept-visibility-change-consequences`
4. **meta_plugin_api disposition** (archive preferred; becomes steward-ownable once the kernel verb
   batch + parent members-removal PR exist): `gh repo archive FlexNetOS/meta_plugin_api --yes`
5. **Unregistered org repos** (`harness`, `slim`, `global_projects_config`, `demo-repository`):
   register as Tier C in `.meta.yaml` or archive — disposition wanted.
6. **Optional rename** `env_manager_agent` → `kasetto`:
   `gh repo rename kasetto -R FlexNetOS/env_manager_agent --yes`
7. **atc workflow-approval gating** (`action_required` blocks autonomy on atc):
   Settings → Actions → General → approval policy.
8. **`.github` repo P7 stub** (if wanted): branch protection there requires 1 human review per PR;
   bot approval is forbidden by design, so it needs your click.

## Standing hardware/network walls (memoir)
- lane relay unfinished → cross-machine paths unreliable.
- envctl vault development gated by its **separate** USB secret-key device (distinct from the Seed).
- ~~Cognitum seed plugged but unreachable~~ → superseded by **owner decision B** (storage readable;
  only the data-port replug remains).
