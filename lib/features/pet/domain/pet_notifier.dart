import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';

part 'pet_notifier.g.dart';

@riverpod
class PetNotifier extends _$PetNotifier {
  @override
  Future<PetState?> build() async {
    // TODO: load pet state from PetDao
    return null;
  }

  Future<void> recalculate() async {
    // TODO: fetch check-in history → calculateVitality → mapVitalityToState
  }

  Future<void> triggerDeath() async {
    // TODO: set vitality=0, visualState=dead, persist
  }

  Future<void> archivePet() async {
    // TODO: move current pet to archive, clear pet_state
  }
}
