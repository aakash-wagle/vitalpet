import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitalpet/features/check_in/domain/check_in_session_state.dart';
import 'package:vitalpet/features/check_in/domain/question_answer.dart';

part 'check_in_session_notifier.g.dart';

@riverpod
class CheckInSessionNotifier extends _$CheckInSessionNotifier {
  @override
  Future<CheckInSessionState> build() async {
    return const CheckInSessionState.idle();
  }

  Future<void> submitWellnessScore(int score) async {
    // TODO: implement
  }

  Future<void> submitAnswer(QuestionAnswer answer) async {
    // TODO: implement
  }

  Future<void> savePartial() async {
    // TODO: implement
  }

  Future<void> resumePartial() async {
    // TODO: implement
  }

  Future<void> completeSession() async {
    // TODO: implement
  }

  Future<void> amendSession(String checkInId, List<QuestionAnswer> updates) async {
    // TODO: implement
  }
}
