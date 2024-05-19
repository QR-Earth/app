import 'package:flutter/material.dart';
import 'package:qr_earth/utils/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'The Eco Club App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.lightGreen,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
