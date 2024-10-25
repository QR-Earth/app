import 'package:qr_earth/router/router.dart';
import 'package:qr_earth/utils/colors.dart';
import 'package:flutter/material.dart';

/// https://docs.flutter.dev/platform-integration/android/predictive-back#set-up-your-app
const predictiveBackPageTransitionTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    // Set the predictive back transitions for Android.
    TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
  },
);

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QR Earth',
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: defaultLightColorScheme,
        useMaterial3: true,
        pageTransitionsTheme: predictiveBackPageTransitionTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: defaultDarkColorScheme,
        useMaterial3: true,
        pageTransitionsTheme: predictiveBackPageTransitionTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
