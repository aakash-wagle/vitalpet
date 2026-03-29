import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/domain/pet_state_mapper.dart';

/// Renders the pet as a PNG image with a continuous rocking animation.
///
/// Reads directly from [petProvider] so state changes (last-check-in recency)
/// automatically swap the asset without any prop-drilling.
///
/// Pet PNG assets include transparency, so the display area should not force a
/// solid background color.
///
/// When the pet is marked dead in state, rocking is stopped and dies.png is
/// shown without any additional colour filters.
class PetRenderer extends ConsumerStatefulWidget {
  const PetRenderer({super.key});

  @override
  ConsumerState<PetRenderer> createState() => _PetRendererState();
}

class _PetRendererState extends ConsumerState<PetRenderer>
    with TickerProviderStateMixin {
  late final AnimationController _rockController;
  late final Animation<double> _rockAnimation;
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

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

  /// Trigger a happy bounce on check-in completion.
  /// Called externally by the check-in completion handler.
  void triggerHappyBounce() {
    _bounceController.forward().then((_) => _bounceController.reverse());
  }

  @override
  void dispose() {
    _rockController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petProvider).value;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (pet == null) return const SizedBox(width: 200, height: 200);

    final isDead = pet.visualState == PetStateEnum.dead;
    final assetPath = isDead
        ? 'assets/images/pets/dies.png'
        : PetStateMapper.mapLastCheckinToStateAsset(pet.lastCheckinUtc);

    final image = SizedBox(
      width: 200,
      height: 200,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Image.asset(
          assetPath,
          key: ValueKey(assetPath),
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 200,
            height: 200,
            child: Icon(Icons.pets, size: 80, color: Colors.white),
          ),
        ),
      ),
    );

    final semanticLabel = '${pet.name}, ${pet.stateName}';

    if (disableAnimations || isDead) {
      return Semantics(label: semanticLabel, child: image);
    }

    return Semantics(
      label: semanticLabel,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: AnimatedBuilder(
          animation: _rockAnimation,
          builder: (_, child) =>
              Transform.rotate(angle: _rockAnimation.value, child: child),
          child: image,
        ),
      ),
    );
  }
}
