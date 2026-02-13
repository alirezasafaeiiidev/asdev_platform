# Brand Rollout Plan

## Scope

Target repositories in current wave:

- `asdev-portfolio`
- `asdev-persiantoolbox`
- `asdev-creator-membership-ir`
- `asdev-automation-hub`

Runtime exception (tracked in governance):

- `asdev-nexa-vpn` is `external-dependent` and exempt from strict local-first runtime rules.
- It still must follow ASDEV core governance from `asdev-standards-platform`.

## Rollout Steps

1. Add brand files:
   - `src/lib/brand.ts`
   - `src/components/brand/BrandFooter.tsx`
   - `src/components/brand/BrandLink.tsx`
2. Update app layout/footer to include `BrandFooter`.
3. Add engineering request link in header/help navigation.
4. Add README section:
   - `## Brand Attribution`
   - engineering hub + request URLs.

## Validation Per Repository

- `asdev-portfolio`:
  - `bun run lint`
  - `bun run type-check`
  - `bun run test`
  - `bun run build`
  - `bun run verify`
  - `bun run scan:external`
- `asdev-persiantoolbox`:
  - `pnpm run ci:quick`
  - `pnpm run deploy:readiness:validate`
- `asdev-creator-membership-ir`:
  - `pnpm run lint`
  - `pnpm run typecheck`
  - `pnpm run test:unit`
- `asdev-automation-hub`:
  - `pnpm lint`
  - `pnpm test`

## References

- `standards/branding/brand-attribution-v1.md`
- `platform/repo-templates/brand/v1/README.md`
- `governance/policies/external-dependency-governance.md`
