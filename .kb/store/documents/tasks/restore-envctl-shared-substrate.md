---
id: 019f8118-c235-7b91-aa89-ce4640bc3ef5
slug: tasks/restore-envctl-shared-substrate
title: "Restore envctl shared substrate for active frontdoor"
type: task
status: active
priority: high
parent: tasks/architecture-data-pipeline-blueprint
---

envctl cannot build or execute its safe doctor command because its Cargo workspace references sibling path dependency /home/flexnetos/meta/src/loop_lib, which is absent from the Meta workspace. Restore the exact first-party loop_lib source through the workspace registry/owner path, then build and install the envctl-cli META_ROOT frontdoor, activate the Meta session PATH projection, and verify envctl doctor, database roots, and PostgreSQL/RuVector lifecycle commands.