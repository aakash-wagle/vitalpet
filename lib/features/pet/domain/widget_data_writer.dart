import 'package:home_widget/home_widget.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';

/// Writes pet state to the App Group / SharedPreferences container
/// so the native home screen widget can read it.
Future<void> updateWidgetData(PetState petState) async {
  // TODO: implement using home_widget package
  // Never include health data — only pet name, visual state, and streak.
  await HomeWidget.saveWidgetData<String>(
    'pet_name',
    petState.name,
  );
  await HomeWidget.saveWidgetData<int>(
    'pet_state',
    petState.visualState.index + 1,
  );
  await HomeWidget.saveWidgetData<int>(
    'streak',
    petState.currentStreak,
  );
  await HomeWidget.updateWidget(
    iOSName: 'VitalPetWidget',
    androidName: 'VitalPetWidget',
  );
}
