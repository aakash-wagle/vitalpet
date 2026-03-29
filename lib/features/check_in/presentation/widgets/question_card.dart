import 'package:flutter/material.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';
import 'package:vitalpet/features/check_in/presentation/widgets/body_map.dart';
import 'package:vitalpet/features/slm/medical_content_filter.dart';
import 'package:vitalpet/features/slm/slm_output.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Renders a single question: binary | slider | body_map | text input.
///
/// All prompt strings pass through [MedicalContentFilter] before display.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  final SLMQuestion question;
  final ValueChanged<QuestionAnswer> onAnswered;

  @override
  Widget build(BuildContext context) {
    // Every displayed string MUST pass MedicalContentFilter.
    const filter = MedicalContentFilter([]);
    final promptResult = filter.filter(question.prompt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          promptResult.text,
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 20),
        _buildInput(context, question),
      ],
    );
  }

  Widget _buildInput(BuildContext context, SLMQuestion q) {
    return switch (q.type) {
      QuestionType.binary => _BinaryInput(question: q, onAnswered: onAnswered),
      QuestionType.slider => _SliderInput(question: q, onAnswered: onAnswered),
      QuestionType.bodyMap =>
        _BodyMapInput(question: q, onAnswered: onAnswered),
      QuestionType.text => _TextInput(question: q, onAnswered: onAnswered),
    };
  }
}

// ---------------------------------------------------------------------------
// Binary — two labelled buttons
// ---------------------------------------------------------------------------

class _BinaryInput extends StatelessWidget {
  const _BinaryInput({required this.question, required this.onAnswered});

  final SLMQuestion question;
  final ValueChanged<QuestionAnswer> onAnswered;

  @override
  Widget build(BuildContext context) {
    final opts = question.options ?? {'yes': 'Yes', 'no': 'No'};
    return Row(
      children: opts.entries.map((e) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Semantics(
              button: true,
              label: e.value,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => onAnswered(
                    QuestionAnswer(
                      domain: question.domain,
                      questionType: question.type.name,
                      value: e.key,
                    ),
                  ),
                  child: Text(e.value, style: AppTextStyles.labelLarge),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Slider — 1–5 with labelled ends
// ---------------------------------------------------------------------------

class _SliderInput extends StatefulWidget {
  const _SliderInput({required this.question, required this.onAnswered});

  final SLMQuestion question;
  final ValueChanged<QuestionAnswer> onAnswered;

  @override
  State<_SliderInput> createState() => _SliderInputState();
}

class _SliderInputState extends State<_SliderInput> {
  double _value = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _value,
          min: 1,
          max: 5,
          divisions: 4,
          label: _value.round().toString(),
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() => _value = v),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('None', style: AppTextStyles.labelSmall),
            Text('Severe', style: AppTextStyles.labelSmall),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () => widget.onAnswered(
              QuestionAnswer(
                domain: widget.question.domain,
                questionType: widget.question.type.name,
                value: _value.round(),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Body map — SVG silhouette with tap regions
// ---------------------------------------------------------------------------

class _BodyMapInput extends StatelessWidget {
  const _BodyMapInput({required this.question, required this.onAnswered});

  final SLMQuestion question;
  final ValueChanged<QuestionAnswer> onAnswered;

  @override
  Widget build(BuildContext context) {
    return BodyMap(
      onRegionsConfirmed: (regions) => onAnswered(
        QuestionAnswer(
          domain: question.domain,
          questionType: question.type.name,
          value: regions,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Text input — free-form multi-line
// ---------------------------------------------------------------------------

class _TextInput extends StatefulWidget {
  const _TextInput({required this.question, required this.onAnswered});

  final SLMQuestion question;
  final ValueChanged<QuestionAnswer> onAnswered;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          label: widget.question.prompt,
          textField: true,
          child: TextField(
            controller: _controller,
            maxLines: 4,
            minLines: 2,
            decoration: InputDecoration(
              hintText: 'Type your answer here…',
              hintStyle: AppTextStyles.bodyMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textTertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            style: AppTextStyles.bodyLarge,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () => widget.onAnswered(
              QuestionAnswer(
                domain: widget.question.domain,
                questionType: widget.question.type.name,
                value: _controller.text.trim(),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}
