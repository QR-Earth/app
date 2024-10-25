import 'dart:io';
import 'package:flutter_update_checker/flutter_update_checker.dart';
import 'package:qr_earth/handlers/handle_logout.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/network/session.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void whereToGo() async {
    if (Session.userAccessToken != null) {
      final response = await ApiClient.userInfo();

      if (response.statusCode == HttpStatus.ok) {
        Global.user.setFromJson(response.data);
        if (mounted) return context.goNamed('home');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleLogout();
    });
  }

  void checkUpdate() async {
    final updateChecker = UpdateStoreChecker(
      // iosAppStoreId: 564177498,
      androidGooglePlayPackage: 'org.eu.mglsj.qr_earth',
    );

    try {
      bool isUpdateAvailable = await updateChecker.checkUpdate();
      if (isUpdateAvailable) {
        await updateChecker.update();
      } else {
        whereToGo();
      }
    } catch (e) {
      print(e);
    }
  }
}
