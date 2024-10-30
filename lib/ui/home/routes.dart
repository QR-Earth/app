import 'package:flutter/material.dart';
import 'package:qr_earth/ui/home/pages/history_page.dart';
import 'package:qr_earth/ui/home/pages/home_page.dart';
import 'package:qr_earth/ui/home/pages/leaderboard_page.dart';
import 'package:qr_earth/ui/home/pages/redeem_page.dart';
import 'package:qr_earth/ui/home/pages/settings_page.dart';
import 'package:qr_earth/ui/home/screen.dart';
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
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: HomePage(),
          ),
          routes: [
            GoRoute(
              name: "redeem",
              path: "redeem",
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: RedeemPage(),
              ),
            )
          ],
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "leaderboard",
          path: "/home/leaderboard",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
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
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
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
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
