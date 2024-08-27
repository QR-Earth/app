import 'package:qr_earth/auth/routes.dart';
import 'package:qr_earth/home/routes.dart';
import 'package:qr_earth/scanner/routes.dart';
import 'package:qr_earth/splash/splash_screen.dart';
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
