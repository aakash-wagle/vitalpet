import 'package:go_router/go_router.dart';
import 'package:vitalpet/features/check_in/presentation/check_in_screen.dart';
import 'package:vitalpet/features/handoff/presentation/handoff_screen.dart';
import 'package:vitalpet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vitalpet/features/pet/presentation/death_screen.dart';
import 'package:vitalpet/features/pet/presentation/home_screen.dart';
import 'package:vitalpet/presentation/screens/settings_screen.dart';

/// GoRouter configuration for VitalPet.
/// Deep-link scheme: vitalpet://
final appRouter = GoRouter(
  initialLocation: '/',
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
