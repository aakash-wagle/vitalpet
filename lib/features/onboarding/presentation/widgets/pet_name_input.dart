import 'package:flutter/material.dart';
import 'package:vitalpet/core/constants/app_constants.dart';

/// Text field for naming the pet (2–20 characters).
class PetNameInput extends StatefulWidget {
  const PetNameInput({super.key, required this.onSubmitted});

  final ValueChanged<String> onSubmitted;

  @override
  State<PetNameInput> createState() => _PetNameInputState();
}

class _PetNameInputState extends State<PetNameInput> {
  final _controller = TextEditingController();
  String? _error;

  void _submit() {
    final name = _controller.text.trim();
    if (name.length < AppConstants.petNameMinLength ||
        name.length > AppConstants.petNameMaxLength) {
      setState(() => _error =
          'Name must be ${AppConstants.petNameMinLength}–${AppConstants.petNameMaxLength} characters');
      return;
    }
    widget.onSubmitted(name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLength: AppConstants.petNameMaxLength,
            decoration: InputDecoration(
              labelText: "What's your pet's name?",
              errorText: _error,
            ),
          ),
          ElevatedButton(onPressed: _submit, child: const Text('Continue')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
