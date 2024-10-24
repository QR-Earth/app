import 'package:flutter/foundation.dart';
import 'package:qr_earth/network/session.dart';
import 'package:qr_earth/router/router.dart';
import 'package:qr_earth/utils/global.dart';

void handleLogin(Map<String, dynamic> response) async {
  if (kDebugMode) {
    print('Login response: $response');
  }
  // Set the user data
  Global.user.setFromJson(response["user"]);

  Session.userAccessToken = response["access_token"];
  Session.userRefreshToken = response["refresh_token"];

  appRouter.goNamed('home');
}
