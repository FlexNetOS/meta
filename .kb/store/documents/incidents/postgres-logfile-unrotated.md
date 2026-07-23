---
id: 019f8a42-4e09-70c3-81d2-ca6cbdffa954
slug: incidents/postgres-logfile-unrotated
title: "Canonical cluster logfile is 1.79 GB and unrotated"
type: incident
status: active
priority: low
tags: [postgres, ruvector, durable-tier, ops-hygiene, lifeos]
---

## What happened

Found 2026-07-22 during the ARCHBP-133 crash drill: the canonical
PostgreSQL 17.10 + RuVector cluster's log at
`/home/flexnetos/meta/var/lib/postgresql/17/logfile` is **1,789,134,647 bytes
(1.79 GB)** in a single unrotated file. The cluster is started with
`pg_ctl -l $PGDATA/logfile` (append) and no `logging_collector`/rotation is
configured, so it grows without bound on the durable tier.

Surfaced concretely: a naive `readFileSync` of the log exceeded Node's string
limit (`Cannot create a string longer than 0x1fffffe8`) in the ARCHBP-133 gate.
Code fix already shipped there (offset/tail reads, never wholesale); this
incident tracks the operational root cause.

## Fix path (acceptance)

- [ ] Enable `logging_collector = on` with `log_directory`, size/age-based
      rotation (`log_rotation_size`, `log_rotation_age`,
      `log_truncate_on_rotation`) through the sanctioned config path (envctl
      committer / ALTER SYSTEM at an owner-approved maintenance moment — no
      hand-edit of live config).
- [ ] Archive or truncate the existing 1.79 GB file after the recovery-line
      evidence referenced by `proof_records/ARCHBP-133.proof.json` is
      preserved (the durable crash-drill receipt already quotes the lines).
- [ ] Update `productionServices()` in `scripts/boot-reattach.mjs` to stop
      passing `-l logfile` once the collector owns logging.

## Evidence

- `stat -c %s .../postgresql/17/logfile` → 1789134647 (2026-07-22).
- Related: lifeos `scripts/dirty-shutdown-recovery.mjs` (tail-read fix),
  spine ARCHBP-133.
