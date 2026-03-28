import 'package:flutter/material.dart';
import 'package:vitalpet/features/handoff/handoff_generator.dart';

/// Doctor handoff screen: date-range picker + "Generate" button + preview.
class HandoffScreen extends StatefulWidget {
  const HandoffScreen({super.key});

  @override
  State<HandoffScreen> createState() => _HandoffScreenState();
}

class _HandoffScreenState extends State<HandoffScreen> {
  int _dayCount = 30;
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    try {
      await const HandoffGenerator().generateAndShare(dayCount: _dayCount);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Handoff')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButton<int>(
              value: _dayCount,
              items: const [
                DropdownMenuItem(value: 7, child: Text('Last 7 days')),
                DropdownMenuItem(value: 14, child: Text('Last 14 days')),
                DropdownMenuItem(value: 30, child: Text('Last 30 days')),
                DropdownMenuItem(value: 90, child: Text('Last 90 days')),
              ],
              onChanged: (v) => setState(() => _dayCount = v ?? 30),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _generating ? null : _generate,
              child: _generating
                  ? const CircularProgressIndicator()
                  : const Text('Generate & Share'),
            ),
          ],
        ),
      ),
    );
  }
}
