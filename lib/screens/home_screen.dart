import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('HomeScreen'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        indicatorColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.lightGreen,
            ),
          ),
          NavigationDestination(
            label: 'Leaderboard',
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(
              Icons.leaderboard,
              color: Colors.lightGreen,
            ),
          ),
          NavigationDestination(
            label: 'History',
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(
              Icons.history,
              color: Colors.lightGreen,
            ),
          ),
          NavigationDestination(
            label: 'Settings',
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(
              Icons.settings,
              color: Colors.lightGreen,
            ),
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
