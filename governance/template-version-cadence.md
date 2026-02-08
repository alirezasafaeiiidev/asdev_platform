# Template Version Cadence

## Policy

- Default cadence: monthly baseline review.
- Exception cadence: immediate release for policy-critical fixes.

## Versioning Rules

- Patch (`x.y.Z`): typo/doc-only or non-functional template edits.
- Minor (`x.Y.z`): backward-compatible standard additions or safer sync defaults.
- Major (`X.y.z`): breaking changes or enforcement model changes.

## Operational Rules

- Every template version bump must reference its source standard and governing ADR.
- Sync rollout should start with pilot repos before broad adoption.
- Divergence report must be generated after each live rollout.
