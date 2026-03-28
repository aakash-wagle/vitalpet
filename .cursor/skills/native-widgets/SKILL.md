---
name: vitalpet-native-widgets
description: >
  Use when working on the iOS WidgetKit widget (native/ios/VitalPetWidget/) or the Android
  Glance widget (native/android/widget/). Also use when debugging the Flutter-to-widget data
  sharing via the home_widget package or App Group / SharedPreferences shared containers.
  This is the ONLY native code in the project — everything else is pure Flutter/Dart.
---

# VitalPet Native Widgets

## Why this code exists
Flutter cannot build home screen widgets. Period. iOS requires Swift + WidgetKit; Android requires Kotlin + Glance. These two directories are the only Swift and Kotlin in the project. All other "native" concerns (SLM inference, PDF, health, database) are handled by Flutter packages in Dart.

## Data flow: Flutter → Widget

Flutter writes data using the `home_widget` package, which handles App Group (iOS) and SharedPreferences (Android) under a single Dart API:

```dart
// lib/features/pet/domain/widget_data_writer.dart
import 'package:home_widget/home_widget.dart';

Future<void> updateWidgetData(PetState pet, List<int> sparkline) async {
  await HomeWidget.saveWidgetData('petVitality', pet.vitality);
  await HomeWidget.saveWidgetData('currentStreak', pet.streak);
  await HomeWidget.saveWidgetData('petState', pet.stateIndex);
  await HomeWidget.saveWidgetData('petName', pet.name);
  await HomeWidget.saveWidgetData('petSpecies', pet.species);
  await HomeWidget.saveWidgetData('wellnessSparkline', jsonEncode(sparkline));
  // Trigger widget refresh on both platforms:
  await HomeWidget.updateWidget(
    iOSName: 'VitalPetWidgetExtension',
    androidName: 'VitalPetWidget',
  );
}
```

Call `updateWidgetData()` after:
1. Every check-in completion (in `CheckInEngine.completeSession()`)
2. Midnight UTC (in `NotificationScheduler`)
3. Pet death and new pet creation

## Shared data keys (must match between Dart and native)
| Key | Type | Description |
|---|---|---|
| `petVitality` | Int | 0–100 |
| `currentStreak` | Int | consecutive check-in days |
| `petState` | Int | 1=thriving, 2=happy, 3=neutral, 4=unwell, 5=critical |
| `petName` | String | user-chosen name |
| `petSpecies` | String | "cat" / "dog" / "rabbit" / "dragon" |
| `wellnessSparkline` | String | JSON-encoded `[Int]` — 7 daily scores, oldest first |

**Never write wellness scores, symptom names, check-in answers, or PHI to the shared container.**

## iOS — VitalPetWidget.swift
```swift
// native/ios/VitalPetWidget/VitalPetWidget.swift
import WidgetKit
import SwiftUI

@main
struct VitalPetWidgetBundle: WidgetBundle {
  var body: some Widget {
    VitalPetWidget()
  }
}

struct VitalPetWidget: Widget {
  let kind = "VitalPetWidget"
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: VitalPetProvider()) { entry in
      VitalPetEntryView(entry: entry)
    }
    .configurationDisplayName("VitalPet")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
```

```swift
// native/ios/VitalPetWidget/WidgetDataProvider.swift
// Reads from App Group — set in Xcode entitlements for BOTH targets
struct VitalPetProvider: TimelineProvider {
  private let defaults = UserDefaults(suiteName: "group.com.vitalpet.shared")!

  func getSnapshot(in context: Context, completion: @escaping (VitalPetEntry) -> Void) {
    completion(makeEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<VitalPetEntry>) -> Void) {
    let midnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
    completion(Timeline(entries: [makeEntry()], policy: .after(midnight)))
  }

  private func makeEntry() -> VitalPetEntry {
    VitalPetEntry(
      date: .now,
      vitality: defaults.integer(forKey: "petVitality"),
      streak: defaults.integer(forKey: "currentStreak"),
      stateIndex: defaults.integer(forKey: "petState"),
      name: defaults.string(forKey: "petName") ?? "your pet",
      species: defaults.string(forKey: "petSpecies") ?? "cat",
      sparkline: parseSparkline(defaults.string(forKey: "wellnessSparkline"))
    )
  }
}
```

## Android — VitalPetWidget.kt
```kotlin
// native/android/widget/VitalPetWidget.kt
class VitalPetWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val data = WidgetDataProvider(context).getEntry()
        provideContent { PetWidgetContent(data) }
    }
}

class VitalPetWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = VitalPetWidget()
}
```

```kotlin
// native/android/widget/WidgetDataProvider.kt
class WidgetDataProvider(private val context: Context) {
    private val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
    // home_widget package uses "FlutterSharedPreferences" as the shared pref file name

    fun getEntry() = WidgetEntry(
        vitality = prefs.getLong("flutter.petVitality", 60).toInt(),
        streak = prefs.getLong("flutter.currentStreak", 0).toInt(),
        stateIndex = prefs.getLong("flutter.petState", 1).toInt(),
        name = prefs.getString("flutter.petName", "your pet") ?: "your pet",
        species = prefs.getString("flutter.petSpecies", "cat") ?: "cat",
        sparkline = parseSparkline(prefs.getString("flutter.wellnessSparkline", "[]"))
    )
    // Note: home_widget prefixes keys with "flutter." in SharedPreferences
}
```

## Pet images in widgets
Widgets cannot use Rive. Use static PNG sprites exported from Rive for each state × species:
```
assets/widget_sprites/
├── cat_1.png   # thriving
├── cat_2.png   # happy
├── cat_3.png   # neutral
├── cat_4.png   # unwell
├── cat_5.png   # critical
├── dog_1.png … dog_5.png
└── ...
```
Copy these to the widget extension's asset catalog (iOS) or `res/drawable/` (Android).

## WellnessSparkline
A 7-bar horizontal mini chart. On iOS, use SwiftUI `Path`. On Android, use a Glance `Row` of colored `Box` composables. Heights are proportional to the score (1–10). Missed days render as grey.

## Deep-link URL
Both widgets deep-link to: `vitalpet://checkin`
- iOS: `widgetURL(URL(string: "vitalpet://checkin")!)` on the widget view
- Android: `actionStartActivity<MainActivity>(context)` with `Uri.parse("vitalpet://checkin")`
- Flutter: registered in `go_router` as a route path `/checkin`

## Troubleshooting
| Problem | Fix |
|---|---|
| Widget not updating | Verify `HomeWidget.updateWidget()` is called after data write; check App Group entitlements on both targets in Xcode |
| Keys not matching | Android uses `"flutter.<key>"` prefix — `WidgetDataProvider` must prefix all key reads |
| Widget not refreshing at midnight | Ensure `TimelineReloadPolicy.after(midnight)` is set in `getTimeline` |
| Blank widget on Android | Check widget is registered in `AndroidManifest.xml` with correct receiver class |
