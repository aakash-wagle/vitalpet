import 'package:flutter/material.dart';
import 'package:vitalpet/presentation/theme/app_colors.dart';
import 'package:vitalpet/presentation/theme/app_text_styles.dart';

/// Identifier for each selectable body region.
enum BodyRegion {
  head('Head'),
  chest('Chest'),
  abdomen('Abdomen'),
  upperLimbLeft('Left arm'),
  upperLimbRight('Right arm'),
  lowerLimbLeft('Left leg'),
  lowerLimbRight('Right leg'),
  back('Back');

  const BodyRegion(this.label);
  final String label;
}

/// SVG-based body silhouette widget with tappable regions.
///
/// Rules enforced by this widget:
/// - Minimum tap target per region: 44×44 logical pixels (WCAG AA).
/// - Maximum 3 regions selected simultaneously; selecting a 4th deselects
///   the oldest (FIFO queue).
/// - Fires [onRegionsConfirmed] when the user taps "Confirm".
class BodyMap extends StatefulWidget {
  const BodyMap({super.key, this.onRegionsConfirmed});

  final ValueChanged<List<String>>? onRegionsConfirmed;

  @override
  State<BodyMap> createState() => _BodyMapState();
}

class _BodyMapState extends State<BodyMap> {
  // Ordered queue — oldest selection first.
  final List<BodyRegion> _selected = [];

  static const _maxSelected = 3;

  void _toggleRegion(BodyRegion region) {
    setState(() {
      if (_selected.contains(region)) {
        _selected.remove(region);
      } else {
        if (_selected.length >= _maxSelected) {
          // Deselect the oldest.
          _selected.removeAt(0);
        }
        _selected.add(region);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Tap up to 3 areas',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Body silhouette represented as a grid of region buttons.
        // In a production build this would overlay a flutter_svg silhouette;
        // for the hackathon we use a clean chip-grid layout that passes WCAG AA.
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: BodyRegion.values.map(_buildRegionChip).toList(),
        ),
        const SizedBox(height: 20),
        if (_selected.isNotEmpty) ...[
          Text(
            'Selected: ${_selected.map((r) => r.label).join(', ')}',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => widget.onRegionsConfirmed?.call(
              _selected.map((r) => r.name).toList(),
            ),
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionChip(BodyRegion region) {
    final isSelected = _selected.contains(region);

    return Semantics(
      label: 'Body region: ${region.label}, '
          '${isSelected ? 'selected' : 'not selected'}',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () => _toggleRegion(region),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          // Minimum 44×44 WCAG AA touch target.
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textTertiary,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            region.label,
            style: AppTextStyles.labelLarge.copyWith(
              color: isSelected ? AppColors.surface : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
