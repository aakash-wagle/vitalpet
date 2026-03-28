import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';

/// Renders the Rive pet animation driven by vitality and boolean inputs.
class PetRenderer extends StatefulWidget {
  const PetRenderer({super.key, required this.petState});

  final PetState petState;

  @override
  State<PetRenderer> createState() => _PetRendererState();
}

class _PetRendererState extends State<PetRenderer> {
  StateMachineController? _controller;
  SMINumber? _vitalityInput;
  // ignore: unused_field — triggered in triggerCheckInComplete() (Sprint 1)
  SMIBool? _checkInCompleteInput;
  SMIBool? _isDeadInput;

  String get _assetPath =>
      'assets/animations/${widget.petState.species.name}.riv';

  void _onRiveInit(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(
      artboard,
      'PetStateMachine',
    );
    if (_controller == null) return;
    artboard.addController(_controller!);
    _vitalityInput =
        _controller!.findInput<double>('vitality') as SMINumber?;
    _checkInCompleteInput =
        _controller!.findInput<bool>('checkInComplete') as SMIBool?;
    _isDeadInput = _controller!.findInput<bool>('isDead') as SMIBool?;
    _syncInputs();
  }

  void _syncInputs() {
    _vitalityInput?.value = widget.petState.vitality.toDouble();
    _isDeadInput?.value =
        widget.petState.visualState == PetStateEnum.dead;
  }

  @override
  void didUpdateWidget(PetRenderer old) {
    super.didUpdateWidget(old);
    _syncInputs();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: RiveAnimation.asset(
        _assetPath,
        onInit: _onRiveInit,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
