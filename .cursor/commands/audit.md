# /audit — Run a security and HIPAA compliance audit

When this command is invoked, run the following checks in order and report results.

## 1. Network egress check
```bash
grep -rn "http\.get\|http\.post\|dio\.get\|dio\.post\|HttpClient()" lib/ --include="*.dart"
```
Flag any result outside of health-adapter calls to platform APIs.

## 2. Third-party package audit
```bash
bash scripts/audit_deps.sh
```
Flag any analytics, advertising, or crash-reporting packages.

## 3. Medical filter coverage
```bash
grep -rn "FlutterGemma\|getResponseAsync\|generateQuestions\|SLMClient" lib/ --include="*.dart"
```
For each call site, verify `MedicalContentFilter.filter()` is applied before displaying output.

## 4. HealthKit write permissions (iOS)
```bash
grep -rn "toShare:" native/ios/ --include="*.swift"
```
Flag any non-empty `toShare:` arrays.

## 5. Health Connect write permissions (Android)
```bash
grep -rn "getWritePermission" native/android/ --include="*.kt"
```
Flag any `getWritePermission` call.

## 6. Audit log completeness
```bash
grep -rn "insertCheckIn\|db\.transaction" lib/ --include="*.dart"
```
Verify each transaction includes an `auditLogDao.append()` or `appendInTransaction()` call.

## 7. Encryption coverage
```bash
grep -rn "DriftNativeDatabase\|NativeDatabase" lib/ --include="*.dart"
```
Flag any DB open call that does not go through `EncryptionService.getOrCreateKey()`.

## 8. Widget shared container PHI check
```bash
grep -rn "HomeWidget\.saveWidgetData\|SharedPreferences\|UserDefaults" lib/ native/ --include="*.dart" --include="*.swift" --include="*.kt"
```
Verify only allowed keys are written: `petVitality`, `currentStreak`, `petState`, `petName`, `petSpecies`, `wellnessSparkline`.

## 9. Screen blur registration
Verify `WidgetsBindingObserver` is registered in `main.dart` and the blur overlay is applied on `AppLifecycleState.inactive/paused`.

## 10. Static analysis
```bash
flutter analyze --no-pub
```
Report all errors and warnings.

## Report format
- **PASS** — check confirmed clean
- **WARN** — potential issue needing human review
- **FAIL** — confirmed violation must be fixed before release

End with: X checks passed, Y warnings, Z failures.
