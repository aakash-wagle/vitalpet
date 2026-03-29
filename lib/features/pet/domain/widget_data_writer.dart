import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';

/// Writes the minimum pet data needed by the native home-screen widget to the
/// App Group / SharedPreferences shared container.
///
/// Never include health data — only pet name, visual state index, streak,
/// and the wellness-score sparkline (last 7 days, values 1–10).
Future<void> updateWidgetData(PetState petState, List<int> sparkline) async {
  // iOS WidgetKit sync requires an App Group entitlement configured in both
  // Runner + widget extension targets. This build path keeps check-ins
  // functional even when App Groups are not configured.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    debugPrint(
      '[WidgetDataWriter] Skipping iOS widget sync (App Group not configured).',
    );
    return;
  }

  try {
    await HomeWidget.saveWidgetData<String>('pet_name', petState.name);
    await HomeWidget.saveWidgetData<int>(
      'pet_state',
      petState.visualState.index + 1,
    );
    await HomeWidget.saveWidgetData<int>('streak', petState.streak);
    await HomeWidget.saveWidgetData<String>(
      'sparkline',
      sparkline.take(7).join(','),
    );
    await HomeWidget.updateWidget(
      iOSName: 'VitalPetWidget',
      androidName: 'VitalPetWidget',
    );
  } on PlatformException catch (e) {
    debugPrint(
      '[WidgetDataWriter] Widget sync skipped: ${e.message ?? e.code}',
    );
  } catch (e) {
    debugPrint('[WidgetDataWriter] Widget sync failed: $e');
  }
}
