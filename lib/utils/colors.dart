import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// https://docs.flutter.dev/platform-integration/android/predictive-back#set-up-your-app
const predictiveBackPageTransitionTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    // Set the predictive back transitions for Android.
    TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
  },
);

const keyColor = Color(0xFF509a72);

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: keyColor,
    brightness: Brightness.light,
    surface: Colors.white,
  ),
  useMaterial3: true,
  pageTransitionsTheme: predictiveBackPageTransitionTheme,
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: keyColor,
    brightness: Brightness.dark,
    surface: Colors.black,
  ),
  useMaterial3: true,
  pageTransitionsTheme: predictiveBackPageTransitionTheme,
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.black,
  ),
);

SystemUiOverlayStyle plainSystemUiOverlayStyle(BuildContext context) {
  return SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Theme.of(context).brightness,
    systemNavigationBarColor: Theme.of(context).colorScheme.surface,
    statusBarBrightness: Theme.of(context).brightness,
    statusBarColor: Theme.of(context).colorScheme.surface,
  );
}
