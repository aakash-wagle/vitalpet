import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/mode_selector.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';

/// Orchestrates the full check-in session lifecycle.
/// All business logic lives here — presentation is stateless.
class CheckInEngine {
  const CheckInEngine();

  /// Starts a new session from a wellness score.
  CheckInSessionState startSession(int wellnessScore) {
    // selectMode determines question depth (light / standard / companion).
    final _ = selectMode(wellnessScore);
    // TODO: load domains from symptom_taxonomy.json, build initial state
    throw UnimplementedError();
  }

  /// Advances session with a completed answer; returns next state.
  CheckInSessionState advance(
    CheckInSessionState current,
    QuestionAnswer answer,
  ) {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Saves current progress as a partial session.
  CheckInSessionState savePartial(CheckInSessionState current) {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Resumes a previously partial session.
  CheckInSessionState resumePartial(Map<String, dynamic> stored) {
    // TODO: implement
    throw UnimplementedError();
  }

  /// Finalises the session; triggers DB write inside db.transaction().
  Future<void> completeSession(CheckInSessionState current) async {
    // TODO: implement — CHECKIN_WRITE audit event
  }

  /// Amends a same-day completed check-in.
  Future<void> amendSession(int checkInId, List<QuestionAnswer> updates) async {
    // TODO: implement — AMENDMENT audit event
  }
}
