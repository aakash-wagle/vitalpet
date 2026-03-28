import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';

/// Shown when pet vitality reaches 0.
/// Greyscale fade animation, shows lifespan and "Start again" CTA.
class DeathScreen extends ConsumerWidget {
  const DeathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your pet has passed away'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await ref.read(petProvider.notifier).archivePet();
              },
              child: const Text('Start again'),
            ),
          ],
        ),
      ),
    );
  }
}
