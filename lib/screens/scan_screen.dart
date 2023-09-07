import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScanScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScanScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScanScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
    );
  }
}
