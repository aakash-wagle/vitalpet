import 'package:flutter/material.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';

/// Renders a single question: binary | slider | body_map | text input.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  final String question;
  final ValueChanged<QuestionAnswer> onAnswered;

  @override
  Widget build(BuildContext context) {
    // TODO: implement question type routing
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(question),
      ),
    );
  }
}
