import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';

/// In-memory store for the in-progress check-in session.
/// Cleared on app restart. Partial sessions are persisted via CheckInDao.
class SessionStore {
  CheckInSessionState _state = const CheckInSessionState.idle();

  CheckInSessionState get current => _state;

  void update(CheckInSessionState next) {
    _state = next;
  }

  void reset() {
    _state = const CheckInSessionState.idle();
  }
}
