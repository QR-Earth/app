import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LoginScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('LoginScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
    );
  }
}
