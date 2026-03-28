import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG body silhouette tap widget for localising pain/symptoms.
class BodyMap extends StatefulWidget {
  const BodyMap({super.key, this.onRegionSelected});

  final ValueChanged<String>? onRegionSelected;

  @override
  State<BodyMap> createState() => _BodyMapState();
}

class _BodyMapState extends State<BodyMap> {
  // ignore: unused_field — populated when tappable SVG regions are implemented
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    // TODO: load SVG with tappable regions
    return SvgPicture.asset(
      'assets/animations/body_map.svg',
      fit: BoxFit.contain,
    );
  }
}
