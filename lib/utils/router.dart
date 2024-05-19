import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth/pages/history_page.dart';
import 'package:qr_earth/pages/home_page.dart';
import 'package:qr_earth/pages/leaderboard_page.dart';
import 'package:qr_earth/pages/log_in_email_page.dart';
import 'package:qr_earth/pages/scanner_page.dart';
import 'package:qr_earth/pages/scanner_success.dart';
import 'package:qr_earth/pages/settings_page.dart';
import 'package:qr_earth/pages/sign_up_page.dart';
import 'package:qr_earth/screens/home_screen.dart';
import 'package:qr_earth/screens/log_in_screen.dart';
import 'package:qr_earth/screens/scan_screen.dart';
import 'package:qr_earth/screens/splash_screen.dart';

GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GlobalKey<NavigatorState> homeShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeShell');

GlobalKey<NavigatorState> loginShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'loginShell');

GlobalKey<NavigatorState> scanShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'scanShell');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LoginScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "signup",
              path: "/signup",
              pageBuilder: (context, state) => NoTransitionPage(
                child: SignUpPage(
                  email: state.uri.queryParameters['email'],
                  username: state.uri.queryParameters['username'],
                  phone: state.uri.queryParameters['phone'],
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/login/username",
              name: "login_username",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LoginEmailPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/login/email",
              name: "login_email",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LoginEmailPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/login/phone",
              name: "login_phone",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LoginEmailPage(),
              ),
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScanScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/scan/scanner",
              name: "scanner",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ScannerPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/scan/success",
              name: "success",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ScannerSuccessPage(),
              ),
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/home",
              name: "home",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/leaderboard",
              name: "leaderboard",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LeaderboardPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/history",
              name: "history",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/settings",
              name: "settings",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsPage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
