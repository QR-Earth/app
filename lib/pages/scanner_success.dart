import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

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
    final response = await http
        .get(Uri.parse('$BASEURL/get/user/by/user_id/?user_id=${USER.id}'));
    if (response.statusCode == 200) {
      // success
      USER.setFromJson(jsonDecode(response.body));
    }
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;
    context.goNamed('home');
  }
}
