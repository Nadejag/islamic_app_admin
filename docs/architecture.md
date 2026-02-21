# Architecture

## Style
- Platform: Flutter Web.
- Architecture: Clean Architecture (presentation/domain/data per feature).
- State management: Provider with Riverpod.
- `core/` contains auth, routing, providers, theme, shared services.
- `features/` contains module-specific presentation/domain/data layers.
- `shared/` contains reusable widgets and cross-cutting UI components.

## Security Model
- Firebase Auth for identity.
- Role stored in `admins/{uid}.role` and optionally mirrored in custom claims.
- Sensitive operations routed through Cloud Functions only.
- Immutable audit writes to `admin_logs`.

## Role Matrix
- `super_admin`: full access, settings + destructive actions.
- `admin`: full operational access except restricted critical settings.
- `scholar`: limited to dashboard + ask-scholar workflow.
