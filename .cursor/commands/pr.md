# /pr — Create a pull request

When this command is invoked, do the following steps in order:

1. Run `git status` to see which files have been modified.
2. Run `git diff --stat HEAD` to summarise the changes.
3. Run `flutter analyze --no-pub` — if it reports errors, stop and tell the user to fix them first.
4. Run `flutter test --no-pub` — if any test fails, stop and tell the user to fix them first.
5. Run `git add -A` to stage all changes.
6. Write a commit message following this format:
   - First line: `<type>(<scope>): <short summary>` (max 72 chars)
   - Type: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`, `security`
   - Scope: the feature area (e.g. `slm`, `pet`, `check-in`, `data`, `widget`, `handoff`)
   - Example: `feat(pet): implement vitality calculator with graduated missed-day penalty`
   - Blank line, then a bullet list of what changed and why
7. Run `git commit -m "<message>"`.
8. Run `git push origin HEAD`.
9. Run `gh pr create --title "<commit summary>" --body "<bullet list>" --label "hackathon"`.
10. Return the PR URL to the user.

## Rules for this command
- Never commit if `flutter analyze` or `flutter test` fail.
- Never include secrets, API keys, model weights, or PHI in the commit body.
- If `gh` CLI is not installed, stop after the push and tell the user to open the PR manually.
- Always include the `hackathon` label.
- If drift or Riverpod generated files (`*.g.dart`, `*.freezed.dart`) are in the diff, confirm they were regenerated with `build_runner` and not manually edited.
