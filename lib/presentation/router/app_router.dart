import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/check_in/presentation/check_in_screen.dart';
import 'package:vitalpet/features/handoff/presentation/handoff_screen.dart';
import 'package:vitalpet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vitalpet/features/pet/presentation/death_screen.dart';
import 'package:vitalpet/features/pet/presentation/home_screen.dart';
import 'package:vitalpet/presentation/screens/settings_screen.dart';

/// GoRouter configuration for VitalPet.
///
/// Deep-link scheme: vitalpet://
///   vitalpet://checkin  →  /checkin
///   vitalpet://handoff  →  /handoff
///
/// iOS: register the URL scheme in ios/Runner/Info.plist:
///
/// ```xml
/// CFBundleURLTypes → CFBundleURLSchemes → vitalpet
/// ```
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  redirect: _handleDeepLink,
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

/// Rewrites deep links using the vitalpet:// scheme to their in-app paths.
/// e.g. vitalpet://checkin  →  /checkin
String? _handleDeepLink(_, GoRouterState state) {
  final uri = state.uri;
  if (uri.scheme == 'vitalpet') {
    // vitalpet://checkin  →  host='checkin', path=''
    // Map the host segment to a route path.
    final segment = uri.host.isNotEmpty ? uri.host : uri.path.replaceFirst('/', '');
    if (segment.isNotEmpty) return '/$segment';
  }
  return null;
}
