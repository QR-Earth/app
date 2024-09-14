import 'package:flutter/material.dart';
import 'package:qr_earth/auth/pages/log_in_page.dart';
import 'package:qr_earth/auth/pages/sign_up_page.dart';
import 'package:qr_earth/auth/screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellRoute authRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return AuthScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "login",
          path: "/login",
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: LoginPage(
              key: UniqueKey(),
              username: state.uri.queryParameters['username'],
            ),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "signup",
          path: "/signup",
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: SignUpPage(
              key: UniqueKey(),
              username: state.uri.queryParameters['username'],
              email: state.uri.queryParameters['email'],
            ),
          ),
        ),
      ],
    ),
  ],
);
