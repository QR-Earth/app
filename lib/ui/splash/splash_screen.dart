import 'dart:io';
import 'package:qr_earth/handlers/handle_logout.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/network/session.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _whereToGo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).colorScheme.surface,
            statusBarBrightness: Theme.of(context).brightness,
            statusBarColor: Theme.of(context).colorScheme.surface,
          ),
          toolbarHeight: 0,
        ),
        body: Center(
          child: Image.asset(
            'assets/images/banner.png',
            width: 300,
          ),
        ),
      ),
    );
  }

  void _whereToGo() async {
    if (Session.userAccessToken != null) {
      final response = await ApiClient.userInfo();

      if (response.statusCode == HttpStatus.ok) {
        Global.user.setFromJson(response.data);
        context.goNamed('home');
        return;
      }
    }

    handleLogout();
  }
}
