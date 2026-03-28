import 'package:flutter/material.dart';

/// 4-species grid for pet selection during onboarding.
class PetSelector extends StatelessWidget {
  const PetSelector({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _species = ['cat', 'dog', 'rabbit', 'dragon'];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(24),
      children: _species
          .map(
            (s) => GestureDetector(
              onTap: () => onSelected(s),
              child: Card(
                child: Center(child: Text(s.toUpperCase())),
              ),
            ),
          )
          .toList(),
    );
  }
}
