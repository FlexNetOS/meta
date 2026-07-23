---
id: 019f21b2-5e21-7580-84ef-5a4075182ca6
slug: tasks/meta-extract-gitkb-docs-pages
title: "Extract gitkb.com docs pages into docs"
type: task
status: completed
priority: high
---

# Summary
Extracted the 19 documentation pages from gitkb.com/docs into the local docs/ tree for review and alignment.

# Completion Evidence
- Discovered the 19 docs pages from the live `https://gitkb.com/docs/` navigation.
- Corrected route mapping to use the rendered docs URLs: `core-concepts/*`, `guides/migration/`, and `cli-reference/` where applicable.
- Generated rendered Markdown snapshots under `docs/gitkb/` with source URL and snapshot-date comments.
- Added `docs/gitkb/README.md` as the local index.
- Verified 20 files exist under `docs/gitkb/`: 19 page snapshots plus README.
- Verified extraction does not overwrite unrelated existing docs.
- Verified no generated file contains the homepage/footer chrome markers checked: `Never lose`, `Book a Demo`, `Read the Docs`, `Join Discord`, `Star on GitHub`, `Share on X`, `Copy page`, `Features Pricing`, or `Powered by`.

# Acceptance Criteria
- [x] Discover the 19 gitkb.com/docs pages from the live site.
- [x] Save each page into docs/ with stable filenames and source attribution.
- [x] Avoid overwriting unrelated existing docs without an explicit mapping.
- [x] Verify all 19 pages are present locally.
- [x] Record any missing or inaccessible pages as gaps.
