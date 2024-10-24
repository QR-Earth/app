import 'package:flutter/foundation.dart';

class AppConfig {
  static const serverBaseUrl = kDebugMode
      ? "http://192.168.0.21:8000"
      : "https://qr-earth-bthhbwfcbxcvfrbp.eastus-01.azurewebsites.net";
}

class ApiRoutes {
  static const userLogin = "/users/login";
  static const userSignup = "/users/signup";
  static const userInfo = "/users/info";
  static const userTransactions = "/users/transactions";
  static const userRefreshAccessToken = "/users/refresh_token";

  static const leaderboard = "/public/leaderboard";
  static const totalUsers = "/public/total_users";

  static const codeRedeem = "/codes/redeem";
  static const codeValidate = "/codes/validate";
  static const codeCheckFixed = "/codes/check_fixed";
}
