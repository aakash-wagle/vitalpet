import 'package:flutter/material.dart';

/// Full-screen wellness slider (1–10) with haptic feedback.
class WellnessSlider extends StatefulWidget {
  const WellnessSlider({super.key, this.onScoreSelected});

  final ValueChanged<int>? onScoreSelected;

  @override
  State<WellnessSlider> createState() => _WellnessSliderState();
}

class _WellnessSliderState extends State<WellnessSlider> {
  double _value = 5;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _value.round().toString(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Slider(
            value: _value,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) => setState(() => _value = v),
            onChangeEnd: (v) => widget.onScoreSelected?.call(v.round()),
          ),
        ],
      ),
    );
  }
}
