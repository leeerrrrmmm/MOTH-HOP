import 'package:go_router/go_router.dart';
import 'package:moth_hop/feature/home/presentation/home_screen.dart';
import 'package:moth_hop/feature/settings_screen.dart';
import 'package:moth_hop/feature/splash_screen.dart';
import 'package:moth_hop/router/routes.dart';

GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,

  routes: [
    GoRoute(
      path: Routes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: Routes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: Routes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
