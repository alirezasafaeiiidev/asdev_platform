# Technical SEO Standard (ASDEV)

## Canonical

- Production canonical base URL must be env-driven.
- Placeholder domains are forbidden in production code paths.

## Sitemap

- Only indexable URLs are allowed.
- Hash fragment URLs (`#...`) are forbidden in sitemap entries.

## Robots

- Must provide sitemap location.
- Sensitive routes (`/api`, `/admin`, auth/private) must be disallowed.

## Structured Data

Required schema baseline:

- `Person`
- `Organization`
- `WebSite`
- `Service` (for commercial consulting pages)

## CI Contracts

- Canonical host validation
- Sitemap indexability validation
- Required schema presence validation
