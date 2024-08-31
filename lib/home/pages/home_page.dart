import 'package:qr_earth/home/widgets/safe_padding.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        leadingWidth: 60,
        titleSpacing: 0,
        leading: Center(child: Image.asset("assets/images/logo.png")),
        title: const Text('QR Earth'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed('scanner'),
        label: const Text("Scan QR"),
        icon: const Icon(Icons.qr_code_scanner_rounded),
      ),
      body: SafePadding(
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.account_circle,
                        size: 50.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'USERNAME',
                      style: TextStyle(
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      Global.user.username,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 2.0,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const Text(
                      'POINTS',
                      style: TextStyle(
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      Global.user.points.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 2.0,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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
