import 'dart:convert';
import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';

class ScannerSuccessPage extends StatefulWidget {
  const ScannerSuccessPage({super.key});

  @override
  State<ScannerSuccessPage> createState() => _ScannerSuccessPageState();
}

class _ScannerSuccessPageState extends State<ScannerSuccessPage> {
  @override
  void initState() {
    super.initState();
    _goMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Congratulations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset('assets/images/asset1.png', width: 100),
          ],
        ),
      ),
    );
  }

  void _goMain() async {
    final response = await ApiClient.userInfo();

    if (response.statusCode == HttpStatus.ok) {
      Global.user.setFromJson(jsonDecode(response.data));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed('home');
    });
  }
}
