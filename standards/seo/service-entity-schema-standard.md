# Service Entity Schema Standard

## Scope

For repositories with consulting/service pages.

## Mandatory Fields

- Service name
- Provider (Person/Organization)
- Service type
- Area served
- Offer/price metadata
- Canonical service URL

## Linking Rules

- Service schema must link back to canonical Person and Organization entities.
- Same entity naming must be used across metadata and JSON-LD.

## Validation

- Fail CI if required service schema fields are missing.
