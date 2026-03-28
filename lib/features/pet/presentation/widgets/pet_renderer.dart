import 'package:flutter/material.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';

/// Renders the pet as a PNG image with a continuous rocking animation.
/// Asset path: assets/images/pets/[species]_[stateIndex].png
/// stateIndex: 1=thriving, 2=happy, 3=neutral, 4=unwell, 5=critical
class PetRenderer extends StatefulWidget {
  const PetRenderer({super.key, required this.petState});

  final PetState petState;

  @override
  State<PetRenderer> createState() => _PetRendererState();
}

class _PetRendererState extends State<PetRenderer>
    with TickerProviderStateMixin {
  late AnimationController _rockController;
  late Animation<double> _rockAnimation;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  /// Maps PetStateEnum to the 1–5 PNG index used in asset filenames.
  int get _stateIndex => switch (widget.petState.visualState) {
        PetStateEnum.thriving => 1,
        PetStateEnum.healthy => 2,
        PetStateEnum.tired => 3,
        PetStateEnum.unwell => 4,
        PetStateEnum.critical || PetStateEnum.dead => 5,
      };

  String get _assetPath =>
      'assets/images/pets/${widget.petState.species.name}_$_stateIndex.png';

  @override
  void initState() {
    super.initState();

    _rockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _rockAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _rockController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );
  }

  /// Call after a check-in completion to trigger a happy bounce.
  void triggerHappyBounce() {
    _bounceController.forward().then((_) => _bounceController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final Widget image = AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Image.asset(
        _assetPath,
        key: ValueKey(_assetPath),
        width: 200,
        height: 200,
      ),
    );

    final semanticLabel =
        '${widget.petState.name} the ${widget.petState.species.name}, '
        '${widget.petState.visualState.name}';

    if (disableAnimations) {
      return Semantics(
        label: semanticLabel,
        child: image,
      );
    }

    return Semantics(
      label: semanticLabel,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: AnimatedBuilder(
          animation: _rockAnimation,
          builder: (_, child) => Transform.rotate(
            angle: _rockAnimation.value,
            child: child,
          ),
          child: image,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rockController.dispose();
    _bounceController.dispose();
    super.dispose();
  }
}
