import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/presentation/widgets/pet_renderer.dart';
import 'package:vitalpet/features/pet/presentation/widgets/streak_badge.dart';
import 'package:vitalpet/features/pet/presentation/widgets/deviation_alert_card.dart';

/// Home screen: PetRenderer + streak + deviation alert card.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider);

    return Scaffold(
      body: petAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (pet) => pet == null
            ? const Center(child: Text('No pet yet'))
            : Column(
                children: [
                  PetRenderer(petState: pet),
                  StreakBadge(streak: pet.currentStreak),
                  const DeviationAlertCard(),
                ],
              ),
      ),
    );
  }
}
