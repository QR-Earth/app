import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class Session {
  static const storage = FlutterSecureStorage();

  static const String _userAccessTokenKey = 'user_access_token';
  static const String _userRefreshTokenKey = 'user_refresh_token';

  static String? _userAccessToken;
  static String? _userRefreshToken;

  static String? get userAccessToken => _userAccessToken;
  static String? get userRefreshToken => _userRefreshToken;

  static Future<void> init() async {
    _userAccessToken = await storage.read(key: _userAccessTokenKey);
    _userRefreshToken = await storage.read(key: _userRefreshTokenKey);
  }

  static set userAccessToken(String? token) => {
        _userAccessToken = token,
        storage.write(key: _userAccessTokenKey, value: token),
      };

  static set userRefreshToken(String? token) => {
        _userRefreshToken = token,
        storage.write(key: _userRefreshTokenKey, value: token),
      };

  static void clear() async {
    _userAccessToken = null;
    _userRefreshToken = null;
    await storage.delete(key: _userAccessTokenKey);
    await storage.delete(key: _userRefreshTokenKey);
  }
}
