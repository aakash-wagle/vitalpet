import 'package:flutter/material.dart';

/// Surfaces a deviation alert when a metric is >1.5 SD from baseline.
class DeviationAlertCard extends StatelessWidget {
  const DeviationAlertCard({super.key, this.alerts = const []});

  final List<String> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: alerts.map((a) => Text(a)).toList(),
        ),
      ),
    );
  }
}
