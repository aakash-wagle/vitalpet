# iOS WidgetKit — Manual Xcode Setup Steps

These steps must be completed once in Xcode before the widget extension will build
and appear in the home screen widget picker.

## Prerequisites

- Xcode 15+ installed
- The Flutter app (`Runner`) already exists as an Xcode project at `ios/Runner.xcodeproj`
- You have an Apple Developer account with App Group capability enabled for your bundle ID

---

## Step 1 — Add the Widget Extension Target

1. Open `ios/Runner.xcworkspace` in Xcode (use the workspace, not the `.xcodeproj`).
2. In the Project Navigator, select the **Runner** project (top of the tree).
3. Click the **+** button at the bottom of the Targets list.
4. Choose **Widget Extension** and click **Next**.
5. Fill in:
   - **Product Name**: `VitalPetWidget`
   - **Team**: your Apple Developer team
   - **Bundle Identifier**: `com.vitalpet.app.VitalPetWidget` (or match your Runner bundle ID + `.VitalPetWidget`)
   - **Include Configuration App Intent**: **No** (uncheck)
6. Click **Finish**. When Xcode asks to activate the scheme, click **Activate**.

---

## Step 2 — Replace Xcode-Generated Stubs with Project Source Files

Xcode generates placeholder Swift files inside the new target folder.  
Replace them with the files already in `native/ios/VitalPetWidget/`:

1. In the Project Navigator, expand the `VitalPetWidget` target group.
2. Delete the Xcode-generated `VitalPetWidget.swift`, `VitalPetEntry.swift`, and any other stubs
   (move to Trash when prompted).
3. Drag the following files from `native/ios/VitalPetWidget/` into the target group:
   - `VitalPetWidget.swift`
   - `WidgetDataProvider.swift`
   - `VitalPetEntryView.swift`
   - `WellnessSparkline.swift`
4. In the **Add to targets** dialog, ensure **VitalPetWidget** is checked.

---

## Step 3 — Add the Greeting Image to the Widget Asset Catalog

The widget uses a single dog image called `"greeting"` from its own asset catalog.
The source file is at `assets/images/pets/greeting.png`.

1. In the Project Navigator, find the asset catalog inside the **VitalPetWidget** target
   (Xcode names it `Assets.xcassets` inside the widget group).
2. With the asset catalog open in the editor, click the **+** button → **New Image Set**.
3. Name the image set exactly: `greeting`
4. Drag `assets/images/pets/greeting.png` into the **1x** slot.
   - If your image is @2x or @3x resolution, drag it into the corresponding slot instead.

> **Note**: Do NOT add this image to the main Runner target's `Assets.xcassets`.
> The widget extension has its own asset catalog and cannot read from the main app bundle.

---

## Step 4 — Set the App Group Entitlement on Both Targets

The widget reads from `group.com.vitalpet.shared` — this must be enabled in both targets.

### Main App (Runner) target:
1. Select the **Runner** target → **Signing & Capabilities** tab.
2. Click **+ Capability** → search for **App Groups** → add it.
3. Click **+** under the App Groups list and enter: `group.com.vitalpet.shared`

### Widget Extension (VitalPetWidget) target:
1. Select the **VitalPetWidget** target → **Signing & Capabilities** tab.
2. Click **+ Capability** → **App Groups**.
3. Click **+** and enter the same ID: `group.com.vitalpet.shared`
4. Verify the file `native/ios/VitalPetWidget/VitalPetWidget.entitlements` is shown
   as the entitlements file in **Build Settings → Code Signing Entitlements**.
   If it points to a different file, update the build setting to use this path.

---

## Step 5 — Add the Deep-Link URL Scheme to Runner

The widget's `widgetURL` taps open `vitalpet://checkin`. Flutter's go_router handles
this path, but iOS needs the URL scheme registered.

1. Select the **Runner** target → **Info** tab.
2. Expand **URL Types** (or add one if empty).
3. Click **+** and set:
   - **Identifier**: `com.vitalpet.app`
   - **URL Schemes**: `vitalpet`

---

## Step 6 — Set Minimum Deployment Target

1. Select the **VitalPetWidget** target → **General** tab.
2. Set **Minimum Deployments** → iOS **16.0** (matches the main app).

---

## Step 7 — Build & Verify

```bash
# From the vitalpet/ workspace root:
flutter build ios --no-codesign
```

Then in Xcode:
- Select your physical device or simulator (iOS 16+).
- Press **⌘R** to build and run.
- Long-press the home screen → tap **+** (top left) → search for **VitalPet**.
- You should see both **Small** and **Medium** widget sizes in the picker.

---

## Step 8 — Verify Data Flow

After a successful build:

1. Complete a check-in in the app.
2. `CheckInEngine.completeSession()` calls `updateWidgetData()`, which writes to:
   - `pet_name` — string
   - `pet_state` — int (1–5)
   - `streak` — int
   - `sparkline` — comma-separated 7 scores, e.g. `"6,7,8,5,9,7,8"`
3. `HomeWidget.updateWidget(iOSName: 'VitalPetWidget')` triggers WidgetKit reload.
4. The widget should refresh within a few seconds.

If the widget does not update, check:
- App Group ID matches in **both** targets' entitlements.
- The provisioning profiles include the `com.apple.security.application-groups` entitlement.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Widget shows placeholder / blank | App Group entitlement missing on one target; verify Step 4 |
| `greeting` image not found | Asset not added to widget's own `Assets.xcassets`; see Step 3 |
| Deep-link does nothing on tap | URL scheme `vitalpet` not registered; see Step 5 |
| Build error: `@main` conflict | Delete Xcode-generated stub files; see Step 2 |
| Widget not in picker | Minimum deployment target mismatch; set both targets to iOS 16.0 |
| Sparkline always empty | `sparkline` key mismatch — confirm `home_widget` writes to `group.com.vitalpet.shared` |
