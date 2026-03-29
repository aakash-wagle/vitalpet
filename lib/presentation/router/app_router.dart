import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/check_in/presentation/check_in_screen.dart';
import 'package:vitalpet/features/handoff/presentation/handoff_screen.dart';
import 'package:vitalpet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vitalpet/features/pet/domain/pet_notifier.dart';
import 'package:vitalpet/features/pet/domain/pet_state.dart';
import 'package:vitalpet/features/pet/presentation/death_screen.dart';
import 'package:vitalpet/features/pet/presentation/home_screen.dart';
import 'package:vitalpet/presentation/screens/settings_screen.dart';

/// GoRouter provided via Riverpod so the redirect guard can read [petProvider].
///
/// Deep-link scheme: vitalpet://checkin → /checkin
/// iOS prerequisite (not handled here — must be set in ios/Runner/Info.plist):
///   CFBundleURLSchemes: [vitalpet]
///
/// GoRouter strips the scheme/host and routes on the path, so
/// vitalpet://checkin arrives at the router as the path "/checkin".
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: (context, state) {
      // Custom URL-scheme deep links arrive with the authority portion as the
      // "host". Remap vitalpet://checkin (path == "/") to /checkin explicitly
      // so that path-less scheme links still navigate correctly.
      final uri = state.uri;
      if (uri.scheme == 'vitalpet' && uri.host.isNotEmpty && uri.path == '/') {
        return '/${uri.host}';
      }

      return notifier.redirect(state);
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/checkin',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: '/handoff',
        builder: (context, state) => const HandoffScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/death',
        builder: (context, state) => const DeathScreen(),
      ),
    ],
  );
});

/// ChangeNotifier that bridges [petProvider] → GoRouter's refreshListenable.
///
/// When [petProvider] emits a new value (e.g. pet created during onboarding),
/// GoRouter re-evaluates the [redirect] callback and automatically navigates
/// away from /onboarding to /.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    _petState = ref.read(petProvider);
    ref.listen<AsyncValue<PetState?>>(petProvider, (_, next) {
      _petState = next;
      notifyListeners();
    });
  }

  AsyncValue<PetState?> _petState = const AsyncValue.loading();

  /// Returns the redirect path, or null if no redirect is needed.
  String? redirect(GoRouterState state) {
    // Still loading — don't redirect yet.
    if (_petState.isLoading) return null;

    final hasPet = _petState.value != null;
    final onOnboarding = state.matchedLocation == '/onboarding';

    // First launch: no pet → send to onboarding.
    if (!hasPet && !onOnboarding) return '/onboarding';

    // Onboarding complete: pet exists → leave onboarding.
    if (hasPet && onOnboarding) return '/';

    return null;
  }
}
