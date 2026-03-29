import 'dart:async';

import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:vitalpet/core/constants/app_constants.dart';

/// Thrown when on-device SLM inference exceeds [AppConstants.slmTimeoutMs].
class SLMTimeoutException implements Exception {
  const SLMTimeoutException([this.message = 'SLM inference timed out']);
  final String message;
  @override
  String toString() => 'SLMTimeoutException: $message';
}

/// Wraps flutter_gemma (MediaPipe LLM Inference API).
/// All inference is on-device — never calls external endpoints.
class SLMClient {
  SLMClient(this._gemma);

  final FlutterGemmaPlugin _gemma;
  InferenceModel? _model;
  Future<void>? _initialising;

  static const String _defaultModelAssetPath =
      'assets/models/gemma3-1b-it-int4.task';
  static const int _defaultMaxTokens = 4096;

  /// Generates a response for [prompt] within the timeout.
  /// Throws [SLMTimeoutException] on timeout.
  Future<String> generate(String prompt, {Duration? timeout}) async {
    await initialise();
    final model = _model;
    if (model == null) {
      throw StateError('SLM model failed to initialise');
    }

    final effectiveTimeout =
        timeout ?? const Duration(milliseconds: AppConstants.slmTimeoutMs);

    final generation = () async {
      final session = await model.createSession(
        temperature: 0.15,
        randomSeed: 7,
        topK: 40,
        topP: 0.92,
      );

      try {
        await session.addQueryChunk(Message.text(text: prompt, isUser: true));
        return await session.getResponse();
      } finally {
        await session.close();
      }
    }();

    try {
      return await generation.timeout(
        effectiveTimeout,
        onTimeout: () => throw const SLMTimeoutException(),
      );
    } on TimeoutException {
      throw const SLMTimeoutException();
    }
  }

  /// Loads the model weights from assets/models/.
  /// Must be called once during app initialisation.
  Future<void> initialise() async {
    if (_model != null) return;
    if (_initialising != null) return _initialising;

    _initialising = _initialiseInternal();
    return _initialising;
  }

  Future<void> _initialiseInternal() async {
    try {
      await FlutterGemma.initialize();

      final manager = _gemma.modelManager;
      if (manager.activeInferenceModel == null) {
        await FlutterGemma.installModel(
          modelType: ModelType.gemmaIt,
          fileType: ModelFileType.task,
        ).fromAsset(_defaultModelAssetPath).install();
      }

      final activeSpec = manager.activeInferenceModel;
      if (activeSpec is! InferenceModelSpec) {
        throw StateError('No active inference model configured');
      }

      _model = await _gemma.createModel(
        modelType: activeSpec.modelType,
        fileType: activeSpec.fileType,
        maxTokens: _defaultMaxTokens,
        preferredBackend: PreferredBackend.cpu,
      );
    } finally {
      _initialising = null;
    }
  }
}
