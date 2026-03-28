import 'package:flutter_gemma/flutter_gemma.dart';

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

  // ignore: unused_field — used in generate() when implemented
  final FlutterGemmaPlugin _gemma;

  /// Generates a response for [prompt] within the timeout.
  /// Throws [SLMTimeoutException] on timeout.
  Future<String> generate(String prompt, {Duration? timeout}) async {
    // TODO: implement with flutter_gemma streaming API + timeout
    throw UnimplementedError();
  }

  /// Loads the model weights from assets/models/.
  /// Must be called once during app initialisation.
  Future<void> initialise() async {
    // TODO: implement model download / load flow
  }
}
