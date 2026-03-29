import 'package:flutter_test/flutter_test.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/domain/pet_state_mapper.dart';

void main() {
  group('mapVitalityToState', () {
    // --- Exact boundary values ---
    test('vitality 100 → thriving', () {
      expect(mapVitalityToState(100), PetStateEnum.thriving);
    });

    test('vitality 80 → thriving (lower boundary)', () {
      expect(mapVitalityToState(80), PetStateEnum.thriving);
    });

    test('vitality 79 → healthy (just below thriving)', () {
      expect(mapVitalityToState(79), PetStateEnum.healthy);
    });

    test('vitality 60 → healthy (lower boundary)', () {
      expect(mapVitalityToState(60), PetStateEnum.healthy);
    });

    test('vitality 59 → tired (just below healthy)', () {
      expect(mapVitalityToState(59), PetStateEnum.tired);
    });

    test('vitality 40 → tired (lower boundary)', () {
      expect(mapVitalityToState(40), PetStateEnum.tired);
    });

    test('vitality 39 → unwell (just below tired)', () {
      expect(mapVitalityToState(39), PetStateEnum.unwell);
    });

    test('vitality 20 → unwell (lower boundary)', () {
      expect(mapVitalityToState(20), PetStateEnum.unwell);
    });

    test('vitality 19 → critical (just below unwell)', () {
      expect(mapVitalityToState(19), PetStateEnum.critical);
    });

    test('vitality 1 → critical (minimum non-dead)', () {
      expect(mapVitalityToState(1), PetStateEnum.critical);
    });

    test('vitality 0 → dead', () {
      expect(mapVitalityToState(0), PetStateEnum.dead);
    });

    // --- Mid-range values ---
    test('vitality 90 → thriving', () {
      expect(mapVitalityToState(90), PetStateEnum.thriving);
    });

    test('vitality 70 → healthy', () {
      expect(mapVitalityToState(70), PetStateEnum.healthy);
    });

    test('vitality 50 → tired', () {
      expect(mapVitalityToState(50), PetStateEnum.tired);
    });

    test('vitality 30 → unwell', () {
      expect(mapVitalityToState(30), PetStateEnum.unwell);
    });

    test('vitality 10 → critical', () {
      expect(mapVitalityToState(10), PetStateEnum.critical);
    });
  });

  group('PetState.stateIndex', () {
    PetState makePet(PetStateEnum vs) => PetState(
          petId: 'test',
          name: 'Mochi',
          species: PetSpecies.cat,
          vitality: 60,
          visualState: vs,
          streak: 0,
        );

    test('thriving → stateIndex 1', () {
      expect(makePet(PetStateEnum.thriving).stateIndex, 1);
    });

    test('healthy → stateIndex 2', () {
      expect(makePet(PetStateEnum.healthy).stateIndex, 2);
    });

    test('tired → stateIndex 3', () {
      expect(makePet(PetStateEnum.tired).stateIndex, 3);
    });

    test('unwell → stateIndex 4', () {
      expect(makePet(PetStateEnum.unwell).stateIndex, 4);
    });

    test('critical → stateIndex 5', () {
      expect(makePet(PetStateEnum.critical).stateIndex, 5);
    });

    test('dead → stateIndex 5 (same asset as critical)', () {
      expect(makePet(PetStateEnum.dead).stateIndex, 5);
    });
  });

  group('PetState.stateName', () {
    PetState makePet(PetStateEnum vs) => PetState(
          petId: 'test',
          name: 'Mochi',
          species: PetSpecies.cat,
          vitality: 60,
          visualState: vs,
          streak: 0,
        );

    test('thriving state name', () {
      expect(makePet(PetStateEnum.thriving).stateName, 'thriving');
    });

    test('dead state name', () {
      expect(makePet(PetStateEnum.dead).stateName, 'no longer with us');
    });
  });
}
