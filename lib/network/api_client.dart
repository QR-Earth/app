import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qr_earth/network/api_factory.dart';
import 'package:qr_earth/network/api_routes.dart';

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

  static Future<Response> userTransactions(
      {required int page, required int size}) {
    return ApiFactory.get(
      ApiRoutes.userTransactions,
      auth: true,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );
  }

  // public
  static Future<Response> leaderboard({
    required int page,
    required int size,
  }) async {
    return ApiFactory.get(
      ApiRoutes.leaderboard,
      auth: false,
      queryParameters: {
        "page": page,
        "size": size,
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
  static Future<Response> codeRedeem({
    required String code,
    required String binId,
  }) async {
    return ApiFactory.post(
      ApiRoutes.codeRedeem,
      auth: true,
      data: {
        "code_id": code,
        "bin_id": binId,
      },
    );
  }

  // bins
  static Future<Response> binInfo({
    required String binId,
  }) async {
    return ApiFactory.get(
      ApiRoutes.binInfo,
      auth: false,
      queryParameters: {
        "bin_id": binId,
      },
    );
  }
}
