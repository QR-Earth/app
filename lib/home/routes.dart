import 'package:qr_earth/home/pages/history_page.dart';
import 'package:qr_earth/home/pages/home_page.dart';
import 'package:qr_earth/home/pages/leaderboard_page.dart';
import 'package:qr_earth/home/pages/settings_page.dart';
import 'package:qr_earth/home/screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellRoute homeRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return HomeScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "home",
          path: "/home",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "leaderboard",
          path: "/home/leaderboard",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeaderboardPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "history",
          path: "/home/history",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HistoryPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "settings",
          path: "/home/settings",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
