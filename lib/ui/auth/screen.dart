import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_earth/utils/colors.dart';

class AuthScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AuthScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('AuthScreen'));

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: plainSystemUiOverlayStyle(context),
          toolbarHeight: 0,
        ),
        body: navigationShell,
      ),
    );
  }
}
