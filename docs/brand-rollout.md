# Brand Rollout Plan

## Scope

Target repositories in current wave:

- `my_portfolio`
- `persian_tools`

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

- `my_portfolio`:
  - `bun run lint`
  - `bun run type-check`
  - `bun run test`
  - `bun run build`
  - `bun run verify`
  - `bun run scan:external`
- `persian_tools`:
  - `pnpm run ci:quick`
  - `pnpm run deploy:readiness:validate`

## References

- `standards/branding/brand-attribution-v1.md`
- `platform/repo-templates/brand/v1/README.md`

