import 'dart:convert';
import 'dart:io';

import 'package:qr_earth/utils/constants.dart';
import 'package:qr_earth/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

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
    return const Scaffold(
      body: Center(child: Text("Success!")),
    );
  }

  void _goMain() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.serverBaseUrl}${ApiRoutes.userInfo}?user_id=${Global.user.id}'));
    if (response.statusCode == HttpStatus.ok) {
      // success
      Global.user.setFromJson(jsonDecode(response.body));
    }
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;
    context.goNamed('home');
  }
}
