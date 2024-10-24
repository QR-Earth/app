import 'package:flutter/material.dart';
import 'package:qr_earth/handlers/handle_logout.dart';
import 'package:qr_earth/ui/home/widgets/safe_padding.dart';

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
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/banner.png",
              height: 200,
            ),
            const SizedBox(
              height: 20,
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
                    const TextButton(
                      onPressed: handleLogout,
                      child: Text("Yes"),
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
