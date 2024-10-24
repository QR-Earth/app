import 'package:qr_earth/ui/auth/routes.dart';
import 'package:qr_earth/ui/home/routes.dart';
import 'package:qr_earth/ui/scanner/routes.dart';
import 'package:qr_earth/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: <RouteBase>[
    GoRoute(
      name: "splash",
      path: "/splash",
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashScreen(),
      ),
    ),
    authRoute,
    homeRoute,
    scannerRoute,
  ],
);
