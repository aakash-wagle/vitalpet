import 'package:flutter/material.dart';

/// Mode 3 empathic chat bubble attributed to the pet companion.
class CompanionBubble extends StatelessWidget {
  const CompanionBubble({
    super.key,
    required this.petName,
    required this.message,
  });

  final String petName;
  final String message;

  @override
  Widget build(BuildContext context) {
    // TODO: implement styled bubble with pet avatar
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('$petName: $message'),
    );
  }
}
