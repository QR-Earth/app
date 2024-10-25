import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_earth/handlers/handle_logout.dart';
import 'package:qr_earth/network/api_routes.dart';
import 'package:qr_earth/network/session.dart';

class FailedRequest {
  final DioException err;
  final ErrorInterceptorHandler handler;

  FailedRequest(this.err, this.handler);
}

class RefreshTokenInterceptor extends Interceptor {
  final List<FailedRequest> failedRequests = [];
  bool isRefreshing = false;
  RefreshTokenInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized &&
        err.response?.data['detail'] == 'Invalid token') {
      // If refresh token is not available, perform logout
      if ((Session.userRefreshToken ?? "").isEmpty) {
        handleLogout();
        return handler.reject(err);
      }

      failedRequests.add(FailedRequest(err, handler));

      if (!isRefreshing) {
        return await refreshAccessToken();
      }
    } else {
      // handle all exceptions that are not related to token on client side
      if (err.response != null) {
        return handler.resolve(err.response!);
      } else {
        return handler.next(err);
      }
    }
  }

  Future<void> refreshAccessToken() async {
    isRefreshing = true;
    if (kDebugMode) {
      print('Refreshing access token');
    }

    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: AppConfig.serverBaseUrl,
      ),
    );

    // handle refresh token
    var response = await retryDio.get(
      ApiRoutes.userRefreshAccessToken,
      options: Options(
        headers: {
          "Authorization": 'Bearer ${Session.userRefreshToken}',
        },
        validateStatus: (status) => true,
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      // response is string
      Session.userAccessToken = response.data["access_token"];
      Session.userRefreshToken = response.data["refresh_token"];
      await retryRequests();
    } else {
      isRefreshing = false;

      // Reject all failed requests
      for (var failedRequest in failedRequests) {
        if (failedRequest.err.response != null) {
          failedRequest.handler.resolve(failedRequest.err.response!);
        } else {
          failedRequest.handler.reject(failedRequest.err);
        }
      }

      failedRequests.clear();

      return handleLogout(message: "Session expired. Please log in again.");
    }
  }

  Future retryRequests() async {
    // Create a Dio instance for retrying requests
    Dio retryDio = Dio(
      BaseOptions(
        baseUrl: AppConfig.serverBaseUrl,
      ),
    );
    // Iterate through failed requests and retry them
    for (var failedRequest in failedRequests) {
      // Get the RequestOptions from the failed request
      RequestOptions requestOptions = failedRequest.err.requestOptions;

      // Update headers with the new access token
      requestOptions.headers = {
        'Authorization': 'Bearer ${Session.userAccessToken}',
      };

      // Retry the request using the new token
      await retryDio.fetch(requestOptions).then(
        failedRequest.handler.resolve,
        onError: (error) async {
          // Reject the request if an error occurs during retry
          failedRequest.handler.reject(error as DioException);
        },
      );
    }
    // Reset the refreshing state and clear the failed requests queue
    isRefreshing = false;
    failedRequests.clear();
  }
}
