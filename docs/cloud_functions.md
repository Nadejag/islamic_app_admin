# Cloud Functions (Examples)

Implemented callable functions in `firebase/functions/src/index.ts`:

1. `approveScholar`
- Validates admin role.
- Approves `scholar_requests/{id}`.
- Upserts `scholars/{userId}`.
- Assigns `admins/{userId}.role = scholar`.
- Writes immutable log to `admin_logs`.

2. `resolveReport`
- Validates admin role.
- Sets report resolution and status.
- Writes admin audit log.

3. `updateSystemSetting`
- Validates admin role.
- Updates `settings/app`.
- Writes admin audit log.

## Why callable functions
- Prevents direct client-side writes for sensitive operations.
- Centralized input validation and audit.
- Easier to enforce business policy and future workflows.
