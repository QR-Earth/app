import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_earth/home/widgets/safe_padding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafePadding(
        child: ListView(
          children: [
            Image.asset(
              "assets/images/banner.png",
              width: 100,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: const Text("Log out", style: TextStyle(color: Colors.red)),
              onTap: () => showAdaptiveDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => AlertDialog.adaptive(
                  backgroundColor:
                      Theme.of(context).colorScheme.onInverseSurface,
                  title: const Text("Log out"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        // logout
                        var sharedpref = await SharedPreferences.getInstance();
                        sharedpref.clear();
                        context.goNamed("login");
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
