import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AuthScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('AuthScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        ),
        toolbarHeight: 0,
      ),
      body: navigationShell,
    );
  }
}
