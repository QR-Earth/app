import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qr_earth/network/api_factory.dart';
import 'package:qr_earth/network/routes.dart';
import 'package:qr_earth/utils/global.dart';

///ApiClient class is a wrapper for the ApiFactory class.
///
///It contains static methods that call the ApiFactory methods.
class ApiClient {
  static Future<void> init() async {
    await ApiFactory.init();
  }

  // user
  static Future<Response> login({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    return ApiFactory.post(
      ApiRoutes.userLogin,
      auth: false,
      data: jsonEncode({
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
      }),
    );
  }

  static Future<Response> signup({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String fullName,
  }) async {
    return ApiFactory.post(
      ApiRoutes.userSignup,
      auth: false,
      data: jsonEncode({
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
        "full_name": fullName,
      }),
    );
  }

  static Future<Response> userInfo() {
    return ApiFactory.get(
      ApiRoutes.userInfo,
      auth: true,
    );
  }

  static Future<Response> userTransactions({
    required int quantity,
  }) {
    return ApiFactory.get(
      ApiRoutes.userTransactions,
      auth: true,
      queryParameters: {
        "quantity": quantity,
      },
    );
  }

  // public
  static Future<Response> leaderboard({
    required int limit,
  }) async {
    return ApiFactory.get(
      ApiRoutes.leaderboard,
      auth: false,
      queryParameters: {
        "limit": limit,
      },
    );
  }

  static Future<Response> totalUsers() async {
    return ApiFactory.get(
      ApiRoutes.totalUsers,
      auth: false,
    );
  }

  // codes
  static Future<Response> codeCheckFixed({
    required String fixedCodeId,
  }) async {
    return ApiFactory.get(
      ApiRoutes.codeCheckFixed,
      auth: false,
      queryParameters: {
        "fixed_code_id": fixedCodeId,
      },
    );
  }

  static Future<Response> codeRedeem({
    required String code,
  }) async {
    return ApiFactory.post(
      ApiRoutes.codeRedeem,
      auth: false,
      data: {
        "code_id": code,
        "user_id": Global.user.id,
      },
    );
  }
}
