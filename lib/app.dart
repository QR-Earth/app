import 'package:qr_earth/router/router.dart';
import 'package:qr_earth/utils/colors.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QR Earth',
      routerConfig: appRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
