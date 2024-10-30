import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_earth/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('HomeScreen'));

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        systemOverlayStyle: plainSystemUiOverlayStyle(context),
      ),
      body: (_) => navigationShell,
      selectedIndex: navigationShell.currentIndex,
      destinations: const [
        NavigationDestination(
          label: 'Home',
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
          ),
        ),
        NavigationDestination(
          label: 'Leaderboard',
          icon: Icon(Icons.leaderboard_outlined),
          selectedIcon: Icon(
            Icons.leaderboard,
          ),
        ),
        NavigationDestination(
          label: 'History',
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(
            Icons.history,
          ),
        ),
        NavigationDestination(
          label: 'Settings',
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(
            Icons.settings,
          ),
        ),
      ],
      onSelectedIndexChange: _goBranch,
    );
  }
}
