import 'package:flutter/material.dart';

/// Displays the current check-in streak count.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$streak day streak'),
      avatar: const Icon(Icons.local_fire_department),
    );
  }
}
