import 'package:qr_earth/router/router.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QR Earth',
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: defaultLightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: defaultDarkColorScheme,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
