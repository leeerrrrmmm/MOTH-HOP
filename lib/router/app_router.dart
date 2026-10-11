import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/feature/game/presentation/game_screen.dart';
import 'package:moth_hop/feature/game/presentation/pause_screen.dart';
import 'package:moth_hop/feature/home/presentation/home_screen.dart';
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
      path: Routes.game,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage<void>(
          key: state.pageKey, // Сохраняет состояние страницы
          child: const GameScreen(),
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Время появления
          reverseTransitionDuration: const Duration(
            milliseconds: 200,
          ), // Время исчезновения при возврате
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Эффект потухания: плавное изменение прозрачности
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: Routes.pause,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PauseScreen(),
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Tween: от "над экраном" (-1) до "на месте" (0)
            final tween = Tween(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
