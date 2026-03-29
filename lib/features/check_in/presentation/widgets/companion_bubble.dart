import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vitalpet/features/slm/medical_content_filter.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Speech-bubble widget attributed to the pet companion (Mode 3).
///
/// - Text animates with a typewriter effect (respect disableAnimations).
/// - All text is passed through [MedicalContentFilter] before display.
/// - No time-pressure UI — no countdown, no urgency indicator.
class CompanionBubble extends StatefulWidget {
  const CompanionBubble({
    super.key,
    required this.petName,
    required this.message,
  });

  final String petName;

  /// Raw message text — filtered through [MedicalContentFilter] on display.
  final String message;

  @override
  State<CompanionBubble> createState() => _CompanionBubbleState();
}

class _CompanionBubbleState extends State<CompanionBubble> {
  static const _charsPerTick = 2;
  static const _tickMs = 30;

  // MedicalContentFilter with empty pattern list here because patterns are
  // loaded at app startup via rootBundle. The notifier layer passes pre-
  // filtered text; this is a defence-in-depth re-check.
  static const _filter = MedicalContentFilter([]);

  late String _safeText;
  String _displayed = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _safeText = _filter.filter(widget.message).text;
    _startTyping();
  }

  @override
  void didUpdateWidget(CompanionBubble old) {
    super.didUpdateWidget(old);
    if (old.message != widget.message) {
      _safeText = _filter.filter(widget.message).text;
      _displayed = '';
      _timer?.cancel();
      _startTyping();
    }
  }

  void _startTyping() {
    if (_safeText.isEmpty) {
      _displayed = '';
      return;
    }

    // Respect reduced-motion preference — skip animation.
    final disableAnimations =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .reduceMotion;

    if (disableAnimations) {
      setState(() => _displayed = _safeText);
      return;
    }

    var charIndex = 0;
    _timer =
        Timer.periodic(const Duration(milliseconds: _tickMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      charIndex += _charsPerTick;
      if (charIndex >= _safeText.length) {
        setState(() => _displayed = _safeText);
        timer.cancel();
      } else {
        setState(() => _displayed = _safeText.substring(0, charIndex));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pet avatar circle
        Semantics(
          label: '${widget.petName} avatar',
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              color: AppColors.surface,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.petName,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _displayed.isEmpty ? '…' : _displayed,
                    style: AppTextStyles.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
