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
            ListTile(
              title: const Text("Logout"),
              onTap: () => showAdaptiveDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => AlertDialog.adaptive(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
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
