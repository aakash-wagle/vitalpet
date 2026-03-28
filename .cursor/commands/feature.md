# /feature — Scaffold a new feature end-to-end

When this command is invoked with a feature name (e.g. `/feature voice-check-in`):

1. Read `REPO_STRUCTURE.md` and `DEVELOPMENT_PLAN.md` to understand where the feature fits.
2. Identify which layers and files will change:
   - Which drift DAO or table in `lib/core/database/` or `lib/features/<feature>/data/`?
   - Which domain functions in `lib/features/<feature>/domain/`?
   - Which Riverpod notifiers/providers?
   - Which screens/widgets in `lib/features/<feature>/presentation/`?
   - Which native widget files (if widget data changes)?
   - Which `config/` files need updating?
3. Write a plan to `.cursor/plans/<feature-name>.md`:
   - FR references from the SRS being implemented
   - Files to create or modify, in implementation order
   - Security/HIPAA constraints that apply
   - Drift migration needed? (yes/no and column names)
4. **Wait for user approval of the plan before writing any code.**
5. After approval, implement in this order:
   a. Drift migration (if any) in `lib/core/database/migrations/`
   b. Drift table and DAO in `lib/features/<feature>/data/`
   c. Run: `dart run build_runner build --delete-conflicting-outputs`
   d. Pure domain logic in `lib/features/<feature>/domain/`
   e. Unit tests in `test/features/<feature>/`
   f. Riverpod providers and notifiers
   g. Presentation layer (screen + widgets)
   h. Widget data update (if widget display changes)
6. After implementation:
   - Run `flutter analyze --no-pub`
   - Run `flutter test test/features/<feature>/`
   - Report results to user

## Constraints
- Never skip the plan step — code before plan = waste
- Business logic in `domain/` — never in screens or widgets
- Every SLM output shown to the user goes through `MedicalContentFilter.filter()`
- Every check-in write inside `db.transaction()`
- Every significant data event in `AuditLogDao.append()`
