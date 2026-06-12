# COGNITUM-SEED.md — the hardware root of trust (W1 analysis, 2026-06-12)

**Method:** full read of the mounted seed (`/run/media/drdave/COGNITUM`): README.txt, STATUS.txt,
guide.html (167KB → 56KB text, all 100+ sections), open.html, launch scripts (read, NOT executed —
verified benign: they only open guide.html), trust/ installers (read, not run). Live-API probe attempted.

## What it is

**Not a key-stick.** The Cognitum Seed is a **hardware root-of-trust device for AI** — "identity,
memory, and provenance in a device that fits in your pocket" — by **rUv and Roger**
(source: github.com/ruvnet/optimizer → the same ruvnet lineage as RuVector; this is the cognitum
coherence-gate concept in silicon). The USB *drive* we can read is only a read-only window; the
canonical device is a computer (ARMv7 rev4, 474MB RAM, 14GB storage, kernel 6.12 rpt-rpi — Pi-class)
exposing itself over **USB Ethernet**.

| Identity | Value |
|---|---|
| Device ID | `0e34a5e5-a7b6-4c68-ad04-e437e22f326a` |
| Hostname | `cognitum-578b.local` |
| Provisioned | 2026-05-01 06:38:23 UTC |
| TLS fingerprint (pin) | `FF:B6:CF:0F:B7:81:A8:A9:6B:1A:71:A0:48:EF:3E:11:44:A8:C0:83:14:F5:EE:48:93:28:94:55:BF:E3:E1:67` |
| Endpoints | `https://169.254.42.1:8443` (TLS) · `http://169.254.42.1` (USB-only) · `ssh genesis@169.254.42.1` |

## Capability map (from the guide — all sections read)

- **RVF binary vector store** + k-NN graph + epochs (the RVF lineage, on-device), import/export,
  dimension management, compaction.
- **Witness chain**: every write (ingest/delete/compact/manual) appends a SHA-256-linked
  tamper-evident entry; `POST /api/v1/witness/verify` checks integrity. **Manual witness entries
  accept custom event strings** ← integration hook.
- **Custody (Ed25519)**: device-unique keypair, private key never leaves; `custody/sign`,
  `custody/verify`, and `custody/attestation` (signed proof of boot identity incl. epoch, vector
  count, **witness head**).
- **MCP proxy (ADR-047)**: 114 tools / 21 groups / 3 scopes (minimal 18, default 24, full 114),
  JSON-RPC 2.0 streamable-HTTP, **policy engine + witness binding** (tool calls get witnessed),
  resources + prompts, batch requests.
- **Sensors (ADR-041)** with embedding + drift detection; **thermal governor (ADR-043)**;
  **temporal coherence (ADR-042)** with phase boundaries (the Φ lineage); **cognitive container**
  with **dual witness chains**; silicon characterization; reflex rules.
- **Sync & swarm**: delta pull/push since epoch (ADR-040), peer list, swarm status, cluster health —
  multi-seed replication is built in.
- **Security**: OTA signed firmware, boot attestation, mTLS auto-enable, bearer-token auth over WiFi
  (ADR-048), USB implicitly trusted (ADR-057).

## Live state (probed 2026-06-12)

- **Mass storage: READABLE** (this analysis) — the prior NEEDS-HUMAN wall "seed plugged but
  unreachable" is half-cleared.
- **USB Ethernet: NOT enumerating** — no `169.254.x` interface on the host; `curl
  https://169.254.42.1:8443/api/v1/status` times out. The guide's own troubleshooting names the fix:
  **"Use the USB data port (not power-only)"**; diagnostic on-device:
  `cat /sys/kernel/config/usb_gadget/cognitum/UDC` should show `3f980000.usb`.
  → NEEDS-HUMAN action: replug the Seed into a data-capable USB-C port/cable. Everything below
  unlocks the moment that interface appears.

## Advanced setup (the item-15 deliverable)

1. **Trust install (one-time, optional):** `trust/install-trust.sh` adds the Cognitum CA to the
   system store — verified benign and well-scoped (the CA is **name-constrained to 169.254.x.x +
   `.local`** only). Linux path: copies `cognitum-ca.pem` → `update-ca-certificates`. Run when the
   device is reachable; not before (pointless).
2. **Claude Code MCP wiring** (`.claude/settings.json`):
   ```json
   { "mcpServers": { "cognitum-seed": {
       "url": "http://169.254.42.1/mcp", "transport": "streamable-http" } } }
   ```
   No auth needed for Observe+Memory groups over USB (ADR-057); default scope 24 tools; `full`
   scope (114) via pairing (ADR-048).
3. **WiFi (optional, for updates/remote):** guide flow or
   `ssh genesis@169.254.42.1; sudo nmcli device wifi connect …` — bearer-token auth then applies.

## Integration targets (feed the loop — in adoption order)

1. **Hardware-anchored fleet ledger** (highest value, small surface): periodically write the handoff
   fleet ledger's witness-chain head as a **manual witness entry** on the Seed
   (`POST /api/v1/witness` custom event) and fetch `custody/attestation` back into the ledger as a
   checkpoint — two REST calls; gives the software chain a tamper-evident hardware anchor.
   Candidate verb: `hf anchor` (design via kb task before building, per ADR-0003).
2. **Custody-signed resume packets**: `hf handoff` optionally signs `packets/latest.md` digest via
   `custody/sign` — provenance for cross-session handoffs.
3. **envctl ↔ Seed**: envctl's vault (`crates/secrets-engine`: `inject.rs`, `ca.rs`, `vault/{crypto,
   store,aad}.rs`, relay tests; `secretd` phases 1–5 sanctioned) gains the Seed as a key source —
   the "USB secret-key vault" role envctl already expects, now with a real device API behind it.
   The separate envctl USB secret-key stick (standing wall) remains distinct hardware per memoir.
4. **Vector memory offload** (later): icm/RVF ledger v2 (HFTASK-0006) could target the Seed's RVF
   store — semantic recall with hardware provenance. Schedule after 1–3 prove out.

## Walls (exact)

- USB-Ethernet gadget not enumerating → **human: replug to data port** (then re-probe
  `ip -4 addr | grep 169.254`; `curl -sk https://169.254.42.1:8443/api/v1/status`).
- envctl's *other* USB secret-key device — separate standing wall, unchanged.

## Research / Cross-References

`/run/media/drdave/COGNITUM/{README.txt,STATUS.txt,guide.html,open.html,launch.*,trust/*}` (read in
full 2026-06-12; text extract at /tmp/cognitum-guide.txt); live probes (`ip addr`, curl timeout);
github.com/ruvnet/optimizer; device ADRs cited by the guide: 040 (delta sync), 041 (sensors),
042 (temporal coherence), 043 (thermal), 047 (MCP proxy + witness binding), 048 (pairing/auth),
057 (USB trust), 058 (114 MCP tools); envctl `crates/secrets-engine/src/{inject.rs,ca.rs}`
(surface verified by direct read); memoir: architecture-truth-census-2026-06-12 (W1),
hardware-network-walls; RUVECTOR-RUNBOOK.md (cognitum gate lineage); HFTASK-0017 (cognitum-gate
adoption), HFTASK-0006 (RVF ledger v2).
