import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_notifier.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/wellness_slider.dart';

/// Main check-in screen: WellnessSlider → follow-up questions → done.
class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(checkInSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Check-in')),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => const WellnessSlider(),
      ),
    );
  }
}
