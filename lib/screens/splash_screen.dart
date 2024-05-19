import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_earth/utils/constants.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Image(
            image: AssetImage('assets/images/eco_color.png'),
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }

  void _whereToGo() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getBool(KEYLOGIN) ?? false;
    if (isLoggedIn) {
      USER.id = sharedpref.getString(KEYID) ?? '';
      final response = await http
          .get(Uri.parse('$BASEURL/get/user/by/user_id/?user_id=${USER.id}'));
      if (!context.mounted) return;

      if (response.statusCode == 200) {
        // success
        USER.setFromJson(jsonDecode(response.body));
        context.go('/home');
      } else {
        context.go('/login/username');
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
      if (!context.mounted) return;
      context.go('/login/username');
    }
  }
}
