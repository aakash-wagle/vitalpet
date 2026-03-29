import 'package:flutter/material.dart';
import 'package:vitalpet/core/constants/app_constants.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Pet name text field with live validation and character counter.
///
/// Rules: 2–20 characters. Error state shows both red border AND error text
/// so colour is never the sole meaning indicator (accessibility).
class PetNameInput extends StatefulWidget {
  const PetNameInput({
    super.key,
    required this.onChanged,
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<PetNameInput> createState() => _PetNameInputState();
}

class _PetNameInputState extends State<PetNameInput> {
  late final TextEditingController _controller;
  String? _errorText;

  static const _min = AppConstants.petNameMinLength;
  static const _max = AppConstants.petNameMaxLength;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final trimmed = _controller.text.trim();
    String? error;
    if (trimmed.isEmpty) {
      error = 'Name cannot be empty';
    } else if (trimmed.length < _min) {
      error = 'Name must be at least $_min characters';
    } else if (trimmed.length > _max) {
      error = 'Name must be $_max characters or fewer';
    }
    setState(() => _errorText = error);
    widget.onChanged(error == null ? trimmed : '');
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Semantics(
      label: 'Pet name input',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            maxLength: _max,
            buildCounter: (_,
                {required currentLength,
                required isFocused,
                maxLength}) =>
                Text(
                  '$currentLength/$_max',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: hasError
                        ? AppColors.danger
                        : AppColors.textTertiary,
                  ),
                ),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimaryDark,
            ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: 'e.g. Biscuit',
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: const Color(0xFF1A1D23),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? AppColors.danger : AppColors.textTertiary,
                  width: hasError ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? AppColors.danger : AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.error_outline,
                    size: 14, color: AppColors.danger),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _errorText!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
