---
name: vitalpet-check-in-engine
description: >
  Use when building or modifying the check-in flow — mode selection, session orchestration,
  partial session handling, wellness slider, follow-up questions, body map, Companion Mode,
  or check-in completion. Also covers lib/features/check_in/ screens and widgets.
---

# VitalPet Check-In Engine

## The three modes
| Mode | Trigger | Questions | Max time |
|---|---|---|---|
| 1 — Quick Log | Wellness 7–10 | 0 follow-ups, optional free text | < 20 sec |
| 2 — Guided | Wellness 4–6 | 3–5 SLM-sequenced questions | < 45 sec |
| 3 — Companion | Wellness 1–3 | Conversational, SLM as pet voice | 2–5 min, no pressure |

Mode is determined **before** the SLM is called.

## Session lifecycle
```
1. User opens check-in (widget deep-link or notification)
2. HomeScreen shows WellnessSlider — score captured (this alone = valid Mode 1 check-in)
3. checkInSessionNotifier.submitWellnessScore(score) called
4. ModeSelector.selectMode(score) → mode stored in session state
5. If Mode 2/3: SLMClient.generateQuestions(context) called
   → On SLMTimeoutException: RuleBasedFallback.getQuestions(context)
6. Questions rendered; user answers each
7. User taps "Done" → checkInSessionNotifier.completeSession() called
8. db.transaction():
   a. CheckInDao.insertCheckIn(companion)
   b. PetDao.updateVitalityAndStreak(...)
   c. AuditLogDao.append(CHECKIN_WRITE)
9. BaselineTracker.checkAllMetrics() runs post-transaction
10. WidgetDataWriter.updateWidgetData() called
11. Pet reaction animation triggered via Rive input
```

## Riverpod state
```dart
// lib/features/check_in/domain/check_in_session_notifier.dart
@riverpod
class CheckInSession extends _$CheckInSession {
  @override
  CheckInSessionState build() => const CheckInSessionState.idle();

  Future<void> submitWellnessScore(int score) async { ... }
  Future<void> submitAnswer(QuestionAnswer answer) async { ... }
  Future<void> savePartial() async { ... }   // "Save and come back"
  Future<void> resumePartial() async { ... }
  Future<void> completeSession() async { ... }
  Future<void> amendSession(String checkinId) async { ... }
}
```

## Partial session handling
- Triggered by "Save and come back" button (explicit tap — not by backgrounding the app)
- Partial session persisted to DB with `isPartial = true`
- Valid until midnight — at midnight counts as 50% check-in (no streak break, no depth bonus)
- On resume: `QuestionSequencer` receives already-answered questions and continues from there
- `SessionStore` holds in-memory state between widget rebuilds via a Riverpod `StateNotifier`

## Anti-gaming: minimum valid check-in
A check-in counts toward streak if:
- The user engaged the wellness slider **and**
- Either tapped "Done" (Mode 1) **or** answered at least 1 follow-up question

Simply opening the app does not count. A Mode 1 submission with score 1–3 is flagged as `mood_gated` in `answersJson` — the SLM will offer a follow-up prompt at the next session.

## Body map (Mode 2/3)
```dart
// lib/presentation/widgets/body_map.dart
// Renders using flutter_svg — anterior/posterior SVG silhouette
// Tap regions are GestureDetector overlays with minimum 44×44 logical pixels
// Max 3 selected simultaneously — deselect oldest on 4th tap
// Regions: head, chest, abdomen, upper_limb_l, upper_limb_r, lower_limb_l, lower_limb_r, back
// Selected regions stored as List<String> in the current question's answer
```

## Companion Mode (Mode 3)
- SLM output styled as speech bubbles from the pet (`CompanionBubble` widget)
- No time pressure UI — no countdown, no urgency indicator
- "I'm done" `TextButton` always visible, regardless of how many questions answered
- Each generated bubble text: `MedicalContentFilter.filter(rawText).text`
- Transition phrases between questions ("That sounds really hard.") also filtered

## Vulnerability safeguard
After `completeSession()`, check in `PetDomain`:
```dart
if (pet.consecutiveBadDays >= 5 && !pet.vulnerabilityCardShown) {
  // 1. Set vulnerability_frozen = true in pet_state (vitality decay paused 7 days)
  // 2. Mark vulnerability_card_shown = true
  // 3. Surface VulnerabilityCard — which includes Calm Mode toggle ON the card
  // 4. Link to mental health resource
}
```

## Amendment flow
- User can amend until 23:59 same calendar day
- `CheckInDao.amendCheckIn()` updates `answersJson` and sets `amendedAt` timestamp
- `AuditLogDao.append(AuditEvent.amendment(...))` must be called
- Handoff shows final version with amendment timestamp

## Streak freeze
- 1 freeze per 7-day period — `pet_state.freezeAvailable = true`
- Must be activated before midnight — not retroactive
- Reason stored in `answersJson` of the freeze record for handoff context
- After activation: `freezeAvailable = false`, `freezeLastUsedDate = today`
- After 7 days: `freezeAvailable = true` again (checked on check-in open)
